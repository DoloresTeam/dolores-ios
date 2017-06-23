//
//  DLSearchResultController.m
//  Dolores
//
//  Created by Heath on 26/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLSearchResultController.h"
#import "AppDelegate.h"
#import "DLRootContactCell.h"
#import "DLUserDetailController.h"

@interface DLSearchResultController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RLMResults<RMStaff *> *results;

@end

@implementation DLSearchResultController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@64);
    }];
}

+ (UISearchController *)searchControlerWithNavigationController:(UINavigationController *)navigationController {
    DLSearchResultController *searchResultController = [DLSearchResultController new];
    searchResultController.tmpNavigationController = navigationController;
    UISearchController *tmpSearchController = [[UISearchController alloc] initWithSearchResultsController:searchResultController];

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [tmpSearchController.view insertSubview:effectView atIndex:0];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    tmpSearchController.searchBar.placeholder = @"搜索";
    tmpSearchController.searchBar.barStyle = UIBarStyleDefault;
    tmpSearchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;

    searchResultController.searchController = tmpSearchController;
    tmpSearchController.delegate = searchResultController;
    tmpSearchController.searchResultsUpdater = searchResultController;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.1")) {
        tmpSearchController.obscuresBackgroundDuringPresentation = YES;
    }
    return tmpSearchController;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLRootContactCell *rootContactCell = [tableView dequeueReusableCellWithIdentifier:[DLRootContactCell identifier]];
    RMStaff *staff = self.results[indexPath.row];
    [rootContactCell updateHead:staff.avatarURL title:staff.nickName];
    return rootContactCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RMStaff *staff = self.results[indexPath.row];
    DLUserDetailController *userDetailController = [[DLUserDetailController alloc] initWithUid:staff.uid];
    [self.tmpNavigationController pushViewController:userDetailController animated:YES];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchController.searchBar endEditing:YES];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.results = [DLDBQueryHelper queryStaffWithKeyword:searchController.searchBar.text];
    [self.tableView reloadData];
}

#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController {
    self.tableView.hidden = NO;
}

- (void)didPresentSearchController:(UISearchController *)searchController {

}

- (void)willDismissSearchController:(UISearchController *)searchController {
    self.tableView.hidden = YES;
}

- (void)didDismissSearchController:(UISearchController *)searchController {

}

- (void)presentSearchController:(UISearchController *)searchController {

}


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];

        [DLRootContactCell registerIn:_tableView];

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
