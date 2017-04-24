//
//  DLRootTabController.m
//  Dolores
//
//  Created by Heath on 18/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <EaseUILite/EaseRefreshTableViewController.h>
#import "DLRootTabController.h"
#import "EaseConversationListViewController.h"
#import "DLConversationListController.h"
#import "EaseUsersListViewController.h"
#import "DLContactListController.h"
#import "DLMineController.h"
#import "DLLoginController.h"

@interface DLRootTabController ()

@end

@implementation DLRootTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupObserver];
    [self setupControllers];

}

- (void)setupControllers {
    DLConversationListController *conversationListController = [[DLConversationListController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navConversation = [[UINavigationController alloc] initWithRootViewController:conversationListController];
    UITabBarItem *barItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:1];
    navConversation.tabBarItem = barItem;

    DLContactListController *contactListController = [[DLContactListController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navContact = [[UINavigationController alloc] initWithRootViewController:contactListController];
    UITabBarItem *barItem1 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:2];
    navContact.tabBarItem = barItem1;

    DLMineController *mineController = [[DLMineController alloc] init];
    UINavigationController *navMine = [[UINavigationController alloc] initWithRootViewController:mineController];
    UITabBarItem *barItem2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:3];
    navMine.tabBarItem = barItem2;

    self.viewControllers = @[navConversation, navContact, navMine];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self checkLoginStatus];
}

#pragma mark - observer

- (void)setupObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutNotification) name:kUserLogoutNotification
                                               object:nil];
}

- (void)userLogoutNotification {
    // TODO: 清楚上个用户的数据
    self.selectedIndex = 0;
    [NSUserDefaults setLoginStatus:NO];
    [self checkLoginStatus];
}

#pragma mark - private method

- (void)checkLoginStatus {
    if (![NSUserDefaults getLoginStatus]) {
        DLLoginController *loginController = [DLLoginController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
        [self presentViewController:nav animated:NO completion:NULL];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
