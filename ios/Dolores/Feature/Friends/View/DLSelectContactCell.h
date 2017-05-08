//
//  DLSelectContactCell.h
//  Dolores
//
//  Created by Heath on 27/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLUser.h"

@interface DLSelectContactCell : UITableViewCell

@property (nonatomic, weak) id <DLContactCellDelegate> delegate;

- (void)updateMember:(id <DLUserModel>)user;
@end
