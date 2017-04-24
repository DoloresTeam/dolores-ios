//
//  UIFont+Addition.m
//  Dolores
//
//  Created by Heath on 18/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "UIFont+Addition.h"

/*
 // PingFang SC // PingFangSC-Ultralight
 // PingFang SC // PingFangSC-Regular
 // PingFang SC // PingFangSC-Semibold
 // PingFang SC // PingFangSC-Thin
 // PingFang SC // PingFangSC-Light
 // PingFang SC // PingFangSC-Medium
 */

@implementation UIFont (Addition)

+ (UIFont *)dl_smallFont {
    return [self baseFont:12];
}

+ (UIFont *)dl_defaultFont {
    return [self baseFont:14];
}

+ (UIFont *)dl_largeFont {
    return [self baseFont:16];
}

#pragma mark - base

+ (UIFont *)baseFont:(CGFloat)fontSize {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
        return font;
    }
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)baseBoldFont:(CGFloat)fontSize {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")) {
        return [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize];
    }
    return [UIFont boldSystemFontOfSize:fontSize];
}

+ (UIFont *)baseMediumFont:(CGFloat)fontSize {
    if (SYSTEM_VERSION_GREATER_THAN(@"9")) {
        return [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize];
    }
    return [UIFont systemFontOfSize:fontSize];
}

@end
