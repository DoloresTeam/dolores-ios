//
//  DLSelectContactCell.m
//  Dolores
//
//  Created by Heath on 27/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLSelectContactCell.h"
#import "UIColor+DLAdd.h"
#import "DLUser.h"

@interface DLSelectContactCell ()

@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UIImageView *imgAvatar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) id<DLUserModel> user;

@end

@implementation DLSelectContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    [self.contentView addSubview:self.checkButton];
    [self.contentView addSubview:self.imgAvatar];
    [self.contentView addSubview:self.nameLabel];
    [self setupViewConstraints];

    return self;
}

- (void)setupViewConstraints {
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.equalTo(@(8));
        make.centerY.equalTo(@0);
    }];

    [self.imgAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(@0);
        make.left.equalTo(self.checkButton.mas_right).offset(6);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgAvatar.mas_right).offset(kDefaultGap);
        make.right.equalTo(@(-kDefaultGap));
        make.centerY.equalTo(@0);
    }];
}

- (void)updateMember:(id<DLUserModel>)user {
    [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:user.avatarURLPath] placeholderImage:[UIImage imageNamed:@"contact_icon_avatar_placeholder_round"]];
    self.nameLabel.text = user.nickname;
    if (user.hasJoined) {
        self.checkButton.enabled = NO;
        self.checkButton.selected = NO;
    } else {
        self.checkButton.enabled = YES;
        self.checkButton.selected = user.selected;
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - action

- (void)onClickCheckButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.user.selected = sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:didSelectButton:)]) {
        [self.delegate tableViewCell:self didSelectButton:sender];
    }
}

#pragma mark - Getter

- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setImage:[UIImage imageNamed:@"contact_picker_icon_checkbox_disabled"] forState:UIControlStateDisabled];
        [_checkButton setImage:[UIImage imageNamed:@"contact_picker_icon_checkbox"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"contact_picker_icon_checkbox_selected"] forState:UIControlStateSelected];

        [_checkButton addTarget:self action:@selector(onClickCheckButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}

- (UIImageView *)imgAvatar {
    if (!_imgAvatar) {
        _imgAvatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contact_icon_avatar_placeholder_round"]];
        _imgAvatar.clipsToBounds = YES;
    }
    return _imgAvatar;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:[UIColor dl_textColorStyle1] font:[UIFont dl_defaultFont]];
    }
    return _nameLabel;
}


@end
