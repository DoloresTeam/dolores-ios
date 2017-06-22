//
//  DLNetworkService.m
//  Dolores
//
//  Created by Heath on 12/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLNetworkService.h"
#import "AFURLRequestSerialization.h"
#import "AFHTTPSessionManager.h"
#import <AFNetworking/AFNetworking.h>

NSString *const kRACAFNResponseObjectErrorKey = @"responseObject";
static NSTimeInterval const kHttpRequestTimeoutInterval = 10;
//static NSString *const kBaseURL = @"http://www.dolores.store:3280";

@interface DLNetworkService ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation DLNetworkService

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static DLNetworkService *_sharedNetworkService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedNetworkService = [[DLNetworkService alloc] init];
    });
    
    return _sharedNetworkService;
}

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configBaseURL:kBaseDoloresUrl];
    }
    return self;
}

- (void)configBaseURL:(NSString *)baseURL {
    _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    
    // config request
    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    _sessionManager.requestSerializer.timeoutInterval = kHttpRequestTimeoutInterval;

    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", nil];
}

- (void)setHeader:(NSString *)value headerField:(NSString *)headerField {
    [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:headerField];
}

#pragma mark - request

- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters {
    return [self rac_requestPath:path parameters:parameters method:@"GET"];
}

- (RACSignal *)rac_HEAD:(NSString *)path parameters:(id)parameters {
    return [self rac_requestPath:path parameters:parameters method:@"HEAD"];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters {
    return [self rac_requestPath:path parameters:parameters method:@"POST"];
}

- (RACSignal *)rac_PUT:(NSString *)path parameters:(id)parameters {
    return [self rac_requestPath:path parameters:parameters method:@"PUT"];
}

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id)parameters {
    return [self rac_requestPath:path parameters:parameters method:@"PATCH"];
}

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id)parameters {
    return [self rac_requestPath:path parameters:parameters method:@"DELETE"];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block {
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        NSMutableURLRequest *request = [self.sessionManager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:path relativeToURL:self.sessionManager.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];

        NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [self handleFailure:error responseObject:responseObject subscriber:subscriber];
            } else {
                [self handleSuccessResponse:responseObject subscriber:subscriber];
            }
        }];
        [task resume];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)rac_requestPath:(NSString *)path parameters:(id)parameters method:(NSString *)method {
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        NSURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:self.sessionManager.baseURL] absoluteString] parameters:parameters error:nil];

        NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {

            if (error) {
                [self handleFailure:error responseObject:responseObject subscriber:subscriber];
            } else {
                [self handleSuccessResponse:responseObject subscriber:subscriber];
            }
        }];
        [task resume];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

#pragma mark - response handle

- (void)handleFailure:(NSError *)error responseObject:(id)responseObject subscriber:(id <RACSubscriber>)subscriber {
    NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
    NSError *errorRes;
    if (responseObject) {
        userInfo[kRACAFNResponseObjectErrorKey] = responseObject;
        NSInteger code = [responseObject[@"code"] integerValue];
        
        if (code == 401) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusNotification object:nil];
        }
        
        NSString *message = responseObject[@"errMsg"];
        userInfo[@"errMsg"] = message;
        errorRes = [NSError errorWithDomain:error.domain code:code userInfo:userInfo];
    } else {
        
        if (error.code == 401) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusNotification object:nil];
        }
        
        userInfo[@"errMsg"] = userInfo[NSLocalizedDescriptionKey] ? : userInfo[@"NSDebugDescription"];
        errorRes = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
    }
    
    [subscriber sendError:errorRes];
}

- (void)handleSuccessResponse:(id)responseObj subscriber:(id <RACSubscriber>)subscriber {
    [subscriber sendNext:responseObj];
    [subscriber sendCompleted];
}

@end

@implementation NSError (DLAdd)

- (NSString *)message {
    return self.userInfo[@"errMsg"];
}

@end
