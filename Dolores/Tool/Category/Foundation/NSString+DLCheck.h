//
//  NSString+DLCheck.h
//  Dolores
//
//  Created by Heath on 13/06/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DLCheck)

+ (BOOL)isEmpty:(NSString *)string;

@end

@interface NSString (DLURL)

- (NSString *)qiniuURL;
- (NSString *)qiniuURLWithSize:(CGSize)size;

@end
