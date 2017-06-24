//
//  DLEditNicknameController.m
//  Dolores
//
//  Created by Heath on 24/06/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLEditNicknameController.h"
#import "UIColor+DLAdd.h"
#import "DLNetworkService.h"
#import "DLNetworkService+DLAPI.h"

@interface DLEditNicknameController ()

@property (nonatomic, strong) UITextField *fldName;
@property (nonatomic, strong) UIButton *btnSubmit;

@end

@implementation DLEditNicknameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
    [self setupView];
    [self bindData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.fldName becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"修改昵称";
}

- (void)setupView {
    [self.view addSubview:self.fldName];
    [self.view addSubview:self.btnSubmit];

    [self.fldName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kDefaultGap));
        make.top.equalTo(@30);
        make.right.equalTo(@(-kDefaultGap));
        make.height.mas_equalTo(38);
    }];

    [self.btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fldName);
        make.top.equalTo(self.fldName.mas_bottom).offset(20);
        make.height.equalTo(@36);
    }];

    self.btnSubmit.enabled = NO;
}

- (void)bindData {
    @weakify(self)
    [[self.fldName rac_textSignal] subscribeNext:^(NSString *x) {
        @strongify(self)
        self.btnSubmit.enabled = ![NSString isEmpty:x];
    }];
}

#pragma mark - touch action

- (void)onClickSubmit {
    [self showLoadingView];
    [[DLNetworkService updateMyProfile:@{@"cn": self.fldName.text}] subscribeNext:^(id x) {
        [self showInfo:@"Done"];
        [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    } error:^(NSError *error) {
        [self showInfo:[error message]];
    }];
}

#pragma mark - Getter

- (UITextField *)fldName {
    if (!_fldName) {
        _fldName = [[UITextField alloc] init];
        _fldName.placeholder = @"请输入昵称";
        _fldName.returnKeyType = UIReturnKeyDone;
//        [_fldName setLeftPaddingText:@"修改昵称" width:50];
        _fldName.font = [UIFont baseFont:16];
    }
    return _fldName;
}

- (UIButton *)btnSubmit {
    if (!_btnSubmit) {
        _btnSubmit = [UIButton buttonWithFont:[UIFont baseBoldFont:16] title:@"确定" textColor:[UIColor whiteColor] backgroundColor:[UIColor dl_primaryColor]];
        _btnSubmit.layer.masksToBounds = YES;
        _btnSubmit.layer.cornerRadius = 4;
        [_btnSubmit addTarget:self action:@selector(onClickSubmit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSubmit;
}


@end
