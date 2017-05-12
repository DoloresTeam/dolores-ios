//
//  RMCompany.h
//  Dolores
//
//  Created by Heath on 10/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Realm/Realm.h>
#import "RMDepartment.h"

// This protocol enables typed collections. i.e.:
// RLMArray<RMCompany>
RLM_ARRAY_TYPE(RMCompany)

@interface RMCompany : RLMObject

@property NSString *cid;
@property NSString *name;
@property RLMArray<RMDepartment *><RMDepartment> *departments;

@end


