//
//  DLNetworkService+DLAPI.m
//  Dolores
//
//  Created by Heath on 16/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLNetworkService+DLAPI.h"

@implementation DLNetworkService (DLAPI)

+ (RACSignal *)login:(NSString *)mobile password:(NSString *)password {
    return [SharedNetwork rac_POST:@"/login" parameters:@{@"username": mobile, @"password": password}];
}

+ (RACSignal *)myProfile {
    return [SharedNetwork rac_GET:@"/api/v1/profile" parameters:NULL];
}

+ (RACSignal *)refreshToken {
    return [[SharedNetwork rac_GET:@"/api/v1/refresh_token" parameters:@{}] doNext:^(NSDictionary *resp) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm transactionWithBlock:^{
                RMUser *user = [DLDBQueryHelper currentUser];
                if (user) {
                    user.token = resp[@"token"];
                    user.expireDate = resp[@"expire"];
                    [realm addOrUpdateObject:user];
                }
            }];
        });
    }];
}

+ (RACSignal *)getQiniuToken {
    return [[SharedNetwork rac_GET:@"/api/v1/upload_token" parameters:nil] doNext:^(NSDictionary *resp) {
        [NSUserDefaults saveQiniuToken:resp[@"token"]];
        [NSUserDefaults saveLastFetchQiniuToken:[[NSDate date] timeIntervalSince1970]];
    }];
}

+ (RACSignal *)updateUserAvater:(NSString *)urlString {
    return [SharedNetwork rac_GET:@"/api/v1/update_avatar" parameters:@{@"avatar": urlString}];
}

+ (RACSignal *)myOrganization {
    return [SharedNetwork rac_GET:@"/api/v1/organization" parameters:nil];
}


@end
