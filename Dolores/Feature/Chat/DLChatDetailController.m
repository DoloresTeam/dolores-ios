//
//  DLChatDetailController.m
//  Dolores
//
//  Created by Heath on 26/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLChatDetailController.h"
#import "DLBaseSettingCell.h"
#import "DLSettingConfig.h"

@interface DLChatDetailController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DLChatDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    self.navigationItem.title = @"聊天详情";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setupData {
    DLSettingConfig *addNewMemberConfig = [DLSettingConfig configWithTitle:@"添加新成员" content:nil showMore:NO showSwitch:NO];
    DLSettingConfig *topConfig = [DLSettingConfig configWithTitle:@"置顶聊天" content:nil showMore:NO showSwitch:YES];
    DLSettingConfig *noDisturb = [DLSettingConfig configWithTitle:@"消息免打扰" content:nil showMore:NO showSwitch:YES];
    DLSettingConfig *cleanConfig = [DLSettingConfig configWithTitle:@"清空聊天记录" content:nil showMore:NO showSwitch:NO];
    self.dataSource = [NSMutableArray arrayWithArray:@[@[addNewMemberConfig], @[topConfig, noDisturb], @[cleanConfig]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataSource[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLBaseSwitchCell *switchCell = [tableView dequeueReusableCellWithIdentifier:[DLBaseSwitchCell identifier] forIndexPath:indexPath];
    NSArray *array = self.dataSource[indexPath.section];
    DLSettingConfig *config = array[indexPath.row];
    switchCell.titleLabel.text = config.title;
    switchCell.uiSwitch.hidden = !config.showSwitch;
    switchCell.imgViewArrow.hidden = !config.showMore;
    return switchCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];

        [DLBaseSwitchCell registerIn:_tableView];

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
