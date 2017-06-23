    //
//  EPEmptyDataProtocol.m
//  VoiceBook
//
//  Created by Heath on 9/13/16.
//  Copyright © 2016 Heath. All rights reserved.
//

#import "EPEmptyDataProtocol.h"

@interface EPEmptyDataProtocol ()

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

@end

@implementation EPEmptyDataProtocol

- (instancetype)initWithReferScrollView:(UIScrollView *)referScrollView emptyText:(NSString *)emptyText {
    self = [super init];
    if (self) {
        _referScrollView = referScrollView;
        _emptyText = emptyText;
        _shouldScroll = YES;
        referScrollView.emptyDataSetSource = self;
        referScrollView.emptyDataSetDelegate = self;
    }

    return self;
}

+ (instancetype)protocolWithReferScrollView:(UIScrollView *)referScrollView emptyText:(NSString *)emptyText {
    return [[self alloc] initWithReferScrollView:referScrollView emptyText:emptyText];
}

- (void)addTarget:(id)target action:(SEL)action {
    self.target = target;
    self.action = action;
}


#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.emptyAttrString) {
        return self.emptyAttrString;
    }
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self.emptyText attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor lightTextColor]}];
    return attr;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.verticalOffset;
}

- (nullable UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return self.placeImage;
}


- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    return self.customView;
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.shouldDisplay;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return self.shouldScroll;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if ([self.target respondsToSelector:_action]) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:_action];
#pragma clang diagnostic pop
        
    }
}

#pragma mark - Setter

- (void)setVerticalOffset:(CGFloat)verticalOffset {
    _verticalOffset = verticalOffset;
    if ([self shouldReload]) {
        [self.referScrollView reloadEmptyDataSet];
    }
}

- (void)setShouldDisplay:(BOOL)shouldDisplay {
    _shouldDisplay = shouldDisplay;
    if (self.referScrollView) {
        [self.referScrollView reloadEmptyDataSet];
    }
}

- (void)setShouldScroll:(BOOL)shouldScroll {
    _shouldScroll = shouldScroll;
    if ([self shouldDisplay]) {
        [self.referScrollView reloadEmptyDataSet];
    }
}

- (void)setCustomView:(UIView *)customView {
    _customView = customView;
    if ([self shouldDisplay]) {
        [self.referScrollView reloadEmptyDataSet];
    }
}

- (BOOL)shouldReload {
    return self.referScrollView && self.shouldDisplay;
}

//- (void)dealloc {
//    NSLog(@"empty protocol release.");
//}

@end
