//
//  UIButton+Addition.m
//  CategoryCollection
//
//  Created by Heath on 27/03/2017.
//  Copyright © 2017 Heath. All rights reserved.
//

#import "UIButton+Addition.h"
#import "UIImage+Addition.h"

@implementation UIButton (Addition)

+ (instancetype)buttonWithFont:(UIFont *)font title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    return button;
}

+ (instancetype)buttonWithFont:(UIFont *)font title:(NSString *)title textColor:(UIColor *)color {
    UIButton *button = [UIButton buttonWithFont:font title:title];
    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

+ (instancetype)buttonWithFont:(UIFont *)font title:(NSString *)title textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor {
    UIButton *button = [UIButton buttonWithFont:font title:title textColor:color];
    [button setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateNormal];
    return button;
}

+ (instancetype)buttonWithFont:(UIFont *)font title:(NSString *)title textColor:(UIColor *)color cornerRadius:(CGFloat)radius {
    UIButton *button = [UIButton buttonWithFont:font title:title textColor:color];
    button.layer.cornerRadius = radius;
    return button;
}

+ (instancetype)buttonWithNormalImage:(UIImage *)normalImg highlightedImage:(UIImage *)highlightedImg {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImg forState:UIControlStateNormal];
    [button setImage:highlightedImg forState:UIControlStateHighlighted];
    return button;
}


@end
