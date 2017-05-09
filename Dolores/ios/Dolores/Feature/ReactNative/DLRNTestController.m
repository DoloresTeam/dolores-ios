//
//  DLRNTestController.m
//  Dolores
//
//  Created by Heath on 08/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLRNTestController.h"
#import <React/RCTRootView.h>

@interface DLRNTestController ()

@end

@implementation DLRNTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [[NSURL alloc] initWithString:@"http://localhost:8081/index.ios.bundle?platform=ios"];
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:url moduleName:@"Dolores" initialProperties:@{} launchOptions:nil];
    self.view = rootView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
