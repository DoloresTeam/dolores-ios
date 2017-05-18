//
//  DLOrgUserCell.m
//  Dolores
//
//  Created by Heath on 12/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <YYCategories/UIColor+YYAdd.h>
#import "DLOrgUserCell.h"
#import "UIColor+DLAdd.h"
#import "RMStaff.h"
#import "RMStaff.h"
#import "UIView+DLAdd.h"

@interface DLOrgUserCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIView *line;

@end

@implementation DLOrgUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    self.contentView.backgroundColor = [UIColor colorWithHexString:@"e7f4da"];
    [self.contentView addSubview:self.containerView];
    [self.contentView addSubview:self.line];
    [self.containerView addSubview:self.lblName];
    [self.containerView addSubview:self.lblTitle];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@-10);
        make.left.equalTo(@(kDefaultGap));
    }];

    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.height.mas_equalTo(17);
    }];

    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.lblName.mas_bottom).offset(0);
        make.bottom.equalTo(@0);
        make.height.mas_equalTo(17);
    }];

    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.bottom.right.equalTo(@0);
        make.height.mas_equalTo(.5f);
    }];

    return self;
}

- (void)updateStaff:(RMStaff *)staff level:(NSInteger)level {
    self.lblName.text = staff.realName;
    self.lblTitle.text = staff.title;
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kDefaultGap + 20 * level));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Getter

- (UIView *)line {
    if (!_line) {
        _line = [UIView initWithColor:[UIColor dl_separatorColor]];
    }
    return _line;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
    }
    return _containerView;
}


- (UILabel *)lblName {
    if (!_lblName) {
        _lblName = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:[UIColor dl_leadColor] font:[UIFont baseFont:15]];
    }
    return _lblName;
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:[UIColor dl_leadColor] font:[UIFont baseFont:15]];
    }
    return _lblTitle;
}


@end
