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

+ (UIColor *)dl_backgroundColor {
    return [UIColor colorWithHexString:@"f8f8f8"];
}

+ (UIColor *)dl_leadColor {
    return [UIColor colorWithHexString:@"191919"];
}

+ (UIColor *)dl_primaryColor {
    return [UIColor colorWithHexString:@"009688"];
}

+ (UIColor *)dl_primaryColorDark {
    return [UIColor colorWithHexString:@"#004D40"];
}

+ (UIColor *)dl_separatorColor {
    return [UIColor colorWithRed:0.176 green:0.188 blue:0.200 alpha:0.20];
}

@end
