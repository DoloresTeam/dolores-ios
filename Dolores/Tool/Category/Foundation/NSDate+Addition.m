//
//  NSDate+Addition.m
//  Dolores
//
//  Created by Kevin.Gong on 21/06/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (Addition)

// 同一天显示时间例如 15:55
- (NSString *)formattedDateWithDoloresFormat {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (self.isToday) {
        formatter.dateFormat = @"HH:mm";
        return [formatter stringFromDate:self];
    }
    
    if (self.isThisYear) {
        formatter.dateFormat = @"MM/dd HH:mm";
        return [formatter stringFromDate:self];
    }
    
    formatter.dateFormat = @"MM/dd/yyyy HH:mm";
    return [formatter stringFromDate:self];
    
}

@end
