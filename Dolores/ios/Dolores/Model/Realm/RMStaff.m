//
//  RMStaff.m
//  Dolores
//
//  Created by Heath on 10/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "RMStaff.h"
#import "RMDepartment.h"

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
        _avatarURL = dictionary[@"labeledURI"];
        _gender = dictionary[@"gender"];
        _mobile = dictionary[@"telephoneNumber"];
        _easemobAccount = dictionary[@"thirdAccount"];

        NSArray *emails = dictionary[@"email"];
        _email = [emails componentsJoinedByString:@","];

        NSArray *titles = dictionary[@"title"];
        _title = [titles componentsJoinedByString:@","];
    }
    return self;
}


@end
