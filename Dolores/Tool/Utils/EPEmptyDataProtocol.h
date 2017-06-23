//
//  EPEmptyDataProtocol.h
//  VoiceBook
//
//  Created by Heath on 9/13/16.
//  Copyright © 2016 Heath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollView+EmptyDataSet.h"

@interface EPEmptyDataProtocol : NSObject <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/**
 * 关联的scrollView
 */
@property (nonatomic, weak) UIScrollView *referScrollView;
/**
 * 以下2属性优先用emptyAttrString
 */
@property (nonatomic, copy) NSString *emptyText;
@property (nonatomic, copy) NSAttributedString *emptyAttrString;

// 视图image
@property (nonatomic, strong) UIImage *placeImage;

// 自定义视图
@property (nonatomic, strong) UIView *customView;

/**
 * y偏移
 */
@property (nonatomic, assign) CGFloat verticalOffset;

/**
 * 是否显示空视图
 */
@property (nonatomic, assign) BOOL shouldDisplay;

/**
 * 是否可以滚动
 */
@property (nonatomic, assign) BOOL shouldScroll;

// 初始化方法
- (instancetype)initWithReferScrollView:(UIScrollView *)referScrollView emptyText:(NSString *)emptyText;

+ (instancetype)protocolWithReferScrollView:(UIScrollView *)referScrollView emptyText:(NSString *)emptyText;

// 用户点击该视图方法
- (void)addTarget:(id)target action:(SEL)action;


@end
