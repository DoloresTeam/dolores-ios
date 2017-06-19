//
//  NSUserDefaults+DLUser.m
//  Dolores
//
//  Created by Heath on 19/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <YYCategories/NSString+YYAdd.h>
#import "NSUserDefaults+DLUser.h"

static NSString *const kLastFetchQiniuToken = @"lastFetchQiniuTokenKey";
static NSString *const kQiniuToken = @"qiniuTokenKey";
static NSString *const kCurrentUser = @"CurrentUserKey";


@implementation NSUserDefaults (DLUser)

#pragma mark - public method

+ (void)saveLastFetchQiniuToken:(NSTimeInterval)timestamp {
    [self saveObject:@(timestamp) key:kLastFetchQiniuToken];
}

+ (BOOL)shouldFetchQiniuToken {
    NSNumber *timestamp = [self getObjectWithKey:kLastFetchQiniuToken];
    //  token有效期为5分钟
    return [[NSDate date] timeIntervalSince1970] - timestamp.doubleValue > 300;
}

+ (void)saveQiniuToken:(NSString *)qiniuToken {
    [self saveObject:qiniuToken key:kQiniuToken];
}

+ (NSString *)getQiniuToken {
    return [self getObjectWithKey:kQiniuToken];
}

+ (void)setCurrentUser:(NSString *)username {
    [self saveObject:username key:kCurrentUser];
}

+ (NSString *)getCurrentUser {
    return [self getObjectWithKey:kCurrentUser];
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
