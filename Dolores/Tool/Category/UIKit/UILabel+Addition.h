//
//  UILabel+Addition.h
//  CategoryCollection
//
//  Created by Heath on 27/03/2017.
//  Copyright © 2017 Heath. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief  基本创建label方法集合
 */

@interface UILabel (Addition)

/**
 *  @brief  根据label对齐参数创建label
 *
 *  @param alignment alignment description
 *
 *  @return UILabel
 */
+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment;

/**
 *  @brief  根据label对齐，字体颜色参数创建label
 *
 *  @param alignment alignment description
 *  @param textColor textColor description
 *
 *  @return UILabel
 */
+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment
                      textColor:(UIColor *)textColor;

/**
 *  @brief  根据label对齐，字体颜色，字体参数创建label
 *
 *  @param alignment alignment description
 *  @param textColor textColor description
 *  @param font      font description
 *
 *  @return UILabel
 */
+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment
                      textColor:(UIColor *)textColor
                           font:(UIFont *)font;

/**
 *  @brief  根据label对齐，字体颜色，字体，文字参数创建label
 *
 *  @param alignment alignment description
 *  @param textColor textColor description
 *  @param font      font description
 *  @param text      text description
 *
 *  @return UILabel
 */
+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment
                      textColor:(UIColor *)textColor
                           font:(UIFont *)font
                           text:(NSString *)text;

/**
 *  @brief  根据label对齐，字体颜色，字体，行数创建label
 *
 *  @param alignment alignment description
 *  @param textColor textColor description
 *  @param font      font description
 *  @param lines     lines description
 *
 *  @return UILabel
 */
+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment
                      textColor:(UIColor *)textColor
                           font:(UIFont *)font
                          lines:(NSInteger)lines;

/**
 *  @brief  根据label对齐，字体颜色，字体，行数，文字创建label
 *
 *  @param alignment alignment description
 *  @param textColor textColor description
 *  @param font      font description
 *  @param lines     lines description
 *  @param text      text description
 *
 *  @return UILabel
 */
+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment
                      textColor:(UIColor *)textColor
                           font:(UIFont *)font
                          lines:(NSInteger)lines
                           text:(NSString *)text;

@end
