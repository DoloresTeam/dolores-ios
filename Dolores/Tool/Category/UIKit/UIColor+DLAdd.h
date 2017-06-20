//
//  UIColor+DLAdd.h
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DLAdd)

/**
 * tableview分割线
 * @return
 */
+ (UIColor *)dl_ironColor;

+ (UIColor *)dl_textColorStyle1;

/**
 * tableview背景色，较淡，灰
 * @return
 */
+ (UIColor *)dl_backgroundColor;

/**
 * 接近最黑
 * @return
 */
+ (UIColor *)dl_leadColor;

+ (UIColor *)dl_separatorColor;

// 主题色
+ (UIColor *)dl_primaryColor;

+ (UIColor *)dl_primaryColorDark;

@end
