//
//  DLAddMemberController.h
//  Dolores
//
//  Created by Heath on 26/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLBaseViewController.h"


@interface DLAddMemberController : DLBaseViewController

@property (nonatomic, copy) NSArray *currentMembers;
@property (nonatomic, weak) id <DLGroupChatDelegate> delegate;

- (instancetype)initWithCurrentMembers:(NSArray *)currentMembers;


@end
