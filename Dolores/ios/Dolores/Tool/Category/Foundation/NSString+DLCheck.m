//
//  NSString+DLCheck.m
//  Dolores
//
//  Created by Heath on 13/06/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "NSString+DLCheck.h"

@implementation NSString (DLCheck)

//判断输入是否为空
+ (BOOL)isEmpty:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

@end
