//
//  DLRegisterController.m
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <YYCategories/UIColor+YYAdd.h>
#import <YYCategories/NSString+YYAdd.h>
#import "DLRegisterController.h"
#import "UIFloatLabelTextField.h"

@interface DLRegisterController ()

@property (nonatomic, strong) UIFloatLabelTextField *fldUser;
@property (nonatomic, strong) UIFloatLabelTextField *fldPassword;
@property (nonatomic, strong) UIButton *btnRegister;

@end

@implementation DLRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
    [self setupView];
}

- (void)setupView {
    [self.view addSubview:self.fldUser];
    [self.view addSubview:self.fldPassword];
    [self.view addSubview:self.btnRegister];
    [self setupViewConstraints];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"注册";
}

- (void)setupViewConstraints {
    [self.fldUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@44);
        make.right.equalTo(@(-44));
        make.height.mas_equalTo(44);
        make.top.equalTo(@80);
    }];

    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"c4c4c4"];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fldUser);
        make.top.equalTo(self.fldUser.mas_bottom);
        make.height.mas_equalTo(.6f);
    }];

    [self.fldPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.fldUser);
        make.top.equalTo(self.fldUser.mas_bottom).offset(5);
    }];

    UIView *line2 = [UIView new];
    line2.backgroundColor = [UIColor colorWithHexString:@"c4c4c4"];
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fldUser);
        make.top.equalTo(self.fldPassword.mas_bottom);
        make.height.mas_equalTo(.6f);
    }];

    [self.btnRegister mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fldUser);
        make.top.equalTo(self.fldPassword.mas_bottom).offset(20);
        make.height.equalTo(@40);
    }];
}

#pragma mark - touch action

- (void)onClickRegister {
    if (![self.fldUser.text isNotBlank] || ![self.fldPassword.text isNotBlank]) {
        [MBProgressHUD showError:@"用户名或密码为空" toView:self.navigationController.view hideDelay:1.5];
        return;
    }

    if (self.fldUser.text.length < 6) {
        [self showInfo:@"用户名必须大于或等于6位"];
        return;
    }

    if (self.fldPassword.text.length < 3) {
        [self showInfo:@"密码长度至少为3位"];
        return;
    }

    [self showLoadingView];
    [[EMClient sharedClient] registerWithUsername:self.fldUser.text password:self.fldPassword.text completion:^(NSString *aUsername, EMError *aError) {
        if (aError) {
            [self showInfo:aError.errorDescription];
        } else {
            [NSUserDefaults setLoginStatus:YES];
            [self dismissViewControllerAnimated:YES completion:^{

            }];
        }
    }];

}

#pragma mark - Getter

- (UIFloatLabelTextField *)fldUser {
    if (!_fldUser) {
        _fldUser = [[UIFloatLabelTextField alloc] init];
        _fldUser.placeholder = @"用户名";
        _fldUser.floatLabelActiveColor = [UIColor colorWithHexString:@"b8f51e"];
        _fldUser.keyboardType = UIKeyboardTypeAlphabet;
    }
    return _fldUser;
}

- (UIFloatLabelTextField *)fldPassword {
    if (!_fldPassword) {
        _fldPassword = [UIFloatLabelTextField new];
        _fldPassword.placeholder = @"密码";
        _fldPassword.floatLabelActiveColor = [UIColor colorWithHexString:@"b8f51e"];
        _fldPassword.secureTextEntry = YES;
    }
    return _fldPassword;
}

- (UIButton *)btnRegister {
    if (!_btnRegister) {
        _btnRegister = [UIButton buttonWithFont:[UIFont baseBoldFont:16] title:@"注册" textColor:[UIColor whiteColor]
                             backgroundColor:[UIColor blueColor]];
        _btnRegister.layer.masksToBounds = YES;
        _btnRegister.layer.cornerRadius = 8;
        [_btnRegister addTarget:self action:@selector(onClickRegister) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRegister;
}

@end
