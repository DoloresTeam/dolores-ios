//
//  DefineMacro.h
//  Dolores
//
//  Created by Heath on 18/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#ifndef DefineMacro_h
#define DefineMacro_h

#pragma mark - iOS version

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark - Size bounds

#define kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define kScreenHeight           [UIScreen mainScreen].bounds.size.height

#pragma mark - Message

#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2

#pragma mark - UI param

#define kDefaultGap     14.f

#pragma mark - notification

#define kLoginStatusNotification                @"kUserLoginNotification"
#define kUserLogoutNotification                 @"kUserLogoutNotification"
#define kLeaveChatControllerNotification        @"kLeaveChatController"

#pragma mark - api key

#define kQiuniuURLPrefix                        @"http://oq1inckvi.bkt.clouddn.com"


#endif /* DefineMacro_h */
