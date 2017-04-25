//
//  DLChatController.m
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLChatController.h"

@interface DLChatController ()

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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
//    self.view.frame = [UIScreen mainScreen].bounds;
}



@end
