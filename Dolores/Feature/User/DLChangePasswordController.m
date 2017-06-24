//
//  DLChangePasswordController.m
//  Dolores
//
//  Created by Heath on 24/06/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLChangePasswordController.h"
#import "UIColor+DLAdd.h"
#import "DLNetworkService.h"
#import "DLNetworkService+DLAPI.h"
#import "NSString+YYAdd.h"

@interface DLChangePasswordController ()

@property (nonatomic, strong) UITextField *fldOrigin;
@property (nonatomic, strong) UITextField *fldNew;
@property (nonatomic, strong) UITextField *fldConfirm;

@property (nonatomic, strong) UIButton *btnDone;

@end

@implementation DLChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"修改密码";
    [self setupView];
    [self setupData];
}

- (void)setupView {
    UIView *line1 = [UIView new];
    line1.backgroundColor = [UIColor dl_separatorColor];

    UIView *line2 = [UIView new];
    line2.backgroundColor = [UIColor dl_separatorColor];

    UIView *line3 = [UIView new];
    line3.backgroundColor = [UIColor dl_separatorColor];

    [self.view addSubview:self.fldOrigin];
    [self.view addSubview:line1];
    [self.view addSubview:self.fldNew];
    [self.view addSubview:line2];
    [self.view addSubview:self.fldConfirm];
    [self.view addSubview:line3];
    [self.view addSubview:self.btnDone];

    [self.fldOrigin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kDefaultGap));
        make.right.equalTo(@(-kDefaultGap));
        make.height.mas_equalTo(38);
        make.top.equalTo(@24);
    }];

    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kDefaultGap));
        make.right.equalTo(@(-kDefaultGap));
        make.top.equalTo(self.fldOrigin.mas_bottom);
        make.height.mas_equalTo(.6f);
    }];

    [self.fldNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kDefaultGap));
        make.right.equalTo(@(-kDefaultGap));
        make.top.equalTo(line1.mas_bottom);
        make.height.mas_equalTo(38);
    }];

    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kDefaultGap));
        make.right.equalTo(@(-kDefaultGap));
        make.top.equalTo(self.fldNew.mas_bottom);
        make.height.mas_equalTo(.6f);
    }];

    [self.fldConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kDefaultGap));
        make.right.equalTo(@(-kDefaultGap));
        make.top.equalTo(line2.mas_bottom);
        make.height.mas_equalTo(38);
    }];

    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kDefaultGap));
        make.right.equalTo(@(-kDefaultGap));
        make.top.equalTo(self.fldConfirm.mas_bottom);
        make.height.mas_equalTo(.6f);
    }];

    [self.btnDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fldNew);
        make.top.equalTo(self.fldConfirm.mas_bottom).offset(20);
        make.height.mas_equalTo(38);
    }];

}

- (void)setupData {

    RAC(self.btnDone, enabled) = [RACSignal combineLatest:@[[self.fldNew rac_textSignal], [self.fldConfirm rac_textSignal], [self.fldOrigin rac_textSignal]]
                                                   reduce:^id(NSString *textNew, NSString *textConfirm, NSString *textOrigin) {
        return @(textNew.length >= 6 && textConfirm.length >= 6 && textOrigin.length >= 6 && [textNew isEqualToString:textConfirm]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (UITextField *)createPasswordTextFiledWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] init];
    [textField setLeftPaddingText:title width:60];
    textField.placeholder = placeholder;
    textField.secureTextEntry = YES;
    textField.font = [UIFont dl_defaultFont];
    return textField;
}

#pragma mark - touch action

- (void)onClickSubmit {
    [self.view endEditing:YES];
    [self showLoadingView];
    [[DLNetworkService changePassword:[self.fldNew.text md5String] origin:[self.fldOrigin.text md5String]] subscribeNext:^(id x) {
        [self showInfo:@"密码已修改"];

        [[RACScheduler mainThreadScheduler] afterDelay:1.5 schedule:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];

    } error:^(NSError *error) {
        [self showInfo:[error message]];
    }];
}

#pragma mark - Getter

- (UITextField *)fldOrigin {
    if (!_fldOrigin) {
        _fldOrigin = [self createPasswordTextFiledWithTitle:@"旧密码" placeholder:@"请输入原始密码"];
        _fldOrigin.returnKeyType = UIReturnKeyNext;
    }
    return _fldOrigin;
}

- (UITextField *)fldNew {
    if (!_fldNew) {
        _fldNew = [self createPasswordTextFiledWithTitle:@"新密码" placeholder:@"请输入新密码"];
        _fldNew.returnKeyType = UIReturnKeyNext;
    }
    return _fldNew;
}

- (UITextField *)fldConfirm {
    if (!_fldConfirm) {
        _fldConfirm = [self createPasswordTextFiledWithTitle:@"新密码" placeholder:@"请再次输入新密码"];
        _fldConfirm.returnKeyType = UIReturnKeyDone;
    }
    return _fldConfirm;
}

- (UIButton *)btnDone {
    if (!_btnDone) {
        _btnDone = [UIButton buttonWithFont:[UIFont baseBoldFont:16] title:@"确定" textColor:[UIColor whiteColor] backgroundColor:[UIColor dl_primaryColor]];
        _btnDone.layer.masksToBounds = YES;
        _btnDone.layer.cornerRadius = 4;
        [_btnDone addTarget:self action:@selector(onClickSubmit) forControlEvents:UIControlEventTouchUpInside];
        _btnDone.enabled = NO;
    }
    return _btnDone;
}

@end
