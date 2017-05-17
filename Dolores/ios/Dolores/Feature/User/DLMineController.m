//
//  DLMineController.m
//  Dolores
//
//  Created by Heath on 18/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLMineController.h"
#import "DLLogoutCell.h"
#import "NSNotificationCenter+YYAdd.h"

@interface DLMineController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DLMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
    [self setupView];
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"我";
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLLogoutCell *logoutCell = [tableView dequeueReusableCellWithIdentifier:[DLLogoutCell identifier]];
    return logoutCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {

        [self showLoadingView];
        [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
            if (!aError) {
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm transactionWithBlock:^{
                    RMUser *user = [DLDBQueryHelper currentUser];
                    user.logoutTimestamp = @([[NSDate date] timeIntervalSince1970]);
                    user.isLogin = @(NO);
                    [realm addOrUpdateObject:user];
                }];
                [self hideLoadingView];
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:kLoginStatusNotification object:@(NO) userInfo:nil];
            } else {
                [self showInfo:aError.errorDescription];
            }
        }];
    }
}


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.rowHeight = 50;

        [DLLogoutCell registerIn:_tableView];

    }
    return _tableView;
}


@end
