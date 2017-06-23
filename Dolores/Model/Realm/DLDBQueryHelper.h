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

/**
 * 获得神秘人员
 * @return
 */
+ (RLMResults<RMStaff *> *)mysteriousStaffs;

+ (RLMResults<RMStaff *> *)allOtherStaffs;

/**
 * 获取常用联系人
 * @return
 */
+ (NSArray<RMStaff *> *)frequentStaffs;

+ (RLMResults<RMStaff *> *)queryStaffWithKeyword:(NSString *)keyword;

+ (BOOL)isLogin;

+ (void)saveLoginUser:(NSDictionary *)dict;

@end

