//
//  NSUserDefaults+DLUser.m
//  Dolores
//
//  Created by Heath on 19/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "NSUserDefaults+DLUser.h"

static NSString *const kIsLogin = @"isLoginKey";
static NSString *const kLastLoginUser = @"lastLoginUserKey";
static NSString *const kLastFetchQiniuToken = @"lastFetchQiniuTokenKey";
static NSString *const kDoloresToken = @"DoloresTokenKey";


@implementation NSUserDefaults (DLUser)

#pragma mark - public method

+ (void)setLoginStatus:(BOOL)isLogin {
    [self saveObject:@(isLogin) key:kIsLogin];
}

+ (BOOL)getLoginStatus {
    NSNumber *status = [self getObjectWithKey:kIsLogin];
    return [status boolValue];
}

+ (void)saveLastUser:(NSString *)user {
    [self saveObject:user ? : @"" key:kLastLoginUser];
}

+ (NSString *)getLastUser {
    return [self getObjectWithKey:kLastLoginUser];
}

+ (void)saveLastFetchQiniuToken:(NSTimeInterval)timestamp {
    [self saveObject:@(timestamp) key:kLastFetchQiniuToken];
}

+ (BOOL)shouldFetchQiniuToken {
    NSNumber *timestamp = [self getObjectWithKey:kLastFetchQiniuToken];
    //  token有效期为5分钟
    return [[NSDate date] timeIntervalSince1970] - timestamp.doubleValue > 300;
}

+ (void)saveDoloresToken:(NSString *)token {
    [self saveObject:token key:kDoloresToken];
}

+ (NSString *)getDoloresToken {
    return [self getObjectWithKey:kDoloresToken];
}

#pragma mark - private method

+ (void)saveObject:(id)obj key:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
}

+ (id)getObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

@end
