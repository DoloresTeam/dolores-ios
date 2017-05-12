//
//  UIColor+DLAdd.m
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "UIColor+DLAdd.h"
#import "UIColor+YYAdd.h"

@implementation UIColor (DLAdd)

+ (UIColor *)dl_ironColor {
    return [UIColor colorWithHexString:@"4c4c4c"];
}

+ (UIColor *)dl_textColorStyle1 {
    return [UIColor colorWithHexString:@"333333"];
}

+ (UIColor *)dl_tableBGColor {
    return [UIColor colorWithHexString:@"f8f8f8"];
}

+ (UIColor *)dl_leadColor {
    return [UIColor colorWithHexString:@"191919"];
}

+ (UIColor *)dl_separatorColor {
    return [UIColor colorWithRed:0.176 green:0.188 blue:0.200 alpha:0.20];
}

@end
