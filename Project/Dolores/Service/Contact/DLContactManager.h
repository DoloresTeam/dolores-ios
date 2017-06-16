//
//  DLContactManager.h
//  Dolores
//
//  Created by Heath on 12/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SharedContactManager [DLContactManager sharedInstance]

@interface DLContactManager : NSObject

+ (instancetype)sharedInstance;

- (void)syncOrganization;

- (void)fetchOrganization;
@end
