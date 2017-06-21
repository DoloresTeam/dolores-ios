//
//  DLLoginController.m
//  Dolores
//
//  Created by Heath on 24/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <YYCategories/NSString+YYAdd.h>
#import "DLLoginController.h"
#import "UIColor+YYAdd.h"
#import "UIBarButtonItem+DLAdd.h"
#import "DLRegisterController.h"
#import "DLNetworkService.h"
#import "DLNetworkService+DLAPI.h"
#import "NSDate+YYAdd.h"
#import "AFHTTPSessionManager.h"
#import "DLContactManager.h"
#import "UIColor+DLAdd.h"

@interface DLLoginController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *fldUser;
@property (nonatomic, strong) UITextField *fldPassword;
@property (nonatomic, strong) UIButton *btnLogin;
@property (nonatomic, strong) UIButton *btnNoAccount;

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
//    UIBarButtonItem *barButtonItem = [UIBarButtonItem initWithTitle:@"注册" target:self action:@selector(onClickRegisterButton:)];
//    self.navigationItem.rightBarButtonItem = barButtonItem;
}


- (void)setupView {
    [self.view addSubview:self.fldUser];
    [self.view addSubview:self.fldPassword];
    [self.view addSubview:self.btnLogin];
    [self.view addSubview:self.btnNoAccount];

    [self setupViewConstraints];
}

- (void)setupData {
    self.fldUser.text = [NSUserDefaults getCurrentUser];
}

- (void)setupViewConstraints {
    [self.fldUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@14);
        make.right.equalTo(@(-14));
        make.height.mas_equalTo(36);
        make.top.equalTo(@50);
    }];

    UIView *line = [UIView new];
    line.backgroundColor = [UIColor dl_separatorColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fldUser);
        make.top.equalTo(self.fldUser.mas_bottom);
        make.height.mas_equalTo(.6f);
    }];

    [self.fldPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.fldUser);
        make.top.equalTo(self.fldUser.mas_bottom);
    }];

    UIView *line2 = [UIView new];
    line2.backgroundColor = [UIColor dl_separatorColor];
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fldUser);
        make.top.equalTo(self.fldPassword.mas_bottom);
        make.height.mas_equalTo(.6f);
    }];

    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fldUser);
        make.top.equalTo(self.fldPassword.mas_bottom).offset(20);
        make.height.equalTo(@36);
    }];
    
    [self.btnNoAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.top.equalTo(self.btnLogin.mas_bottom).offset(10);
        make.centerX.equalTo(self.btnLogin.mas_centerX);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self onClickLogin];
    return YES;
}

#pragma mark - touch action

- (void)onClickNoAccount:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Dolores不支持用户自主注册账号，请前往Github生成账号。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好的, 我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:true completion:^{
        
    }];
}

- (void)onClickLogin {
    [self.view endEditing:YES];
    if (![self.fldUser.text isNotBlank] || ![self.fldPassword.text isNotBlank]) {
        [MBProgressHUD showError:@"用户名或密码为空" toView:self.navigationController.view hideDelay:1.5];
        return;
    }

    [self showLoadingView];

    [[DLNetworkService login:self.fldUser.text password:[self.fldPassword.text md5String]] subscribeNext:^(id resp) {
        // "expire" : "2017-05-18T13:27:14+08:00"
        [NSUserDefaults setCurrentUser:self.fldUser.text];
        [DLDBQueryHelper configDefaultRealmDB:self.fldUser.text];
        [[DLNetworkService sharedInstance] setHeader:[NSString stringWithFormat:@"Dolores %@", resp[@"token"]] headerField:@"Authorization"];

        [[DLNetworkService myProfile] subscribeNext:^(id resp1) {
            
            NSString *uid = resp1[@"id"];
            [DLDBQueryHelper saveLoginUser:resp1];

            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            RMUser *user = [RMUser objectForPrimaryKey:uid];
            user.token = resp[@"token"];
            user.expireDate = resp[@"expire"];
            [realm commitWriteTransaction];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                EMError *error = [[EMClient sharedClient] loginWithUsername:resp1[@"id"] password:resp1[@"thirdPassword"]];
                if (error) {
                    [self showInfo:error.errorDescription];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        RLMRealm *realm = [RLMRealm defaultRealm];
                        [realm beginWriteTransaction];
                        RMUser *user = [RMUser objectForPrimaryKey:uid];
                        user.isLogin = @(YES);
                        [realm commitWriteTransaction];
                        
                        [self hideLoadingView];
                        [[DLContactManager sharedInstance] fetchOrganization];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusNotification object:@(YES)];
                    });
                }
            });


        } error:^(NSError *error) {
            [self showInfo:error.message];
        }];

    } error:^(NSError *error) {

        [self showInfo:error.message];
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - Getter

- (UITextField *)fldUser {
    if (!_fldUser) {
        _fldUser = [[UITextField alloc] init];
        _fldUser.placeholder = @"请输入手机号";
        _fldUser.keyboardType = UIKeyboardTypePhonePad;
        _fldUser.delegate = self;
        [_fldUser setLeftPaddingText:@"手机号" width:50];
        _fldUser.font = [UIFont systemFontOfSize:14];
    }
    return _fldUser;
}

- (UITextField *)fldPassword {
    if (!_fldPassword) {
        _fldPassword = [[UITextField alloc] init];
        _fldPassword.placeholder = @"请输入密码";
        _fldPassword.secureTextEntry = YES;
        _fldPassword.delegate = self;
        _fldPassword.font = [UIFont systemFontOfSize:14];
        [_fldPassword setLeftPaddingText:@"密码" width:50];
    }
    return _fldPassword;
}

- (UIButton *)btnLogin {
    if (!_btnLogin) {
        _btnLogin = [UIButton buttonWithFont:[UIFont baseBoldFont:16] title:@"确定" textColor:[UIColor whiteColor]
                             backgroundColor:[UIColor dl_primaryColor]];
        _btnLogin.layer.masksToBounds = YES;
        _btnLogin.layer.cornerRadius = 4;
        [_btnLogin addTarget:self action:@selector(onClickLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLogin;
}

- (UIButton *)btnNoAccount {
    if (!_btnNoAccount) {
        _btnNoAccount = [UIButton buttonWithFont:[UIFont baseFont:12] title:@"没有账号？" textColor:[UIColor lightGrayColor]];
        [_btnNoAccount addTarget:self action:@selector(onClickNoAccount:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnNoAccount;
}

@end
