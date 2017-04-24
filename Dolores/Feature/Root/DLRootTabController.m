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

@interface DLRootTabController ()

@end

@implementation DLRootTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
