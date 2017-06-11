//
//  DLOrgDepartmentCell.m
//  Dolores
//
//  Created by Heath on 12/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLOrgDepartmentCell.h"
#import "UIColor+YYAdd.h"
#import "UIColor+DLAdd.h"
#import "RMDepartment.h"
#import "UIView+DLAdd.h"

@interface DLOrgDepartmentCell ()

@property (nonatomic, strong) UILabel *lblDepartment;
@property (nonatomic, strong) UIImageView *imgArrow;
@property (nonatomic, strong) UIView *line;

@end

@implementation DLOrgDepartmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebf9f9"];
    [self.contentView addSubview:self.lblDepartment];
    [self.contentView addSubview:self.imgArrow];
    [self.contentView addSubview:self.line];

    [self.lblDepartment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@(kDefaultGap));
        make.right.equalTo(self.imgArrow.mas_left).offset(-5);
    }];

    [self.imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 14));
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-10));
    }];

    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblDepartment.mas_left);
        make.bottom.right.equalTo(@0);
        make.height.mas_equalTo(.5f);
    }];

    return self;
}

- (void)updateDepartment:(RMDepartment *)department level:(NSInteger)level {
    self.lblDepartment.text = department.departmentName;
    [self.lblDepartment mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kDefaultGap + 20 * level));
    }];
    self.imgArrow.hidden = (department.staffs.count + department.childrenDepartments.count) <= 0;
}

- (void)animateExpandRow:(BOOL)expand {
    if (expand) {
        self.imgArrow.layer.anchorPoint = CGPointMake(0.5, 0.5);
        [UIView animateWithDuration:.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.imgArrow.transform = CGAffineTransformRotate(self.imgArrow.transform, M_PI);
        } completion:^(BOOL finished) {

        }];
    } else {
        [UIView animateWithDuration:.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.imgArrow.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {

        }];
    }
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

- (UILabel *)lblDepartment {
    if (!_lblDepartment) {
        _lblDepartment = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:[UIColor dl_leadColor] font:[UIFont baseBoldFont:15]];
    }
    return _lblDepartment;
}

- (UIImageView *)imgArrow {
    if (!_imgArrow) {
        _imgArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_down"]];
    }
    return _imgArrow;
}


@end
