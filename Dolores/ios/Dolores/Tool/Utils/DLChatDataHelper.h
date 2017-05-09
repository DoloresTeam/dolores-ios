//
//  DLChatDataHelper.h
//  Dolores
//
//  Created by Heath on 27/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLChatDataHelper : NSObject

/**
 * 根据联系人列表排序，生成可用的联系人数据
 * @param contacts
 * @return NSArray: secTitles & dataSource
 */
+ (NSArray *)sortContactList:(NSArray *)contacts;

+ (NSArray *)sortContactList:(NSArray *)contacts selectContect:(NSArray *)selectList;
@end
