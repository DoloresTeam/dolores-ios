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

@property NSString *uid;
@property NSString *userName;
@property NSString *nickName;
@property NSString *avatarURL;
// 反转，隶属于部门列表
@property (readonly) RLMLinkingObjects *belongs;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RMStaff>
RLM_ARRAY_TYPE(RMStaff)
