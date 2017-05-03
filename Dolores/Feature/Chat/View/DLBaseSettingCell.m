//
//  DLBaseSettingCell.m
//  Dolores
//
//  Created by Heath on 26/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLBaseSettingCell.h"
#import "UIColor+DLAdd.h"

@implementation DLBaseSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.imgViewArrow];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@(kDefaultGap));
    }];

    [self.imgViewArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-16));
    }];

    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:[UIColor dl_textColorStyle1] font:[UIFont dl_defaultFont]];
    }
    return _titleLabel;
}

- (UIImageView *)imgViewArrow {
    if (!_imgViewArrow) {
        _imgViewArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_arrow"]];
    }
    return _imgViewArrow;
}


@end

@implementation DLBaseSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    [self.imgViewArrow setHidden:YES];
    [self.contentView addSubview:self.uiSwitch];
    [self.uiSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-16));
    }];

    return self;
}

#pragma mark - action

- (void)switchChanged:(UISwitch *)sender {

}

#pragma mark - Getter

- (UISwitch *)uiSwitch {
    if (!_uiSwitch) {
        _uiSwitch = [[UISwitch alloc] init];
        [_uiSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _uiSwitch;
}


@end
