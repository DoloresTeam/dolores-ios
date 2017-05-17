//
//  NSUserDefaults+DLUser.h
//  Dolores
//
//  Created by Heath on 19/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (DLUser)

+ (void)saveLastFetchQiniuToken:(NSTimeInterval)timestamp;
+ (BOOL)shouldFetchQiniuToken;

+ (void)saveQiniuToken:(NSString *)qiniuToken;
+ (NSString *)getQiniuToken;

+ (void)setCurrentUser:(NSString *)username;
+ (NSString *)getCurrentUser;

@end
