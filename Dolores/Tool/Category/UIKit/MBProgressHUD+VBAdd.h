//
//  MBProgressHUD+VBAdd.h
//  VoiceBook
//
//  Created by Heath on 16/8/1.
//  Copyright © 2016年 Heath. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (VBAdd)

+ (instancetype)vb_HUDForView:(UIView *)view;

+ (void)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)showInfo:(NSString *)info toView:(UIView *)view hideDelay:(NSTimeInterval)delay;

+ (void)showError:(NSString *)error toView:(UIView *)view hideDelay:(NSTimeInterval)delay;

+ (void)showSuccess:(NSString *)tip toView:(UIView *)view hideDelay:(NSTimeInterval)delay;

+ (void)showFooterText:(NSString *)text toView:(UIView *)view;

@end
