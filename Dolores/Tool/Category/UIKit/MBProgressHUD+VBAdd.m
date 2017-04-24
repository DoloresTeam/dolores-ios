//
//  MBProgressHUD+VBAdd.m
//  VoiceBook
//
//  Created by Heath on 16/8/1.
//  Copyright © 2016年 Heath. All rights reserved.
//

#import "MBProgressHUD+VBAdd.h"

@implementation MBProgressHUD (VBAdd)

+ (instancetype)vb_HUDForView:(UIView *)view {
    if (!view) {
        return nil;
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.cornerRadius = 6.f;
    hud.dimBackground = NO;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.labelFont = [UIFont baseFont:14];
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD vb_HUDForView:view];
    hud.labelText = message;
}

+ (void)showCustomView:(UIView *)customView text:(NSString *)text toView:(UIView *)view hideDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD vb_HUDForView:view];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = customView;
    hud.labelText = text;
    hud.userInteractionEnabled = NO;
    [hud hide:YES afterDelay:delay];
}

+ (void)showInfo:(NSString *)info toView:(UIView *)view hideDelay:(NSTimeInterval)delay {
    [MBProgressHUD showCustomView:[UIView new] text:info toView:view hideDelay:delay];
}

+ (void)showError:(NSString *)error toView:(UIView *)view hideDelay:(NSTimeInterval)delay {
    [MBProgressHUD showCustomView:[UIView new] text:error toView:view hideDelay:delay];
}

+ (void)showSuccess:(NSString *)tip toView:(UIView *)view hideDelay:(NSTimeInterval)delay {
    [MBProgressHUD showCustomView:[UIView new] text:tip toView:view hideDelay:delay];
}

+ (void)showFooterText:(NSString *)text toView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD vb_HUDForView:view];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    CGFloat height = CGRectGetHeight(view.frame);
    hud.yOffset = height / 2 - 88;
    hud.margin = 8;
    hud.opacity = 0.7;
    hud.userInteractionEnabled = NO;
    hud.animationType = MBProgressHUDAnimationFade;
    [hud hide:YES afterDelay:1.0];
}

@end
