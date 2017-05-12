//
//  DLDBQueryHelper.h
//  Dolores
//
//  Created by Heath on 12/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm.h>
#import "RMDepartment.h"

@interface DLDBQueryHelper : NSObject

+ (RLMResults<RMDepartment *> *)departmentsInList:(NSArray *)idList;

@end
