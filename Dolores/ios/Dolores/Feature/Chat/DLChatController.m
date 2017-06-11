//
//  DLChatController.m
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLChatController.h"
#import "DLMessageModel.h"
#import "DLChatDetailController.h"
#import "UIColor+DLAdd.h"

@interface DLChatController () <EaseMessageViewControllerDataSource, EaseMessageViewControllerDelegate>

@property (nonatomic, strong) RMStaff *chatUser;

@end

@implementation DLChatController

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter conversationType:(EMConversationType)conversationType {
    self = [super initWithConversationChatter:conversationChatter conversationType:conversationType];
    if (!self) return nil;

    self.hidesBottomBarWhenPushed = YES;
    _chatUser = [RMStaff objectForPrimaryKey:conversationChatter];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    self.tableView.backgroundColor = [UIColor dl_tableBGColor];
    [self setupNav];
}

- (void)setupNav {
    if (self.conversation.type == EMConversationTypeChat) {
        
        self.navigationItem.title = self.chatUser.realName;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chat_oto_setting_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickDetail)];
        self.navigationItem.rightBarButtonItem = item;
    } else if (self.conversation.type == EMConversationTypeGroupChat) {
        NSDictionary *ext = self.conversation.ext;
        if ([ext[@"subject"] length]) {
            self.title = ext[@"subject"];
        }

        if (ext && ext[kHaveUnreadAtMessage] != nil) {
            NSMutableDictionary *newExt = [ext mutableCopy];
            [newExt removeObjectForKey:kHaveUnreadAtMessage];
            self.conversation.ext = newExt;
        }
        self.navigationItem.title = self.title;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chat_mtm_setting_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickDetail)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if (messageModel.isSender) {
        RMUser *user = [DLDBQueryHelper currentUser];
        messageModel.nickname = user.staff.realName;
        if (user.staff.avatarURL.length > 0) {
            messageModel.avatarURLPath = [user.staff qiniuURLWithSize:CGSizeMake(88, 88)];
        } else {
            messageModel.avatarImage = [UIImage imageNamed:@"contact_icon_avatar_placeholder_round"];
        }
    } else {
        messageModel.nickname = self.chatUser.realName;
        if (self.chatUser.avatarURL.length > 0) {
            messageModel.avatarURLPath = [self.chatUser qiniuURLWithSize:CGSizeMake(88, 88)];
        } else {
            messageModel.avatarImage = [UIImage imageNamed:@"contact_icon_avatar_placeholder_round"];
        }
    }
    
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

#pragma mark - touch action

- (void)onClickDetail {
    if (self.conversation.type == EMConversationTypeChat) {
        DLChatDetailController *chatDetailController = [[DLChatDetailController alloc] initWithUserId:self.conversation.conversationId];
        [self.navigationController pushViewController:chatDetailController animated:YES];
    }
}

@end
