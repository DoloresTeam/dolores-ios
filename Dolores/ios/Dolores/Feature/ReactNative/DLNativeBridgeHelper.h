//
//  DLNativeBridgeHelper.h
//  Dolores
//
//  Created by Heath on 09/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NativeBridgeHelperDelegate <NSObject>

@optional

- (NSDictionary *)userById:(NSString *)uid;

@end

@interface DLNativeBridgeHelper : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak) id <NativeBridgeHelperDelegate> delegate;


@end
