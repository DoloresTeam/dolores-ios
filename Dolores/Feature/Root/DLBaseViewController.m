//
//  DLBaseViewController.m
//  Dolores
//
//  Created by Heath on 18/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLBaseViewController.h"

@interface DLBaseViewController ()

@end

@implementation DLBaseViewController

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoadingView {
    UIView *view1 = self.navigationController.view ? : self.view;
    [MBProgressHUD showMessage:nil toView:view1];
}


- (void)hideLoadingView {
    [MBProgressHUD hideHUDForView:self.navigationController.view ? : self.view animated:YES];
}

- (void)showInfo:(NSString *)info {
    UIView *view1 = self.navigationController.view ? : self.view;
    [MBProgressHUD showInfo:info toView:view1 hideDelay:2];
}


@end
