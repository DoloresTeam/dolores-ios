//
//  DLSettingConfig.h
//  Dolores
//
//  Created by Heath on 26/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLSettingConfig : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL showMore;
@property (nonatomic, assign) BOOL showSwitch;

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content showMore:(BOOL)showMore showSwitch:(BOOL)showSwitch;

+ (instancetype)configWithTitle:(NSString *)title content:(NSString *)content showMore:(BOOL)showMore showSwitch:(BOOL)showSwitch;


@end
