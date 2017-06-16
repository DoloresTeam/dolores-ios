//
//  DLContactSectionHeader.m
//  Dolores
//
//  Created by Heath on 25/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLContactSectionHeader.h"
#import "UIColor+YYAdd.h"

@implementation DLContactSectionHeader

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    _titleLabel = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"191919"] font:[UIFont dl_defaultFont]];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@(kDefaultGap));
    }];

    return self;
}


@end
