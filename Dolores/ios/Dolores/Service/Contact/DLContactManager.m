//
//  DLContactManager.m
//  Dolores
//
//  Created by Heath on 12/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLContactManager.h"
#import "DLNetworkService.h"

@implementation DLContactManager

+ (instancetype)sharedInstance {
    static DLContactManager *_sharedContactManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedContactManager = [[DLContactManager alloc] init];
    });
    
    return _sharedContactManager;
}

- (void)fetchOrganization {
    [[SharedNetwork rac_GET:@"/organization" parameters:@{}] subscribeNext:^(RACTuple *tuple) {
        NSDictionary *resp = tuple.first;
    } error:^(NSError *error) {
        
    }];
}

@end
