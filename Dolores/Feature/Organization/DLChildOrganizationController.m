//
// DLChildOrganizationController
// Artsy
//
//  Created by heath on 23/06/2017.
//  Copyright (c) 2014 http://artsy.net. All rights reserved.
//
#import "DLChildOrganizationController.h"
#import "DLRootContactCell.h"
#import "DLUserDetailController.h"
#import "DLSearchResultController.h"
#import "EPEmptyDataProtocol.h"

@interface DLChildOrganizationController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) EPEmptyDataProtocol *emptyDataProtocol;

#pragma mark - data
@property (nonatomic, assign) BOOL isRoot;
@property (nonatomic, strong) RLMResults<RMDepartment *> *rootDepartments;
@property (nonatomic, strong) RMDepartment *department;

@end

@implementation DLChildOrganizationController

#pragma mark - init

- (instancetype)initWithDepartmentId:(NSString *)departmentId {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _departmentId = [departmentId copy];
        if ([NSString isEmpty:departmentId]) {
            _isRoot = YES;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    if (self.isRoot) {
        self.navigationItem.title = @"组织架构";
    } else {
        self.navigationItem.title = self.department.departmentName;
    }

    [self setupView];

    self.emptyDataProtocol.shouldDisplay = !self.isRoot && (self.department.staffs.count + self.department.childrenDepartments.count) <= 0;
}

- (void)setupData {
    self.rootDepartments = [DLDBQueryHelper rootDepartments];
    if (!self.isRoot) {
        self.department = [RMDepartment objectForPrimaryKey:self.departmentId];
    }
}

- (void)setupView {
    self.definesPresentationContext = YES;
    self.searchController = [DLSearchResultController searchControlerWithNavigationController:self.navigationController];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];

    self.emptyDataProtocol = [[EPEmptyDataProtocol alloc] initWithReferScrollView:self.tableView emptyText:@"待规划部门"];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isRoot) {
        return self.rootDepartments.count;
    }
    return self.department.staffs.count + self.department.childrenDepartments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLRootContactCell *rootContactCell = [tableView dequeueReusableCellWithIdentifier:[DLRootContactCell identifier]];
    if (self.isRoot) {
        RMDepartment *department = self.rootDepartments[(NSUInteger) indexPath.row];
        [rootContactCell updateImage:[UIImage imageNamed:@"cmail_list_folder"] title:department.departmentName];
    } else {

        if (self.department.staffs.count > 0) {
            if (indexPath.row < self.department.staffs.count) {
                RMStaff *staff = self.department.staffs[indexPath.row];

                DLContactUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:[DLContactUserCell identifier]];
                [userCell updateHead:staff.avatarURL title:staff.realName];

                return userCell;
            } else {
                RMDepartment *department1 = self.department.childrenDepartments[indexPath.row - self.department.staffs.count];
                [rootContactCell updateImage:[UIImage imageNamed:@"cmail_list_folder"] title:department1.departmentName];
            }

        } else {
            RMDepartment *department1 = self.department.childrenDepartments[indexPath.row];
            [rootContactCell updateImage:[UIImage imageNamed:@"cmail_list_folder"] title:department1.departmentName];
        }

    }
    return rootContactCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isRoot) {
        RMDepartment *department1 = self.rootDepartments[indexPath.row];
        [self reviewChildDepartment:department1.departmentId];
    } else {

        if (self.department.staffs.count > 0) {
            if (indexPath.row < self.department.staffs.count) {
                RMStaff *staff = self.department.staffs[indexPath.row];

                RMUser *user = [DLDBQueryHelper currentUser];
                if ([user.uid isEqualToString:staff.uid]) {
                    return;
                }

                DLUserDetailController *userDetailController = [[DLUserDetailController alloc] initWithUid:staff.uid];
                [self.navigationController pushViewController:userDetailController animated:YES];
            } else {
                RMDepartment *department1 = self.department.childrenDepartments[indexPath.row - self.department.staffs.count];
                [self reviewChildDepartment:department1.departmentId];
            }
        } else {
            RMDepartment *department1 = self.department.childrenDepartments[indexPath.row];
            [self reviewChildDepartment:department1.departmentId];
        }

    }
}

- (void)reviewChildDepartment:(NSString *)departmentId {
    DLChildOrganizationController *childOrganizationController = [[DLChildOrganizationController alloc] initWithDepartmentId:departmentId];
    [self.navigationController pushViewController:childOrganizationController animated:YES];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];

        [DLRootContactCell registerIn:_tableView];
        [DLContactUserCell registerIn:_tableView];

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
