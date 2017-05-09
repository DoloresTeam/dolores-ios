//
//  UIBarButtonItem+DLAdd.h
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DLAdd)

+ (UIBarButtonItem *)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;
@end
