//
//  DLContactManager.m
//  Dolores
//
//  Created by Heath on 12/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLContactManager.h"
#import "DLNetworkService.h"
#import "RLMRealm.h"
#import "RMDepartment.h"
#import "NSString+YYAdd.h"
#import "DLDBQueryHelper.h"
#import "DLNetworkService+DLAPI.h"

NSString *const kDBAddAction    = @"add";
NSString *const kDBUpdateAction = @"update";
NSString *const kDBDeleteAction = @"delete";

NSString *const kTypeMember     = @"member";
NSString *const kTypeDepartment = @"department";

@implementation DLContactManager

+ (instancetype)sharedInstance {
    static DLContactManager *_sharedContactManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedContactManager = [[DLContactManager alloc] init];
    });
    
    return _sharedContactManager;
}

- (void)syncOrganization {
    [[DLNetworkService syncOrganization:[DLDBQueryHelper currentUser].orgVersion] subscribeNext:^(NSDictionary *resp) {
        NSNumber *needRefetchOrganization = resp[@"needRefetchOrganization"];
        if (needRefetchOrganization.boolValue) {
            [self fetchOrganization];
        } else {
            [self handleUpdateResult:resp];
        }
    } error:^(NSError *error) {

    }];
}

- (void)fetchOrganization {
    RMUser *user = [DLDBQueryHelper currentUser];
    if ([user.orgVersion isNotBlank] && user.orgVersion.length > @"20170611132456".length) {
        return;
    }

    [[SharedNetwork rac_GET:@"/api/v1/organization" parameters:@{}] subscribeNext:^(NSDictionary *resp) {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            RLMRealm *realm = [RLMRealm defaultRealm];

            RMUser *loginUser = [DLDBQueryHelper currentUser];
            if (![loginUser isInvalidated]) {
                [realm transactionWithBlock:^{
                    loginUser.orgVersion = resp[@"version"];
                }];
            }

            NSArray *departments = resp[@"departments"];

            for (NSDictionary *departmentDict in departments) {
                @autoreleasepool {

                    [self addOrUpdateDepartment:departmentDict realm:realm];

                }
            }


            NSArray *staffs = resp[@"members"];
            for (NSDictionary *staffDict in staffs) {
                @autoreleasepool {

                    [self addOrUpdateStaff:staffDict realm:realm];

                }

            }

        });


    } error:^(NSError *error) {
        
    }];
}

- (void)handleUpdateResult:(NSDictionary *)resp {
    id logsObj = resp[@"logs"];
    if (!logsObj || [logsObj isKindOfClass:[NSNull class]]) {
        return;
    }

    // sort first.
    NSArray *logs = logsObj;
    if (logs.count > 0) {
        logs = [logs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *timestamp1 = [obj1 objectForKey:@"createTimestamp"];
            NSString *timestamp2 = [obj2 objectForKey:@"createTimestamp"];
            return [timestamp1 compare:timestamp2];
        }];

        RLMRealm *realm = [RLMRealm defaultRealm];
        [self updateVersion:resp[@"version"] realm:realm];
        for (NSDictionary *dict in logs) {

            @autoreleasepool {

                NSString *action = dict[@"action"];
                NSString *category = dict[@"category"];

                if ([category isEqualToString:kTypeMember]) {
                    NSArray *contents = dict[@"content"];

                    if ([action isEqualToString:kDBAddAction] || [action isEqualToString:kDBUpdateAction]) {

                        for (NSDictionary *content in contents) {
                            [self addOrUpdateStaff:content realm:realm];
                        }

                    } else if ([action isEqualToString:kDBDeleteAction]) {
                        for (NSDictionary *content in contents) {
                            NSString *uid = content[@"id"];
                            if (uid) {
                                RMStaff *staff = [RMStaff objectForPrimaryKey:uid];

                                if (![staff isInvalidated]) {
                                    [realm transactionWithBlock:^{
                                        [realm deleteObject:staff];
                                    }];
                                }

                            }
                        }
                    }
                } else if ([category isEqualToString:kTypeDepartment]) {
                    NSArray *contents = dict[@"content"];

                    if ([action isEqualToString:kDBAddAction] || [action isEqualToString:kDBUpdateAction]) {

                        for (NSDictionary *content in contents) {
                            [self addOrUpdateDepartment:content realm:realm];
                        }
                    } else if ([action isEqualToString:kDBDeleteAction]) {

                        for (NSDictionary *content in contents) {
                            NSString *did = content[@"id"];
                            if (did) {
                                RMDepartment *department = [RMDepartment objectForPrimaryKey:did];

                                if (![department isInvalidated]) {
                                    [realm transactionWithBlock:^{
                                        [realm deleteObject:department];
                                    }];
                                }

                            }
                        }
                    }
                }

            }
            
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserOrganizationChangedNotification object:nil];
        });
    } else {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [self updateVersion:resp[@"version"] realm:realm];
    }

}

- (void)addOrUpdateStaff:(NSDictionary *)staffDict realm:(RLMRealm *)realm {
    NSString *uid = staffDict[@"id"];
    if (uid) {
        RMStaff *rmStaff = [[RMStaff alloc] initWithDict:staffDict];
        NSArray *belongDepartments = staffDict[@"unitID"];

        if (belongDepartments.count > 0) {
            RLMResults<RMDepartment *> *staffDepartments = [DLDBQueryHelper departmentsInList:belongDepartments];
            [realm beginWriteTransaction];
            [realm addOrUpdateObject:rmStaff];
            for (int i = 0; i < staffDepartments.count; ++i) {
                RMDepartment *department = [staffDepartments objectAtIndex:i];
                if (!department.isInvalidated) {
                    NSInteger index = [department.staffs indexOfObject:rmStaff];
                    if (index != NSNotFound) {
                        [department.staffs removeObjectAtIndex:index];
                    }
                    [department.staffs addObject:rmStaff];
                    [realm addOrUpdateObject:department];
                }
            }
            [realm commitWriteTransaction];
        }
    }
}

- (void)addOrUpdateDepartment:(NSDictionary *)departmentDict realm:(RLMRealm *)realm {
    NSString *dpId = departmentDict[@"id"];

    if (dpId) {
        RMDepartment *rmDepartment = [[RMDepartment alloc] initWithId:dpId name:departmentDict[@"ou"] description:departmentDict[@"description"]];
        NSString *parentId = departmentDict[@"pid"];
        if ([parentId isNotBlank]) {
            RMDepartment *parentDep = [RMDepartment objectForPrimaryKey:parentId];
            if (!parentDep.isInvalidated) {

                [realm beginWriteTransaction];
                rmDepartment.parentDep = parentDep;
                [realm addOrUpdateObject:rmDepartment];
                [parentDep.childrenDepartments addObject:rmDepartment];
                [realm addOrUpdateObject:parentDep];
                [realm commitWriteTransaction];
            }
        } else {

            [realm beginWriteTransaction];
            [realm addOrUpdateObject:rmDepartment];
            [realm commitWriteTransaction];
        }
    }
}

- (void)updateVersion:(NSString *)version realm:(RLMRealm *)realm {

    if (!version) {
        return;
    }

    RMUser *user = [DLDBQueryHelper currentUser];
    if (![user isInvalidated]) {
        [realm beginWriteTransaction];
        user.orgVersion = version;
        [realm commitWriteTransaction];
    }
}

@end
