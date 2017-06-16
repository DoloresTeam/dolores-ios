//
//  BFNetworkActivityLogger.h
//  Organiger
//
//  Created by MaxWellPro on 16/5/17.
//  Copyright © 2016年 QuanYan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BFHTTPRequestLoggerLevel) {
    BFLoggerLevelOff,
    BFLoggerLevelDebug,     //输出response返回数据
    BFLoggerLevelInfo,      //不输出response返回数据
    BFLoggerLevelWarn,
    BFLoggerLevelError,
    BFLoggerLevelFatal = BFLoggerLevelOff,
};


@interface BFNetworkActivityLogger : NSObject

/**
 The level of logging detail. See "Logging Levels" for possible values. `AFLoggerLevelInfo` by default.
 */
@property (nonatomic, assign) BFHTTPRequestLoggerLevel level;

/**
 Omit requests which match the specified predicate, if provided. `nil` by default.
 
 @discussion Each notification has an associated `NSURLRequest`. To filter out request and response logging, such as all network activity made to a particular domain, this predicate can be set to match against the appropriate URL string pattern.
 */
@property (nonatomic, strong) NSPredicate *filterPredicate;

/**
 Returns the shared logger instance.
 */
+ (instancetype)sharedLogger;

/**
 Start logging requests and responses.
 */
- (void)startLogging;

/**
 Stop logging requests and responses.
 */
- (void)stopLogging;

@end
