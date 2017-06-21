//
//  UITextField+Addition.h
//  CategoryCollection
//
//  Created by Heath on 27/03/2017.
//  Copyright © 2017 Heath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Addition)

/**
 * 根据font,color初始化text filed
 */
+ (instancetype)textFieldWithFont:(UIFont *)font textColor:(UIColor *)textColor;

+ (instancetype)textFieldWithFont:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment;

+ (instancetype)textFieldWithFont:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment placeholder:(NSString *)placeholder;

+ (instancetype)textFieldWithFont:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType;

@end

@interface UITextField (PaddingLabel)

-(void) setLeftPaddingText:(NSString *) paddingValue width:(CGFloat) width;

-(void) setRightPaddingText:(NSString *) paddingValue width:(CGFloat) width;

@end

