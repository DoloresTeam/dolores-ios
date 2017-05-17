//
//  DLLoginController.m
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <YYCategories/NSString+YYAdd.h>
#import "DLLoginController.h"
#import "UIFloatLabelTextField.h"
#import "UIColor+YYAdd.h"
#import "UIBarButtonItem+DLAdd.h"
#import "DLRegisterController.h"
#import "DLNetworkService.h"
#import "DLNetworkService+DLAPI.h"
#import "NSDate+YYAdd.h"
#import "AFHTTPSessionManager.h"

@interface DLLoginController ()

@property (nonatomic, strong) UIFloatLabelTextField *fldUser;
@property (nonatomic, strong) UIFloatLabelTextField *fldPassword;
@property (nonatomic, strong) UIButton *btnLogin;

@end

@implementation DLLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"登录";
    [self setupNavigationBar];
    [self setupView];
    [self setupData];
}

- (void)setupNavigationBar {
    UIBarButtonItem *barButtonItem = [UIBarButtonItem initWithTitle:@"注册" target:self action:@selector(onClickRegisterButton:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}


- (void)setupView {
    [self.view addSubview:self.fldUser];
    [self.view addSubview:self.fldPassword];
    [self.view addSubview:self.btnLogin];

    [self setupViewConstraints];
}

- (void)setupData {
    NSString *user = [NSUserDefaults getLastUser];
    self.fldUser.text = user;
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

    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fldUser);
        make.top.equalTo(self.fldPassword.mas_bottom).offset(20);
        make.height.equalTo(@40);
    }];

}

#pragma mark - touch action

- (void)onClickRegisterButton:(UIButton *)sender {
    DLRegisterController *registerController = [DLRegisterController new];
    [self.navigationController pushViewController:registerController animated:YES];
}

- (void)onClickLogin {
    [self.view endEditing:YES];
    if (![self.fldUser.text isNotBlank] || ![self.fldPassword.text isNotBlank]) {
        [MBProgressHUD showError:@"用户名或密码为空" toView:self.navigationController.view hideDelay:1.5];
        return;
    }

    [self showLoadingView];

    [[DLNetworkService login:self.fldUser.text password:[self.fldPassword.text md5String]] subscribeNext:^(RACTuple *tuple) {
        NSDictionary *resp = tuple.first;
        // "expire" : "2017-05-18T13:27:14+08:00"
        [[DLNetworkService sharedInstance] setHeader:@"Authorization" headerField:[NSString stringWithFormat:@"Dolores %@", resp[@"token"]]];
        NSDate *date = [NSDate dateWithString:resp[@"expire"] format:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:28800] locale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];


        [NSUserDefaults saveLastUser:self.fldUser.text];
        [NSUserDefaults setLoginStatus:YES];
        [self hideLoadingView];

        [[DLNetworkService myOrganization] subscribeNext:^(id x) {

        } error:^(NSError *error) {

        }];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusNotification object:@(YES)];
//        });
    } error:^(NSError *error) {

        [self showInfo:error.message];
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - Getter

- (UIFloatLabelTextField *)fldUser {
    if (!_fldUser) {
        _fldUser = [[UIFloatLabelTextField alloc] init];
        _fldUser.placeholder = @"用户名";
        _fldUser.keyboardType = UIKeyboardTypePhonePad;
        _fldUser.floatLabelActiveColor = [UIColor colorWithHexString:@"1ef06a"];
    }
    return _fldUser;
}

- (UIFloatLabelTextField *)fldPassword {
    if (!_fldPassword) {
        _fldPassword = [[UIFloatLabelTextField alloc] init];
        _fldPassword.placeholder = @"密码";
        _fldPassword.floatLabelActiveColor = [UIColor colorWithHexString:@"1ef06a"];
        _fldPassword.secureTextEntry = YES;
    }
    return _fldPassword;
}

- (UIButton *)btnLogin {
    if (!_btnLogin) {
        _btnLogin = [UIButton buttonWithFont:[UIFont baseBoldFont:16] title:@"确定" textColor:[UIColor whiteColor]
                             backgroundColor:[UIColor blueColor]];
        _btnLogin.layer.masksToBounds = YES;
        _btnLogin.layer.cornerRadius = 8;
        [_btnLogin addTarget:self action:@selector(onClickLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLogin;
}


@end
