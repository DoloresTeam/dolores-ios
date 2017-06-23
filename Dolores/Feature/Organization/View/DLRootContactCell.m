//
// DLRootContactCell
// Artsy
//
//  Created by heath on 23/06/2017.
//  Copyright (c) 2014 http://artsy.net. All rights reserved.
//
#import "DLRootContactCell.h"
#import "UIColor+DLAdd.h"

@interface DLRootContactCell ()


@end

@implementation DLRootContactCell

#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.imgPlace];
        [self.contentView addSubview:self.lblTitle];
        [self setupViewConstraints];
    }
    return self;
}

- (void)setupViewConstraints {
    [self.imgPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@(kDefaultGap));
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];

    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(self.imgPlace.mas_right).offset(kDefaultGap);
    }];
}

- (void)updateImage:(UIImage *)image title:(NSString *)title {
    self.lblTitle.text = title;
    self.imgPlace.image = image;
}

#pragma mark - Getter

- (UIImageView *)imgPlace {
    if (!_imgPlace) {
        _imgPlace = [[UIImageView alloc] init];
        _imgPlace.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgPlace;
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:[UIColor dl_leadColor] font:[UIFont dl_defaultFont]];
    }
    return _lblTitle;
}


@end