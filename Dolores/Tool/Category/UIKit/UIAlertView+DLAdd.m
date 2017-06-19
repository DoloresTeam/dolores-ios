//
//  UIAlertView+DLAdd.m
//  Dolores
//
//  Created by Heath on 19/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "UIAlertView+DLAdd.h"

@implementation UIAlertView (DLAdd)

+ (void)alertSettingPhoto {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *message = @"请您设置允许Dolores访问您的相册\n设置>隐私>照片";
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    });
}

+ (void)alertSettingCamera {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *message = @"请您设置允许Dolores访问您的相机\n设置>隐私>相机";
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    });
}

@end
