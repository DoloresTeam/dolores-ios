//
//  DLChatController.m
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLChatController.h"
#import "DLMessageModel.h"

@interface DLChatController () <EaseMessageViewControllerDataSource, EaseMessageViewControllerDelegate>

@end

@implementation DLChatController

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter conversationType:(EMConversationType)conversationType {
    self = [super initWithConversationChatter:conversationChatter conversationType:conversationType];
    if (!self) return nil;

    self.hidesBottomBarWhenPushed = YES;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
//    self.view.frame = [UIScreen mainScreen].bounds;
}

#pragma mark - EaseMessageViewControllerDataSource

- (id)messageViewController:(EaseMessageViewController *)viewController progressDelegateForMessageBodyType:(EMMessageBodyType)messageBodyType {
    return nil;
}

- (void)messageViewController:(EaseMessageViewController *)viewController updateProgress:(float)progress messageModel:(id <IMessageModel>)messageModel messageBody:(EMMessageBody *)messageBody {

}

//- (NSString *)messageViewController:(EaseMessageViewController *)viewController stringForDate:(NSDate *)date {
//    return nil;
//}

- (id <IMessageModel>)messageViewController:(EaseMessageViewController *)viewController modelForMessage:(EMMessage *)message {
    DLMessageModel *messageModel = [[DLMessageModel alloc] initWithMessage:message];
    // TODO: 用户信息更新
    messageModel.avatarImage = [UIImage imageNamed:@"contact_icon_avatar_placeholder_round"];
    messageModel.nickname = @"Heath";
    return messageModel;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController canLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController didLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)messageViewControllerShouldMarkMessagesAsRead:(EaseMessageViewController *)viewController {
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController shouldSendHasReadAckForMessage:(EMMessage *)message read:(BOOL)read {
    return NO;
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController messageModel:(id <IMessageModel>)messageModel {
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion *)emotionURLFormessageViewController:(EaseMessageViewController *)viewController messageModel:(id <IMessageModel>)messageModel {
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion;
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSArray *)emotionFormessageViewController:(EaseMessageViewController *)viewController {
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = emotions[0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    return @[managerDefault];
}

- (NSDictionary *)emotionExtFormessageViewController:(EaseMessageViewController *)viewController easeEmotion:(EaseEmotion *)easeEmotion {
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

- (void)messageViewControllerMarkAllMessagesAsRead:(EaseMessageViewController *)viewController {

}

#pragma mark - EaseMessageViewControllerDelegate

@end
