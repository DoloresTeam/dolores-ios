//
//  DLContactCell.h
//  Dolores
//
//  Created by Heath on 25/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLUserModel;

@interface DLContactCell : UITableViewCell

- (void)updateUserInfo:(id <DLUserModel>)user;
@end
