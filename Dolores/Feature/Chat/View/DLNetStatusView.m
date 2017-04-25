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

#pragma mark - public method

- (void)updateStatusView:(ConversationStatus)status {
    switch (status){
        case ConversationStatusNone:
        {
            [self.indicatorView stopAnimating];
            self.titleLabel.text = @"Dolores";
            [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(CGFLOAT_MIN);
            }];
        }
            break;
        case ConversationStatusFetching:
        {
            [self.indicatorView startAnimating];
            self.titleLabel.text = @"收取中...";
            [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(20);
            }];
        }
            break;
        case ConversationStatusDisconnect:
        {
            [self.indicatorView stopAnimating];
            self.titleLabel.text = @"Dolores(未连接)";
            [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(CGFLOAT_MIN);
            }];
        }
            break;
    }
}


#pragma mark - load views

- (void)loadViews {
    UIView *containerView = [UIView new];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointZero);
    }];

    [containerView addSubview:self.titleLabel];
    [containerView addSubview:self.indicatorView];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.bottom.equalTo(@0);
        make.centerY.equalTo(@0);
    }];

    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(self.titleLabel.mas_left).offset(-kDefaultGap);
        make.left.equalTo(@0);
        make.width.mas_equalTo(20);
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
