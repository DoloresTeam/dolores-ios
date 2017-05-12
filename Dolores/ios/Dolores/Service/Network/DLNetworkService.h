//
//  DLNetworkService.h
//  Dolores
//
//  Created by Heath on 12/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SharedNetwork   [DLNetworkService sharedInstance]

@protocol AFMultipartFormData;

extern NSString *const kRACAFNResponseObjectErrorKey;

@interface DLNetworkService : NSObject

+ (instancetype)sharedInstance;

- (void)configBaseURL:(NSString *)baseURL;

- (void)setHeader:(NSString *)value headerField:(NSString *)headerField;

#pragma mark - http method

- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters;

- (RACSignal *)rac_HEAD:(NSString *)path parameters:(id)parameters;

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters;

- (RACSignal *)rac_PUT:(NSString *)path parameters:(id)parameters;

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id)parameters;

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id)parameters;

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;

@end
