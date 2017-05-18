//
//  DLOrganizationController.m
//  Dolores
//
//  Created by Heath on 12/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLOrganizationController.h"
#import "DLOrgUserCell.h"
#import "DLOrgDepartmentCell.h"
#import <RATreeView.h>
#import "RMDepartment.h"
#import "RMStaff.h"
#import "RMCompany.h"
#import "DLDBQueryHelper.h"

@interface DLOrganizationController () <RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic, strong) RATreeView *treeView;
@property (nonatomic, strong) RLMResults<RMDepartment *> *departments;

@end

@implementation DLOrganizationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupData];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    [self.view addSubview:self.treeView];
    [self setupViewConstraints];
    self.treeView.treeFooterView = [UIView new];
}

- (void)setupData {
    self.departments = [DLDBQueryHelper rootDepartments];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"组织架构";
}

- (void)setupViewConstraints {
    [self.treeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - RATreeViewDataSource

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(nullable id)item {
    if (!item) {
        return self.departments.count;
    }
    if ([item isKindOfClass:[RMDepartment class]]) {
        RMDepartment *department = item;
        return department.staffs.count + department.childrenDepartments.count;
    }
    return 0;
}

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(nullable id)item {
    NSInteger level = [treeView levelForCellForItem:item];
    if ([item isKindOfClass:[RMDepartment class]]) {
        DLOrgDepartmentCell *departmentCell = [treeView dequeueReusableCellWithIdentifier:[DLOrgDepartmentCell identifier]];
        [departmentCell updateDepartment:item level:level];
        return departmentCell;
    } else if ([item isKindOfClass:[RMStaff class]]) {
        DLOrgUserCell *userCell = [treeView dequeueReusableCellWithIdentifier:[DLOrgUserCell identifier]];
        [userCell updateStaff:item level:level];
        return userCell;
    }
    return nil;
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(nullable id)item {
    if (!item) {
        return [self.departments objectAtIndex:index];
    }
    if ([item isKindOfClass:[RMDepartment class]]) {
        RMDepartment *department = item;
        NSInteger staffCount = department.staffs.count;
        // 部门层级包含staff和子部门，先展示staff
        id dataSource;
        if (staffCount > 0) {
            if (index < staffCount) {
                dataSource = [department.staffs objectAtIndex:index];
            } else {
                dataSource = [department.childrenDepartments objectAtIndex:index - staffCount];
            }
        } else {
            dataSource = [department.childrenDepartments objectAtIndex:index];
        }
        return dataSource;
    } else {
        return nil;
    }
}

#pragma mark - RATreeViewDelegate

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
    return 48;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
//    [treeView deselectRowForItem:item animated:YES];
//}

- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    UITableViewCell *cell = [treeView cellForItem:item];
    if ([cell isKindOfClass:[DLOrgDepartmentCell class]]) {
        DLOrgDepartmentCell *orgDepartmentCell = (DLOrgDepartmentCell *) cell;
        [orgDepartmentCell animateExpandRow:YES];
    }
}

- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    UITableViewCell *cell = [treeView cellForItem:item];
    if ([cell isKindOfClass:[DLOrgDepartmentCell class]]) {
        DLOrgDepartmentCell *orgDepartmentCell = (DLOrgDepartmentCell *) cell;
        [orgDepartmentCell animateExpandRow:NO];
    }
}


#pragma mark - Getter

- (RATreeView *)treeView {
    if (!_treeView) {
        _treeView = [[RATreeView alloc] initWithFrame:CGRectZero style:RATreeViewStylePlain];
        _treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;

        [_treeView registerClass:[DLOrgUserCell class] forCellReuseIdentifier:[DLOrgUserCell identifier]];
        [_treeView registerClass:[DLOrgDepartmentCell class] forCellReuseIdentifier:[DLOrgDepartmentCell identifier]];

        _treeView.dataSource = self;
        _treeView.delegate = self;
    }
    return _treeView;
}


@end
