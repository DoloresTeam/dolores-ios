//
// DLRootContactController
// Artsy
//
//  Created by heath on 23/06/2017.
//  Copyright (c) 2014 http://artsy.net. All rights reserved.
//
#import <YYCategories/UIColor+YYAdd.h>
#import "DLRootContactController.h"
#import "DLRootContactCell.h"
#import "DLChildOrganizationController.h"
#import "DLMyGroupController.h"
#import "DLSearchResultController.h"

@interface DLRootContactController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, copy) NSArray<RMStaff *> *frequentStaffs;
@property (nonatomic, assign) BOOL isExpanded;

@end

@implementation DLRootContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.frequentStaffs = [DLDBQueryHelper frequentStaffs];
//    [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"联系人";
}

- (void)setupView {
    self.definesPresentationContext = YES;
    self.searchController = [DLSearchResultController searchControlerWithNavigationController:self.navigationController];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 1;
    if (section == 2 && self.isExpanded) {
        row = self.frequentStaffs.count + 1;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLRootContactCell *rootContactCell = [tableView dequeueReusableCellWithIdentifier:[DLRootContactCell identifier]];
    if (indexPath.section == 0) {
        [rootContactCell updateImage:[UIImage imageNamed:@"contact_icon_enterprise"] title:@"企业通讯录"];
    } else if (indexPath.section == 1) {
        [rootContactCell updateImage:[UIImage imageNamed:@"contact_icon_group"] title:@"我的群组"];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [rootContactCell updateImage:[UIImage imageNamed:@"contact_usualcontact_icon_normal"] title:@"常用联系人"];
        } else {
            RMStaff *staff = self.frequentStaffs[indexPath.row - 1];
            [rootContactCell.imgPlace sd_setImageWithURL:[NSURL URLWithString:[staff qiniuURLWithSize:CGSizeMake(40, 40)]] placeholderImage:[UIImage imageNamed:@"contact_icon_avatar_placeholder_round"]];
            rootContactCell.lblTitle.text = staff.realName;

        }
    }
    return rootContactCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[UITableViewHeaderFooterView
            identifier]];
    headerFooterView.contentView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    return headerFooterView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // TODO: 企业通讯录
        DLChildOrganizationController *childOrganizationController = [[DLChildOrganizationController alloc] initWithDepartmentId:nil];
        [self.navigationController pushViewController:childOrganizationController animated:YES];
    } else if (indexPath.section == 1) {
        DLMyGroupController *myGroupController = [DLMyGroupController new];
        myGroupController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myGroupController animated:YES];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            self.isExpanded = !self.isExpanded;
            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            // TODO: go to chat.
        }
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];

        [DLRootContactCell registerIn:_tableView];
        [UITableViewHeaderFooterView registerIn:_tableView];

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
