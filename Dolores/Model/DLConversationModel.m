//
//  DLConversationModel.m
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLConversationModel.h"

@implementation DLConversationModel


- (instancetype)initWithConversation:(EMConversation *)conversation {
    self = [super init];
    if (self) {
        _conversation = conversation;
        _avatarImage = [UIImage imageNamed:@"contact_icon_avatar_placeholder_round"];
        _title = conversation.conversationId;
    }
    return self;
}


@end
