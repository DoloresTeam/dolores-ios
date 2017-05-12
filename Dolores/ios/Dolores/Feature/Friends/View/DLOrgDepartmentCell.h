//
//  DLOrgDepartmentCell.h
//  Dolores
//
//  Created by Heath on 12/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RMDepartment;

@interface DLOrgDepartmentCell : UITableViewCell

- (void)updateDepartment:(RMDepartment *)department level:(NSInteger)level;

- (void)animateExpandRow:(BOOL)expand;
@end
