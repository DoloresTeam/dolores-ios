//
//  DLNativeBridgeHelper.m
//  Dolores
//
//  Created by Heath on 09/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "DLNativeBridgeHelper.h"

@implementation DLNativeBridgeHelper

+ (instancetype)sharedInstance {
  static DLNativeBridgeHelper *_sharedNativeBridgeHelper = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedNativeBridgeHelper = [[DLNativeBridgeHelper alloc] init];
  });
  
  return _sharedNativeBridgeHelper;
  
}

@end
