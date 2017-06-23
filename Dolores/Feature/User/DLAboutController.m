//
//  DLAboutController.m
//  Dolores
//
//  Created by Heath on 23/06/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLAboutController.h"
#import "UIColor+DLAdd.h"

@interface DLAboutController ()

@end

@implementation DLAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *lblAbout = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:[UIColor dl_leadColor] font:[UIFont dl_largeFont] lines:0 text:@"Dolores试图成为一套完整的企业通信解决方案，一个完整的企业沟通工具。"];
    [self.view addSubview:lblAbout];
    [lblAbout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@(-20));
        make.top.equalTo(@20);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
