//
//  RMStaff.m
//  Dolores
//
//  Created by Heath on 10/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "RMStaff.h"
#import "RMDepartment.h"
#import <YYCategories.h>

@implementation RMStaff

+ (NSString *)primaryKey {
    return @"uid";
}

+ (NSDictionary<NSString *,RLMPropertyDescriptor *> *)linkingObjectsProperties {
    return @{@"belongs": [RLMPropertyDescriptor descriptorWithClass:[RMDepartment class] propertyName:@"staffs"]};
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

- (instancetype)initWithDict:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _uid = dictionary[@"id"];
        _nickName = dictionary[@"name"];
        _realName = dictionary[@"cn"];
        NSString *avatarURI = dictionary[@"labeledURI"];

        if ([avatarURI isNotBlank]) {
            _avatarURL = [NSString stringWithFormat:@"%@/%@", kQiuniuURLPrefix, avatarURI];
        }

        NSString *gender = dictionary[@"gender"];
        _gender = @(gender.integerValue);
        _mobile = dictionary[@"telephoneNumber"];
        _easemobAccount = dictionary[@"thirdAccount"];

        NSArray *emails = dictionary[@"email"];
        _email = [emails componentsJoinedByString:@","];
        _title = dictionary[@"title"];
    }
    return self;
}


@end
