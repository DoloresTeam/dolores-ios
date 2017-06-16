//
//  UIButton+Addition.h
//  CategoryCollection
//
//  Created by Heath on 27/03/2017.
//  Copyright © 2017 Heath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Addition)

/**
 * 根据字体，文字初始化button
 */
+ (instancetype)buttonWithFont:(UIFont *)font title:(NSString *)title;

/**
 * 根据字体大小，title，文字颜色初始化button
 */
+ (instancetype)buttonWithFont:(UIFont *)font
                         title:(NSString *)title
                     textColor:(UIColor *)color;

/**
 * 根据字体大小，title，文字颜色，背景颜色初始化button
 */
+ (instancetype)buttonWithFont:(UIFont *)font
                         title:(NSString *)title
                     textColor:(UIColor *)color
               backgroundColor:(UIColor *)bgColor;

/**
 * 根据字体大小，title，文字颜色，圆角大小初始化button
 */
+ (instancetype)buttonWithFont:(UIFont *)font
                         title:(NSString *)title
                     textColor:(UIColor *)color
                  cornerRadius:(CGFloat)radius;

/**
 * 根据默认状态和高亮状态图片初始化button
 */
+ (instancetype)buttonWithNormalImage:(UIImage *)normalImg
                     highlightedImage:(UIImage *)highlightedImg;

@end
