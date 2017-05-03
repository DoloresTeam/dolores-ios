//
//  DLUser.m
//  Dolores
//
//  Created by Heath on 27/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLUser.h"

@implementation DLUser

- (instancetype)initWithBuddy:(NSString *)buddy {
    self = [super initWithBuddy:buddy];
    if (!self) return nil;

    self.nickname = buddy;

    return self;
}


@end
