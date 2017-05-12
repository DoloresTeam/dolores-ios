//
//  DLOrgUserCell.h
//  Dolores
//
//  Created by Heath on 12/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RMStaff;

@interface DLOrgUserCell : UITableViewCell

- (void)updateStaff:(RMStaff *)staff level:(NSInteger)level;

@end
