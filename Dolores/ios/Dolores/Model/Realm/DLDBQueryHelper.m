//
//  DLDBQueryHelper.m
//  Dolores
//
//  Created by Heath on 12/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLDBQueryHelper.h"
#import "RMDepartment.h"


@implementation DLDBQueryHelper

+ (RLMResults<RMDepartment *> *)departmentsInList:(NSArray *)idList {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"departmentId IN %@", idList];
    RLMResults<RMDepartment *> *results = [RMDepartment objectsWithPredicate:predicate];
    return results;
}

@end
