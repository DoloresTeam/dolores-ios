//
//  DLContactCell.m
//  Dolores
//
//  Created by Heath on 25/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <YYCategories/NSString+YYAdd.h>
#import "DLContactCell.h"
#import "UIColor+DLAdd.h"

@interface DLContactCell ()

@property (nonatomic, strong) UIImageView *imgAvatar;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) id<IUserModel> user;

@end

@implementation DLContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    [self.contentView addSubview:self.imgAvatar];
    [self.contentView addSubview:self.userLabel];

    [self.imgAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(@0);
        make.left.equalTo(@(kDefaultGap));
    }];

    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(self.imgAvatar.mas_right).offset(kDefaultGap);
        make.right.equalTo(@(-64));
    }];

    return self;
}

- (void)updateUserInfo:(id<IUserModel>)user {

    self.user = user;
    if (user.nickname.length > 0) {
        self.userLabel.text = user.nickname;
    } else {
        self.userLabel.text = user.buddy;
    }
    if ([user.avatarURLPath isNotBlank]) {
        [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:user.avatarURLPath] placeholderImage:[UIImage imageNamed:@"contact_icon_avatar_placeholder_round"]];
    } else if (user.avatarImage) {
        [self.imgAvatar setImage:user.avatarImage];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Getter

- (UIImageView *)imgAvatar {
    if (!_imgAvatar) {
        _imgAvatar = [[UIImageView alloc] init];
        [_imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
        _imgAvatar.userInteractionEnabled = YES;
    }
    return _imgAvatar;
}

- (UILabel *)userLabel {
    if (!_userLabel) {
        _userLabel = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:[UIColor dl_textColorStyle1] font:[UIFont dl_defaultFont]];
    }
    return _userLabel;
}


@end
