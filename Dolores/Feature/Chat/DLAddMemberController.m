//
//  DLAddMemberController.m
//  Dolores
//
//  Created by Heath on 26/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLAddMemberController.h"
#import "DLContactSectionHeader.h"
#import "DLSelectContactCell.h"
#import "DLChatDataHelper.h"
#import "DLChatController.h"

@interface DLAddMemberController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *sectionTitles;

@end

@implementation DLAddMemberController

- (instancetype)initWithCurrentMembers:(NSArray *)currentMembers {
    self = [super init];
    if (!self) return nil;

    self.currentMembers = currentMembers;

    return self;
}


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

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setupData {
    NSArray *contacts = [[EMClient sharedClient].contactManager getContacts];
    NSArray *sortArray = [DLChatDataHelper sortContactList:contacts selectContect:self.currentMembers];
    self.sectionTitles = [NSMutableArray arrayWithArray:sortArray[0]];
    self.dataArray = [NSMutableArray arrayWithArray:sortArray[1]];
}

- (void)setupNavigationBar {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onClickToCancel)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    UIBarButtonItem *barButtonItemDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onClickToSubmit)];
    self.navigationItem.rightBarButtonItem = barButtonItemDone;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLSelectContactCell *selectContactCell = [tableView dequeueReusableCellWithIdentifier:[DLSelectContactCell identifier]];
    NSArray *array = self.dataArray[indexPath.section];
    [selectContactCell updateMember:array[indexPath.row]];
    return selectContactCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = self.dataArray[indexPath.section];
    id<DLUserModel> user = array[indexPath.row];
    user.selected = !user.selected;
    [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - action

- (void)onClickToCancel {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)onClickToSubmit {
    // TODO: create group.
    [self showLoadingView];
    NSMutableArray *members = [NSMutableArray array];
    for (NSArray *array in self.dataArray) {
        for (id <DLUserModel> user in array) {
            if (user.selected) {
                [members addObject:user.buddy];
            }
        }
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        EMError *error;
        EMGroupOptions *groupOptions = [[EMGroupOptions alloc] init];
        groupOptions.style = EMGroupStylePrivateMemberCanInvite;
        groupOptions.IsInviteNeedConfirm = NO;
        EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:[NSString stringWithFormat:@"群聊(%ld)", members.count + 2] description:@"群聊" invitees:members message:[NSString stringWithFormat:@"%@邀请你加入群聊", [EMClient sharedClient].currentUsername] setting:groupOptions error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showInfo:[error errorDescription]];
            });

        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoadingView];
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(createGroupSuccess:)]) {
                        [self.delegate createGroupSuccess:group.groupId];
                    }

                }];
            });

        }
    });
}


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];

        [DLContactSectionHeader registerIn:_tableView];
        [DLSelectContactCell registerIn:_tableView];

        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}


@end
