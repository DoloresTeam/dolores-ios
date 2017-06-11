//
//  DLMineHeaderView.m
//  Dolores
//
//  Created by Heath on 19/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLMineHeaderView.h"
#import "UIColor+DLAdd.h"
#import "UIColor+YYAdd.h"
#import "NSString+YYAdd.h"

@interface DLMineHeaderView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblCompany;
@property (nonatomic, strong) UIImageView *imgAvatar;

@end

@implementation DLMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"];
    [self loadViews];

    return self;
}

- (void)loadViews {
    [self addSubview:self.containerView];

    [self.containerView addSubview:self.lblName];
    [self.containerView addSubview:self.lblTitle];
    [self.containerView addSubview:self.lblCompany];
    [self.containerView addSubview:self.imgAvatar];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@20);
        make.right.bottom.equalTo(@(-20));
    }];

    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kDefaultGap));
        make.centerY.equalTo(self.imgAvatar.mas_centerY);
        make.right.equalTo(self.imgAvatar.mas_left).offset(-20);
    }];

    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kDefaultGap));
        make.top.equalTo(self.lblName.mas_bottom);
        make.right.equalTo(self.imgAvatar.mas_left).offset(-20);
    }];

    [self.imgAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(52, 52));
        make.top.equalTo(@(kDefaultGap));
        make.right.equalTo(@(-kDefaultGap));
    }];

    [self.lblCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kDefaultGap));
        make.right.equalTo(self.lblName);
        make.bottom.equalTo(@(-kDefaultGap));
    }];
}

- (void)updateUserInfo:(RMStaff *)user {

    NSMutableString *name = [NSMutableString string];
    [name appendString:user.realName];;
    if ([user.nickName isNotBlank]) {
        [name appendFormat:@"【%@】", user.nickName];
    }
    self.lblName.text = name;

    self.lblTitle.text = user.title;
    [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:user.avatarURL] placeholderImage:[UIImage imageNamed:@"contact_icon_avatar_placeholder_round"]];
}

#pragma mark - touch

- (void)onTappedUserAvatar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapUserAvatar)]) {
        [self.delegate didTapUserAvatar];
    }
}

#pragma mark - Getter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 8.f;
    }
    return _containerView;
}

- (UILabel *)lblName {
    if (!_lblName) {
        _lblName = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:[UIColor dl_leadColor] font:[UIFont baseBoldFont:14]];
    }
    return _lblName;
}

- (UILabel *)lblCompany {
    if (!_lblCompany) {
        _lblCompany = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:[UIColor dl_leadColor] font:[UIFont baseFont:14]];
    }
    return _lblCompany;
}

- (UIImageView *)imgAvatar {
    if (!_imgAvatar) {
        _imgAvatar = [[UIImageView alloc] init];
        _imgAvatar.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTappedUserAvatar)];
        [_imgAvatar addGestureRecognizer:tapGestureRecognizer];
    }
    return _imgAvatar;
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:[UIColor dl_leadColor] font:[UIFont baseFont:14]];
    }
    return _lblTitle;
}


@end
