//
//  DLLogoutCell.m
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <YYCategories/UIColor+YYAdd.h>
#import "DLLogoutCell.h"

@implementation DLLogoutCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    [self loadViews];
    return self;
}

- (void)loadViews {
    UILabel *label = [UILabel labelWithAlignment:NSTextAlignmentCenter textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont baseFont:14]
                                            text:@"退出登录"];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointZero);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
