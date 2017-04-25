//
//  DLContactListController.m
//  Dolores
//
//  Created by Heath on 18/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLContactListController.h"
#import "DLAddContactController.h"
#import "DLContactCell.h"
#import "DLContactSectionHeader.h"
#import "DLChatController.h"

@interface DLContactListController () <DLBaseControllerProtocol, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contactList;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchContactList];
}

#pragma mark - DLBaseControllerProtocol

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setupData {

}

- (void)setupNavigationBar {
    self.navigationItem.title = @"通讯录";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                                                                   action:@selector(onClickToAdd)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLContactCell *contactCell = [tableView dequeueReusableCellWithIdentifier:[DLContactCell identifier]];
    NSArray *userSection = self.dataArray[indexPath.section];
    EaseUserModel *userModel = userSection[indexPath.row];
    [contactCell updateUserInfo:userModel];
    return contactCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionTitles;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSArray *userSection = self.dataArray[indexPath.section];
    EaseUserModel *userModel = userSection[indexPath.row];
    DLChatController *chatController = [[DLChatController alloc] initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
    [self.navigationController pushViewController:chatController animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DLContactSectionHeader *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[DLContactSectionHeader identifier]];
    sectionHeader.titleLabel.text = self.sectionTitles[section];
    return sectionHeader;
}

#pragma mark - fetch data

- (void)fetchContactList {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error;
        NSArray *list = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
        if (error) {
            [self showInfo:error.errorDescription];
        } else {
            [self.contactList removeAllObjects];
            [self.contactList addObjectsFromArray:list];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sortContactList];
            });
        }
    });
}

- (void)sortContactList {
    [self.dataArray removeAllObjects];
    [self.sectionTitles removeAllObjects];

    NSMutableArray *contactsSource = [NSMutableArray array];

    //从获取的数据中剔除黑名单中的好友
    NSArray *blockList = [[EMClient sharedClient].contactManager getBlackList];
    for (NSString *buddy in self.contactList) {
        if (![blockList containsObject:buddy]) {
            [contactsSource addObject:buddy];
        }
    }

    //建立索引的核心, 返回27，是a－z和＃
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];

    NSUInteger highSection = [self.sectionTitles count];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }

    //按首字母分组
    for (NSString *buddy in contactsSource) {
        EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:buddy];
        if (model) {
            model.avatarImage = [UIImage imageNamed:@"contact_icon_avatar_placeholder_round"];
            // TODO: nickname
            model.nickname = model.buddy;

            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:model.buddy];
            NSInteger section;
            if (firstLetter.length > 0) {
                section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
            } else {
                section = [sortedArray count] - 1;
            }

            NSMutableArray *array = sortedArray[section];
            [array addObject:model];
        }
    }

    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [sortedArray[i] sortedArrayUsingComparator:^NSComparisonResult(EaseUserModel *obj1, EaseUserModel *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.buddy];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];

            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.buddy];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];

            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];


        sortedArray[i] = [NSMutableArray arrayWithArray:array];
    }

    //去掉空的section
    for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
        NSArray *array = sortedArray[i];
        if ([array count] == 0) {
            [sortedArray removeObjectAtIndex:i];
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }

    [self.dataArray addObjectsFromArray:sortedArray];
    [self.tableView reloadData];
}

#pragma mark - touch action

- (void)onClickToAdd {
    DLAddContactController *addContactController = [DLAddContactController new];
    [self.navigationController pushViewController:addContactController animated:YES];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];

        [DLContactCell registerIn:_tableView];
        [DLContactSectionHeader registerIn:_tableView];

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)contactList {
    if (!_contactList) {
        _contactList = [NSMutableArray array];
    }
    return _contactList;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)sectionTitles {
    if (!_sectionTitles) {
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}


@end
