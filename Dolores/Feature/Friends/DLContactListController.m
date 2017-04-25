//
//  DLContactListController.m
//  Dolores
//
//  Created by Heath on 18/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLContactListController.h"
#import "DLAddContactController.h"

@interface DLContactListController () <DLBaseControllerProtocol>

@end

@implementation DLContactListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
    [self setupData];
    [self setupView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    self.view.frame = [UIScreen mainScreen].bounds;
}

#pragma mark - DLBaseControllerProtocol

- (void)setupView {

}

- (void)setupData {

}

- (void)setupNavigationBar {
    self.navigationItem.title = @"通讯录";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                                                                   action:@selector(onClickToAdd)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

#pragma mark - touch action

- (void)onClickToAdd {
    DLAddContactController *addContactController = [DLAddContactController new];
    [self.navigationController pushViewController:addContactController animated:YES];
}


@end
