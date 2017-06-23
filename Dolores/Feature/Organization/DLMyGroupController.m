//
// DLMyGroupController
// Artsy
//
//  Created by heath on 23/06/2017.
//  Copyright (c) 2014 http://artsy.net. All rights reserved.
//
#import "DLMyGroupController.h"
#import "UIColor+DLAdd.h"

@interface DLMyGroupController ()

@end

@implementation DLMyGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的群组";

    UILabel *lblNoData = [UILabel labelWithAlignment:NSTextAlignmentCenter textColor:[UIColor dl_leadColor] font:[UIFont dl_largeFont] text:@"暂无群组"];
    [self.view addSubview:lblNoData];
    [lblNoData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointZero);
    }];
}

@end