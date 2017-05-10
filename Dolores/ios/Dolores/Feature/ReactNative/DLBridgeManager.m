//
//  DLBridgeManager.m
//  Dolores
//
//  Created by Heath on 09/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLBridgeManager.h"
#import "DLNativeBridgeHelper.h"

@implementation DLBridgeManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"*** init DLBridgeManager.");
    }
    return self;
}

RCT_EXPORT_MODULE()

#pragma mark - Override

- (NSArray<NSString *> *)supportedEvents {
    return @[@"OCEventReminder"];
}

#pragma mark - RN call OC

RCT_EXPORT_METHOD(addTest:(NSString*)name) {
    NSLog(@"rn param:%@", name);
    [self executeEvent:name];
}

RCT_EXPORT_METHOD(getAllUser:(id)users) {
    NSLog(@"users: %@", users);
}

RCT_EXPORT_METHOD(realmFilePath:(NSString *)path) {
  NSLog(@"*** realm filePath:%@", path);
}

RCT_EXPORT_METHOD(getUserWithId:(NSString *)uid user:(NSDictionary *)user) {
    
}

#pragma mark - OC call RN

- (void)executeEvent:(NSString *)event {
    [self sendEventWithName:@"OCEventReminder" body:@{@"userId": @"heathwang.", @"event": event}];
}

@end
