//
//  UILabel+Addition.m
//  CategoryCollection
//
//  Created by Heath on 27/03/2017.
//  Copyright © 2017 Heath. All rights reserved.
//

#import "UILabel+Addition.h"

@implementation UILabel (Addition)

+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment {
    UILabel *label = [UILabel new];
    label.textAlignment = alignment;
    return label;
}

+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor {
    UILabel *label = [UILabel labelWithAlignment:alignment];
    label.textColor = textColor;
    return label;
}

+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor font:(UIFont *)font {
    UILabel *label = [UILabel labelWithAlignment:alignment textColor:textColor];
    label.font = font;
    return label;
}

+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor font:(UIFont *)font text:(NSString *)text {
    UILabel *label = [UILabel labelWithAlignment:alignment textColor:textColor font:font];
    label.text = text;
    return label;
}

+ (UILabel *)labelWithAlignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor font:(UIFont *)font lines:(NSInteger)lines {
    UILabel *label = [UILabel labelWithAlignment:alignment textColor:textColor font:font];
    label.numberOfLines = lines;
    return label;
}

+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor font:(UIFont *)font lines:(NSInteger)lines text:(NSString *)text {
    UILabel *label = [UILabel labelWithAlignment:alignment textColor:textColor font:font lines:lines];
    label.text = text;
    return label;
}

@end
