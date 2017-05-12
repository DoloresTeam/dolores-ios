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

@end
