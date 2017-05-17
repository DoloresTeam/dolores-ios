//
//  RMStaff.h
//  Dolores
//
//  Created by Heath on 10/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Realm/Realm.h>
/**
 * 员工信息表
 */
@interface RMStaff : RLMObject

@property NSString *uid; //用户id
@property NSString *easemobAccount; //环信id
@property NSString *realName; //真实名
@property NSString *nickName; //显示名

@property NSString *title; //职位，可能多个，";"分割
@property NSString *signature; //签名
@property NSString *avatarURL; //头像URL
@property NSString *email; //可能多个,";"分割
@property NSString *mobile;
@property NSNumber<RLMInt> *gender; //性别，0: 女 1: 男
// 反转，隶属于部门列表
@property (readonly) RLMLinkingObjects *belongs;

- (instancetype)initWithDict:(NSDictionary *)dictionary;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RMStaff>
RLM_ARRAY_TYPE(RMStaff)
