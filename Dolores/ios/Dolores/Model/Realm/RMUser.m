//
//  RMUser.m
//  Dolores
//
//  Created by Heath on 17/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <YYCategories/NSDate+YYAdd.h>
#import <YYCategories/NSString+YYAdd.h>
#import "RMUser.h"

@implementation RMUser

+ (NSString *)primaryKey {
    return @"uid";
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

#pragma mark - public method

- (NSDate *)tokenExpireDate {
    if ([self.expireDate isNotBlank]) {
        // GMT +8
        return [NSDate dateWithString:self.expireDate format:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:28800] locale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    } else {
        return nil;
    }
}


@end
