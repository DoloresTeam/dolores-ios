//
//  DLUserDetailController.h
//  Dolores
//
//  Created by Heath on 11/06/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLBaseViewController.h"

@interface DLUserDetailController : DLBaseViewController

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) RMStaff *user;

- (instancetype)initWithUid:(NSString *)uid;

- (instancetype)initWithUser:(RMStaff *)user;


@end
