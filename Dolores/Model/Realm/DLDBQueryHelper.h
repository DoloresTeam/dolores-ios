//
//  DLDBQueryHelper.h
//  Dolores
//
//  Created by Heath on 12/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm.h>
#import "RMDepartment.h"
#import "RMUser.h"
#import "RMStaff.h"

@interface DLDBQueryHelper : NSObject

+ (void)configDefaultRealmDB:(NSString *)username;

+ (RLMResults<RMDepartment *> *)departmentsInList:(NSArray *)idList;

+ (RLMResults<RMDepartment *> *)rootDepartments;

+ (RMUser *)currentUser;

+ (RLMResults<RMUser *> *)userList;

+ (RLMResults<RMStaff *> *)allOtherStaffs;

+ (BOOL)isLogin;

+ (void)saveLoginUser:(NSDictionary *)dict;

@end

