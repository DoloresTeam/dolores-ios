//
//  DLNetStatusView.m
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLNetStatusView.h"

@interface DLNetStatusView ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation DLNetStatusView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self loadViews];

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) return nil;
    [self loadViews];

    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadViews];
    }
    return self;
}


#pragma mark - load views

- (void)loadViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.indicatorView];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointZero);
    }];

    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(self.titleLabel.mas_left).offset(kDefaultGap);
    }];
}

#pragma mark - Getter

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidesWhenStopped = YES;
    }
    return _indicatorView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithAlignment:NSTextAlignmentCenter textColor:[UIColor blackColor] font:[UIFont baseBoldFont:17]];
    }
    return _titleLabel;
}


@end
