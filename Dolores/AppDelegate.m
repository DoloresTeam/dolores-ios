//
//  AppDelegate.m
//  Dolores
//
//  Created by Heath on 17/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "AppDelegate.h"
#import "DLRootTabController.h"
#import "DLLoginController.h"
#import "DLNetworkService.h"
#import "AFHTTPSessionManager.h"
#import "DLNetworkService+DLAPI.h"
#import "BFNetworkActivityLogger.h"
#import "AppDelegate+EMChatMgrDelegate.h"
#import "DLContactManager.h"
#import "UIColor+DLAdd.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self configRLMDatabase];

    [self setupGlobalUI];
    [self registerEMSDK];
    [self setupWindow];
    [self configObserver];
    [self setupRequestLog];
    [self setupEMChatManagerDelegate];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self fetchQiniuToken];
    [self refreshUserToken];

        // 更新组织架构
    if ([self didLogin]) {
        [[DLContactManager sharedInstance] syncOrganization];
        [[DLContactManager sharedInstance] refreshMysteriousStaffs];
    }

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - setup

- (void)setupWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    DLRootTabController *rootTabController = [[DLRootTabController alloc] init];
//    self.window.rootViewController = rootTabController;
    [self.window makeKeyAndVisible];
}

- (void)setupGlobalUI {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont baseBoldFont:16], NSForegroundColorAttributeName: [UIColor
            blackColor]}];

    [UINavigationBar appearance].tintColor = [UIColor dl_primaryColor];
    [UINavigationBar appearance].translucent = NO;

    [UITabBar appearance].tintColor = [UIColor dl_primaryColor];
    [UITabBar appearance].translucent = NO;

    [UITextField appearance].tintColor = [UIColor dl_primaryColor];

    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    [barButtonItem setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64) forBarMetrics:UIBarMetricsDefault];

    [[UITableView appearance] setBackgroundColor:[UIColor dl_backgroundColor]];

    [[UIButton appearance] setTintColor:[UIColor dl_primaryColor]];

}

- (void)registerEMSDK {
    EMOptions *options = [EMOptions optionsWithAppkey:@"1123170417178103#dolores"];
    options.enableConsoleLog = NO;
    options.isDeleteMessagesWhenExitGroup = NO;
    options.isDeleteMessagesWhenExitChatRoom = NO;
    options.enableDeliveryAck = YES;
    options.logLevel = EMLogLevelError;
    options.isAutoLogin = YES;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
}

- (void)setupEMChatManagerDelegate {
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

/**
 * 配置http网络请求log
 */
- (void)setupRequestLog {
#ifdef DEBUG
    BFNetworkActivityLogger *logger = [BFNetworkActivityLogger sharedLogger];
    [logger setLevel:BFLoggerLevelDebug];
    [logger startLogging];
#endif
}

- (void)configRLMDatabase {
    [DLDBQueryHelper configDefaultRealmDB:[NSUserDefaults getCurrentUser] ? : @"dolores"];
}

#pragma mark - fetch

- (void)fetchQiniuToken {
    if ([NSUserDefaults shouldFetchQiniuToken] && [DLDBQueryHelper isLogin]) {
        [[DLNetworkService getQiniuToken] subscribeNext:^(id x) {

        } error:^(NSError *error) {

        }];
    }
}

- (void)refreshUserToken {
    RMUser *user = [DLDBQueryHelper currentUser];
    if (user && ![user isInvalidated]) {
        if ([[user tokenExpireDate] timeIntervalSinceNow] < 600) {
            [[DLNetworkService refreshToken] subscribeNext:^(id x) {

            } error:^(NSError *error) {

            }];
        }
    }
}

- (BOOL)didLogin {
    RMUser *user = [DLDBQueryHelper currentUser];
    return user && ![user isInvalidated];
}

#pragma mark - observer

- (void)configObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged:) name:kLoginStatusNotification object:nil];

    RMUser *user = [DLDBQueryHelper currentUser];
    if (user && ![user isInvalidated]) {
        [SharedNetwork setHeader:[NSString stringWithFormat:@"Dolores %@", user.token] headerField:@"Authorization"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusNotification object:@(YES)];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusNotification object:@(NO)];
    }

}

- (void)loginStatusChanged:(NSNotification *)notification {
    BOOL didLogin = [notification.object boolValue];

    if (didLogin && ![self.window.rootViewController isKindOfClass:[DLRootTabController class]] ) {

        DLRootTabController *rootTabController = [DLRootTabController new];
        self.window.rootViewController = rootTabController;
        [self.window makeKeyAndVisible];
    } else if (!didLogin) {

        if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navc = (UINavigationController *)self.window.rootViewController;
            if ([navc.topViewController isKindOfClass:[DLLoginController class]]) {
                return;
            }
        }

        [SharedNetwork.sessionManager.requestSerializer clearAuthorizationHeader];

        DLLoginController *loginController = [DLLoginController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    } else {
        NSLog(@"Warning ignore login status change.");
    }
}

@end
