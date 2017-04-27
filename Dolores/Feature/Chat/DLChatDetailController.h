//
//  DLChatDetailController.h
//  Dolores
//
//  Created by Heath on 26/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLBaseViewController.h"

@interface DLChatDetailController : DLBaseViewController

@property (nonatomic, copy) NSString *userId;

- (instancetype)initWithUserId:(NSString *)userId;


@end
