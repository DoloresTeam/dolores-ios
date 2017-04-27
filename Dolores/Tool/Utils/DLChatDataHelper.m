//
//  DLChatDataHelper.m
//  Dolores
//
//  Created by Heath on 27/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLChatDataHelper.h"
#import "DLUser.h"

@implementation DLChatDataHelper

+ (NSArray *)sortContactList:(NSArray *)contacts {
    return [DLChatDataHelper sortContactList:contacts selectContect:@[]];
}

+ (NSArray *)sortContactList:(NSArray *)contacts selectContect:(NSArray *)selectList {
    NSMutableArray *sectionTitles = [NSMutableArray array];
    NSMutableArray *dataSource = [NSMutableArray array];

    NSMutableArray *contactsSource = [NSMutableArray array];
    //从获取的数据中剔除黑名单中的好友
    NSArray *blockList = [[EMClient sharedClient].contactManager getBlackList];
    for (NSString *buddy in contacts) {
        if (![blockList containsObject:buddy]) {
            [contactsSource addObject:buddy];
        }
    }

    //建立索引的核心, 返回27，是a－z和＃
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];

    NSUInteger highSection = [sectionTitles count];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }

    //按首字母分组
    for (NSString *buddy in contactsSource) {
        DLUser *model = [[DLUser alloc] initWithBuddy:buddy];
        if (model) {
            model.avatarImage = [UIImage imageNamed:@"contact_icon_avatar_placeholder_round"];
            model.hasJoined = [selectList containsObject:buddy];
            // TODO: nickname & image

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
        NSArray *array = [sortedArray[i] sortedArrayUsingComparator:^NSComparisonResult(DLUser *obj1, DLUser *obj2) {
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
            [sectionTitles removeObjectAtIndex:i];
        }
    }

    [dataSource addObjectsFromArray:sortedArray];
    return @[sectionTitles, dataSource];
}

@end
