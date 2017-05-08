//
//  DLSettingConfig.m
//  Dolores
//
//  Created by Heath on 26/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLSettingConfig.h"

@implementation DLSettingConfig

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content showMore:(BOOL)showMore showSwitch:(BOOL)showSwitch {
    self = [super init];
    if (!self) return nil;

    self.title = title;
    self.content = content;
    self.showMore = showMore;
    self.showSwitch = showSwitch;

    return self;
}

+ (instancetype)configWithTitle:(NSString *)title content:(NSString *)content showMore:(BOOL)showMore showSwitch:(BOOL)showSwitch {
    return [[self alloc] initWithTitle:title content:content showMore:showMore showSwitch:showSwitch];
}


@end
