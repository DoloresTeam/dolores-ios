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
#import "RMStaff.h"
#import "RMDepartment.h"
#import <Realm.h>
#import "BFNetworkActivityLogger.h"
#import "DLContactManager.h"

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
//    [UINavigationBar appearance].tintColor = [UIColor blackColor];
    [UINavigationBar appearance].translucent = NO;
    [UITabBar appearance].translucent = NO;

    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    [barButtonItem setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64) forBarMetrics:UIBarMetricsDefault];

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

    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    uint64_t version = 0;
    configuration.schemaVersion = version;
    configuration.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < version) {

        }
    };
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = paths[0];
    configuration.fileURL = [[NSURL URLWithString:[cacheDirectory stringByAppendingPathComponent:@"dolores"]] URLByAppendingPathExtension:@"realm"];
    [RLMRealmConfiguration setDefaultConfiguration:configuration];
    [RLMRealm defaultRealm];

    NSLog(@"realm file path:%@", [RLMRealm defaultRealm].configuration.fileURL);

    [SharedContactManager fetchOrganization];

}

#pragma mark - observer

- (void)configObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged:) name:kLoginStatusNotification object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusNotification object:@([EMClient sharedClient].isAutoLogin)];
}

- (void)loginStatusChanged:(NSNotification *)notification {
    BOOL loginStatus = [notification.object boolValue];
    if (loginStatus) {
        DLRootTabController *rootTabController = [DLRootTabController new];
        self.window.rootViewController = rootTabController;
        [self.window makeKeyAndVisible];
    } else {
        DLLoginController *loginController = [DLLoginController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
}

@end
