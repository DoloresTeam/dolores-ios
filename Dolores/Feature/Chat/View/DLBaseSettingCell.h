//
//  DLBaseSettingCell.h
//  Dolores
//
//  Created by Heath on 26/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLBaseSettingCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgViewArrow;

@end


@interface DLBaseSwitchCell : DLBaseSettingCell

@property (nonatomic, strong) UISwitch *uiSwitch;

@end
