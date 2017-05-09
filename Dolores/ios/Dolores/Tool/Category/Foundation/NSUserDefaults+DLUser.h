//
//  NSUserDefaults+DLUser.h
//  Dolores
//
//  Created by Heath on 19/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (DLUser)

+ (void)setLoginStatus:(BOOL)isLogin;

+ (BOOL)getLoginStatus;

+ (void)saveLastUser:(NSString *)user;

+ (NSString *)getLastUser;
@end
