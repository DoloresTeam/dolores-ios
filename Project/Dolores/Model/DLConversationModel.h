//
//  DLConversationModel.h
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLConversationModel : NSObject <IConversationModel>

/** @brief 会话对象 */
@property (strong, nonatomic, readonly) EMConversation *conversation;
/** @brief 会话的标题(主要用户UI显示) */
@property (strong, nonatomic) NSString *title;
/** @brief conversationId的头像url */
@property (strong, nonatomic) NSString *avatarURLPath;
/** @brief conversationId的头像 */
@property (strong, nonatomic) UIImage *avatarImage;

- (instancetype)initWithConversation:(EMConversation *)conversation;

@end
