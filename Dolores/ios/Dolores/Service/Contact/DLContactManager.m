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

    [[SharedNetwork rac_GET:@"/api/v1/organization" parameters:@{}] subscribeNext:^(NSDictionary *resp) {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            // remove all data, then add.
            RLMResults *allDeps = [RMDepartment allObjects];
            RLMResults *otherStaffs = [DLDBQueryHelper allOtherStaffs];
            [realm beginWriteTransaction];
            [realm deleteObjects:otherStaffs];
            [realm deleteObjects:allDeps];
            [realm commitWriteTransaction];

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
        
        RMStaff *rmStaff = [RMStaff objectForPrimaryKey:uid];
        if (!rmStaff || [rmStaff isInvalidated]) {
            rmStaff = [[RMStaff alloc] initWithDict:staffDict];
        }
        
        [realm beginWriteTransaction];
        // update user.
        [realm addOrUpdateObject:rmStaff];
        
        // check add add to department.
        NSArray *belongDepartments = staffDict[@"unitID"];
        if (belongDepartments.count > 0) {
            RLMResults<RMDepartment *> *staffDepartments = [DLDBQueryHelper departmentsInList:belongDepartments];
            for (int i = 0; i < staffDepartments.count; ++i) {
                RMDepartment *department = [staffDepartments objectAtIndex:i];
                if (!department.isInvalidated) {
                    
                    // if staff has add to deparent, do nothing.
                    NSInteger index = [department.staffs indexOfObject:rmStaff];
                    if (index == NSNotFound) {
                        [department.staffs addObject:rmStaff];
                        [realm addOrUpdateObject:department];
                    }
                }
            }
        }
        
        [realm commitWriteTransaction];
    }
}

- (void)addOrUpdateDepartment:(NSDictionary *)departmentDict realm:(RLMRealm *)realm {
    NSString *dpId = departmentDict[@"id"];

    if (dpId) {
        
        NSString *priority = departmentDict[@"priority"];
        NSNumber *priorityValue = @(0);
        if (priority) {
            priorityValue = @(priority.integerValue);
        }
        
        // query from db first, if not exist, create it.
        RMDepartment *rmDepartment = [RMDepartment objectForPrimaryKey:dpId];
        if (!rmDepartment || [rmDepartment isInvalidated]) {
            rmDepartment = [[RMDepartment alloc] initWithId:dpId name:departmentDict[@"ou"] description:departmentDict[@"description"]];
        }
        
        [realm beginWriteTransaction];
        
        rmDepartment.priority = priorityValue;
        [realm addOrUpdateObject:rmDepartment];
        
        NSString *parentId = departmentDict[@"parentID"];
        if (![NSString isEmpty:parentId]) {
            RMDepartment *parentDep = [RMDepartment objectForPrimaryKey:parentId];
            if (parentDep && ![parentDep isInvalidated]) {
                
                rmDepartment.parentId = parentId;
                [realm addOrUpdateObject:rmDepartment];
                
                // if child has add to parent, do nothing.
                NSInteger index = [parentDep.childrenDepartments indexOfObject:rmDepartment];
                if (index == NSNotFound) {
                    [parentDep.childrenDepartments addObject:rmDepartment];
                    [realm addOrUpdateObject:parentDep];
                }
                
            }
        }
        
        [realm commitWriteTransaction];
        
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
