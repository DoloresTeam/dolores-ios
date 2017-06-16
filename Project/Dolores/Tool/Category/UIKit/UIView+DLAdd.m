//
//  UIView+DLAdd.m
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "UIView+DLAdd.h"

@implementation UIView (DLAdd)

+ (instancetype)initWithColor:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    return view;
}

- (void)convenienceLayout {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
