//
//  RMUser.h
//  Dolores
//
//  Created by Heath on 17/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <Realm/Realm.h>

// This protocol enables typed collections. i.e.:
// RLMArray<RMUser>
RLM_ARRAY_TYPE(RMUser)

@interface RMUser : RLMObject

@property NSString *uid;
@property NSString *token;
@property NSString *expireDate;
@property NSNumber<RLMBool> *isLogin;
@property NSString *userName;
@property NSNumber<RLMDouble> *logoutTimestamp;
@property NSString *orgVersion;

@property RMStaff *staff;

- (NSDate *)tokenExpireDate;

@end


