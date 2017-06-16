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
#import "DLOrganizationController.h"

@interface DLRootTabController () <UITabBarControllerDelegate>

@end

@implementation DLRootTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupObserver];
    [self setupControllers];
    self.delegate = self;
}

- (void)setupControllers {
    DLConversationListController *conversationListController = [[DLConversationListController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navConversation = [[UINavigationController alloc] initWithRootViewController:conversationListController];
    UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"tab_conversation"] selectedImage:[UIImage
            imageNamed:@"tab_conversation_click"]];
    navConversation.tabBarItem = barItem;

    DLOrganizationController *orgController = [DLOrganizationController new];
//    DLContactListController *contactListController = [[DLContactListController alloc] init];
    UINavigationController *navContact = [[UINavigationController alloc] initWithRootViewController:orgController];
    UITabBarItem *barItem1 = [[UITabBarItem alloc] initWithTitle:@"联系人" image:[UIImage imageNamed:@"tab_contact"] selectedImage:[UIImage
            imageNamed:@"tab_contact_click"]];
    navContact.tabBarItem = barItem1;

    DLMineController *mineController = [[DLMineController alloc] init];
    UINavigationController *navMine = [[UINavigationController alloc] initWithRootViewController:mineController];
    UITabBarItem *barItem2 = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"tab_more"]
                                                   selectedImage:[UIImage imageNamed:@"tab_more_click"]];
    navMine.tabBarItem = barItem2;

    self.viewControllers = @[navConversation, navContact, navMine];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

}


#pragma mark - observer

- (void)setupObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveChatController) name:kLeaveChatControllerNotification object:nil];
}

- (void)leaveChatController {

}

#pragma mark - private method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
