//
//  DLAddContactController.m
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLAddContactController.h"

@interface DLAddContactController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DLAddContactController

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
    self.navigationItem.title = @"添加好友";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    [searchBar sizeToFit];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
}


#pragma mark - Getter

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"输入好友名字";
        _searchBar.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44);
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = self.searchBar;


    }
    return _tableView;
}


@end
