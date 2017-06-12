//
//  AppDelegate+DEMChatMgrDelegate.m
//  Dolores
//
//  Created by GongXiang on 6/12/17.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "AppDelegate+EMChatMgrDelegate.h"
#import "DLContactManager.h"

@implementation AppDelegate (EMChatMgrDelegate)

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    for (EMMessage *message in aCmdMessages) {
        EMCmdMessageBody *body = (EMCmdMessageBody *)message.body;
        if ([body.action isEqual: @"sync_organization"]) {
            NSLog(@"----Please Sync Organization---");
            [[DLContactManager sharedInstance] syncOrganization];
        }
    }
}

@end
