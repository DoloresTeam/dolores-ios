//
//  DLDBQueryHelper.m
//  Dolores
//
//  Created by Heath on 12/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLDBQueryHelper.h"

@implementation DLDBQueryHelper

+ (void)configDefaultRealmDB:(NSString *)username {
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    uint64_t version = 4;
    configuration.schemaVersion = version;
    configuration.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < version) {

        }
    };
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = paths[0];
    configuration.fileURL = [[NSURL URLWithString:[cacheDirectory stringByAppendingPathComponent:username]] URLByAppendingPathExtension:@"realm"];
    [RLMRealmConfiguration setDefaultConfiguration:configuration];
//    [RLMRealm defaultRealm];
    NSLog(@"realm db path: %@", configuration.fileURL);
}

+ (RLMResults<RMStaff *> *)mysteriousStaffs {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isMysterious = %@", @(YES)];
    RLMResults<RMStaff *> *results = [RMStaff objectsWithPredicate:predicate];
    return results;
}

+ (RLMResults<RMDepartment *> *)departmentsInList:(NSArray *)idList {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"departmentId IN %@", idList];
    RLMResults<RMDepartment *> *results = [RMDepartment objectsWithPredicate:predicate];
    return results;
}

+ (RLMResults<RMDepartment *> *)rootDepartments {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentId = NULL"];
    RLMResults<RMDepartment *> *results = [RMDepartment objectsWithPredicate:predicate];
    RLMSortDescriptor *sortPriorty = [RLMSortDescriptor sortDescriptorWithKeyPath:@"priority" ascending:NO];
    RLMSortDescriptor *sortName = [RLMSortDescriptor sortDescriptorWithKeyPath:@"departmentName" ascending:YES];
    results = [results sortedResultsUsingDescriptors:@[sortPriorty, sortName]];
    return results;
}

+ (RMUser *)currentUser {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLogin = %@", @(YES)];
    RLMResults<RMUser *> *results = [RMUser objectsWithPredicate:predicate];
    if (results.count > 0) {
        return [results objectAtIndex:0];
    }
    return nil;
}

+ (RLMResults<RMUser *> *)userList {
    RLMResults<RMUser *> *users = [[RMUser allObjects] sortedResultsUsingKeyPath:@"logoutTimestamp" ascending:NO];
    return users;
}

+ (RLMResults<RMStaff *> *)allOtherStaffs {
    RMUser *currentUser = [self currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid != %@", currentUser.staff.uid];
    RLMResults<RMStaff *> *results = [RMStaff objectsWithPredicate:predicate];
    return results;
}

+ (NSArray<RMStaff *> *)frequentStaffs {

    RMUser *currentUser = [self currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid != %@ AND frequent > 0", currentUser.staff.uid];
    RLMResults<RMStaff *> *staffs = [RMStaff objectsWithPredicate:predicate];

    RLMSortDescriptor *sortDescriptor = [RLMSortDescriptor sortDescriptorWithKeyPath:@"frequent" ascending:NO];
    staffs = [staffs sortedResultsUsingDescriptors:@[sortDescriptor]];
    // we add the first ten staff.
    NSMutableArray<RMStaff *> *list = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < staffs.count; ++i) {
        if (i >= 10) {
            break;
        }
        [list addObject:staffs[i]];
    }
    return list;
}

+ (BOOL)isLogin {
    return [self currentUser].isLogin.boolValue;
}

+ (void)saveLoginUser:(NSDictionary *)dict {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    RMStaff *staff = [[RMStaff alloc] initWithDict:dict];
    [realm addOrUpdateObject:staff];
    RMUser *user = [DLDBQueryHelper currentUser];
    
    if (user && ![user isInvalidated]) {
        if (dict[@"telephoneNumber"]) {
            user.userName = dict[@"telephoneNumber"];
        }
        user.staff = staff;
        [realm addOrUpdateObject:user];
    } else {
        RMUser *user = [[RMUser alloc] init];
        if (dict[@"id"]) {
            user.uid = dict[@"id"];
        }
        if (dict[@"telephoneNumber"]) {
            user.userName = dict[@"telephoneNumber"];
        }
        
        user.staff = staff;
        [realm addOrUpdateObject:user];
    }
    
    [realm commitWriteTransaction];
}


@end
