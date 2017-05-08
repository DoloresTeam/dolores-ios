//
//  UIFont+Addition.h
//  Dolores
//
//  Created by Heath on 18/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Addition)

+ (UIFont *)dl_smallFont;

+ (UIFont *)dl_defaultFont;

+ (UIFont *)dl_largeFont;

+ (UIFont *)baseFont:(CGFloat)fontSize;

+ (UIFont *)baseBoldFont:(CGFloat)fontSize;

+ (UIFont *)baseMediumFont:(CGFloat)fontSize;
@end
