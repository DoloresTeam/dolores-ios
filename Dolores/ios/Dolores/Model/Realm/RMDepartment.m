//
//  RMDepartment.m
//  Dolores
//
//  Created by Heath on 10/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "RMDepartment.h"

@implementation RMDepartment

+ (NSArray *)indexedProperties {
    return @[@"departmentId"];
}

+ (NSString *)primaryKey {
    return @"departmentId";
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

- (instancetype)initWithId:(NSString *)id1 name:(NSString *)name description:(NSString *)description {
    self = [super init];
    if (self) {
        _departmentId = id1;
        _departmentName = name;
        _departmentDes = description;
    }
    return self;
}


@end
