//
//  UIBarButtonItem+DLAdd.m
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "UIBarButtonItem+DLAdd.h"
#import "NSString+YYAdd.h"

@implementation UIBarButtonItem (DLAdd)

+ (UIBarButtonItem *)initWithTitle:(NSString *)title target:(id)target action:(SEL)action {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont baseBoldFont:16];
    CGFloat width = [title widthForFont:[UIFont baseBoldFont:16]];
    if (width < 44) {
        width = 44;
    }
    button.frame = CGRectMake(0, 0, width, 44);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

@end
