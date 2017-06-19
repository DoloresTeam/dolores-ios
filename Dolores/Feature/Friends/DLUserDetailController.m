//
//  DLUserDetailController.m
//  Dolores
//
//  Created by Heath on 11/06/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLUserDetailController.h"
#import "DLMineHeaderView.h"
#import "DLChatController.h"

@interface DLUserDetailActionCell : UITableViewCell

@property (nonatomic, strong) UIButton *btnAction;

@end

@interface DLUserDetailController () <MineHeaderDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) DLMineHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DLUserDetailController

- (instancetype)initWithUid:(NSString *)uid {
    self = [super init];
    if (self) {
        _uid = [uid copy];
        _user = [RMStaff objectForPrimaryKey:uid];
    }
    return self;
}

- (instancetype)initWithUser:(RMStaff *)user {
    self = [super init];
    if (self) {
        _user = user;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.user.realName;
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.headerView updateUserInfo:self.user];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLUserDetailActionCell *cell = [tableView dequeueReusableCellWithIdentifier:[DLUserDetailActionCell identifier] forIndexPath:indexPath];
    NSInteger section = indexPath.section;
    cell.btnAction.tag = section;
    [cell.btnAction setTitle:section == 0 ? @"聊天" : @"打电话" forState:UIControlStateNormal];
    [cell.btnAction addTarget:self action:@selector(onclickMenu:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - touch action

- (void)onclickMenu:(UIButton *)sender {
    NSInteger tag = sender.tag;
    switch (tag) {
        case 0:
        {
            DLChatController *chatController = [[DLChatController alloc] initWithConversationChatter:self.user.uid conversationType:EMConversationTypeChat];
            chatController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatController animated:YES];
        }
            break;
        case 1:
        {

        }
            break;
        default:
            break;
    }
}


#pragma mark - MineHeaderDelegate

- (void)didTapUserAvatar {

}


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _tableView.delegate = self;
        _tableView.dataSource = self;

        [DLUserDetailActionCell registerIn:_tableView];
    }
    return _tableView;
}


- (DLMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DLMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        _headerView.delegate = self;
    }
    return _headerView;
}


@end

@implementation DLUserDetailActionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *button = [UIButton buttonWithFont:[UIFont baseBoldFont:16] title:@"确定" textColor:[UIColor whiteColor]
                             backgroundColor:[UIColor blueColor]];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 8;
        self.btnAction = button;

        [self.contentView addSubview:self.btnAction];
        [self.btnAction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.right.equalTo(@(-20));
            make.height.mas_equalTo(44);
            make.centerY.equalTo(@0);
        }];
    }
    return self;
}


@end
