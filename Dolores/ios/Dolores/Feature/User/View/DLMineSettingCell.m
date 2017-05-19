//
//  DLMineSettingCell.m
//  Dolores
//
//  Created by Heath on 19/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLMineSettingCell.h"
#import "UIColor+DLAdd.h"
#import "DLTableCellConfig.h"

@interface DLMineSettingCell ()

@property (nonatomic, strong) UILabel *lblTitle;

@end

@implementation DLMineSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    [self.contentView addSubview:self.lblTitle];
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kDefaultGap));
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-kDefaultGap));
    }];

    return self;
}

- (void)updateCell:(DLTableCellConfig *)cellConfig {
    self.lblTitle.text = cellConfig.name;
    self.accessoryType = cellConfig.showMore ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}

#pragma mark - Getter

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:[UIColor dl_ironColor] font:[UIFont dl_defaultFont]];
    }
    return _lblTitle;
}

@end
