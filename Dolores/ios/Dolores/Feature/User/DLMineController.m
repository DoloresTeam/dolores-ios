//
//  DLMineController.m
//  Dolores
//
//  Created by Heath on 18/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLMineController.h"
#import "DLLogoutCell.h"
#import "NSNotificationCenter+YYAdd.h"
#import "DLMineHeaderView.h"
#import "DLTableCellConfig.h"
#import "DLMineSettingCell.h"
#import <Photos/PHPhotoLibrary.h>
#import "UIAlertView+DLAdd.h"
#import "DLNetworkService.h"
#import "DLNetworkService+DLAPI.h"
#import <QiniuSDK.h>

@interface DLMineController () <UITableViewDataSource, UITableViewDelegate, MineHeaderDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) DLMineHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<DLTableSectionConfig *> *dataArray;

@end

@implementation DLMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
    [self setupData];
    [self setupView];
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.headerView updateUserInfo];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"我的";
}

- (void)setupData {
    DLTableCellConfig *account = [[DLTableCellConfig alloc] initWithName:@"账号与安全" showMore:YES];
    DLTableSectionConfig *section1 = [[DLTableSectionConfig alloc] initWithCells:@[account]];

    DLTableCellConfig *messageNotify = [[DLTableCellConfig alloc] initWithName:@"新消息通知" showMore:YES];
    DLTableCellConfig *privacy = [[DLTableCellConfig alloc] initWithName:@"隐私" showMore:YES];
    DLTableCellConfig *common = [[DLTableCellConfig alloc] initWithName:@"通用" showMore:YES];
    DLTableSectionConfig *section2 = [[DLTableSectionConfig alloc] initWithCells:@[messageNotify, privacy, common]];

    DLTableCellConfig *about = [[DLTableCellConfig alloc] initWithName:@"关于Dolores" showMore:YES];
    DLTableSectionConfig *section3 = [[DLTableSectionConfig alloc] initWithCells:@[about]];

    DLTableCellConfig *logout = [[DLTableCellConfig alloc] initWithName:@"退出登录" showMore:YES];
    DLTableSectionConfig *section4 = [[DLTableSectionConfig alloc] initWithCells:@[logout]];
    self.dataArray = @[section1, section2, section3, section4];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DLTableSectionConfig *sectionConfig = self.dataArray[section];
    return sectionConfig.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLTableSectionConfig *sectionConfig = self.dataArray[indexPath.section];
    if (self.dataArray.count - 1 == indexPath.section) {
        DLLogoutCell *logoutCell = [tableView dequeueReusableCellWithIdentifier:[DLLogoutCell identifier]];
        return logoutCell;
    } else {
        DLTableCellConfig *cellConfig = sectionConfig.cells[indexPath.row];
        DLMineSettingCell *settingCell = [tableView dequeueReusableCellWithIdentifier:[DLMineSettingCell identifier]];
        [settingCell updateCell:cellConfig];
        return settingCell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[DLLogoutCell class]]) {

        [self showLoadingView];
        [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
            if (!aError) {
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm transactionWithBlock:^{
                    RMUser *user = [DLDBQueryHelper currentUser];
                    user.logoutTimestamp = @([[NSDate date] timeIntervalSince1970]);
                    user.isLogin = @(NO);
                    [realm addOrUpdateObject:user];
                }];
                [self hideLoadingView];
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:kLoginStatusNotification object:@(NO) userInfo:nil];
            } else {
                [self showInfo:aError.errorDescription];
            }
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    [self dismissViewControllerAnimated:YES completion:NULL];

    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self uploadImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - MineHeaderDelegate

- (void)didTapUserAvatar {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"编辑头像" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:self.navigationController.view];
    [[actionSheet rac_buttonClickedSignal] subscribeNext:^(NSNumber *index) {
        NSInteger index_ = index.integerValue;

        if (index_ == 0) {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            switch (status) {
                case AVAuthorizationStatusAuthorized:
                {
                    [self showTakingPhoto];
                }
                    break;
                case AVAuthorizationStatusDenied:
                case AVAuthorizationStatusRestricted:
                {
                    [UIAlertView alertSettingCamera];
                }
                    break;
                case AVAuthorizationStatusNotDetermined:
                {
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        if (granted) {
                            [self showTakingPhoto];
                        } else {
                            [UIAlertView alertSettingCamera];
                        }
                    }];
                }
                    break;
                default:
                    break;
            }

        } else if (index_ == 1) {
            PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
            switch (authorizationStatus) {
                case PHAuthorizationStatusAuthorized:
                {
                    [self showPickPhoto];
                }
                    break;
                case PHAuthorizationStatusDenied:
                case PHAuthorizationStatusRestricted:
                {
                    [UIAlertView alertSettingPhoto];
                }
                    break;
                case PHAuthorizationStatusNotDetermined:
                {
                    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                        if (status == PHAuthorizationStatusAuthorized) {
                            [self showPickPhoto];
                        } else if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
                            [UIAlertView alertSettingPhoto];
                        }
                    }];
                }
                    break;
                default:
                    break;
            }
        }

    }];
}

#pragma mark - private method

- (void)showTakingPhoto {

    dispatch_async(dispatch_get_main_queue(), ^{

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.allowsEditing = YES;
            [self.navigationController presentViewController:pickerController animated:YES completion:^{

            }];
        }

    });

}

- (void)showPickPhoto {

    dispatch_async(dispatch_get_main_queue(), ^{

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.allowsEditing = YES;
            [self.navigationController presentViewController:pickerController animated:YES completion:^{

            }];
        }

    });
}

- (void)uploadImage:(UIImage *)image {
    MBProgressHUD *hud = [MBProgressHUD vb_HUDForView:self.navigationController.view];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.progress = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = UIImageJPEGRepresentation(image, 1);
        QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithProgressHandler:^(NSString *key, float percent) {
            hud.progress = percent;
        }];
        QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
        [uploadManager putData:data key:nil token:[NSUserDefaults getQiniuToken] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (resp) {
                NSLog(@"**** %@", resp);
                [[DLNetworkService updateUserAvatar:resp[@"hash"]] subscribeNext:^(id x) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hide:YES];
                    });
                } error:^(NSError *error) {
                    [MBProgressHUD showError:[error message] toView:self.navigationController.view hideDelay:1.5];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        hud.mode = MBProgressHUDModeText;
//                        hud.labelText = @"上传头像失败，请重试";
//                        [hud hide:YES afterDelay:1.5];
//                    });
                }];

            } else {
                if (info.statusCode == kQNInvalidToken) {
                    [[DLNetworkService getQiniuToken] subscribeNext:^(id x) {
                        [self uploadImage:image];
                    } error:^(NSError *error) {
                        [MBProgressHUD showError:@"上传头像失败，请重试" toView:self.navigationController.view hideDelay:1.5];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            hud.mode = MBProgressHUDModeText;
//                            hud.labelText = @"上传头像失败，请重试";
//                            [hud hide:YES afterDelay:1.5];
//                        });
                    }];
                } else {
                    [MBProgressHUD showError:@"上传头像失败，请重试" toView:self.navigationController.view hideDelay:1.5];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        hud.mode = MBProgressHUDModeText;
//                        hud.labelText = @"上传头像失败，请重试";
//                        [hud hide:YES afterDelay:1.5];
//                    });


                }
            }
        } option:uploadOption];
    });
}


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.rowHeight = 50;

        [DLLogoutCell registerIn:_tableView];
        [DLMineSettingCell registerIn:_tableView];
    }
    return _tableView;
}

- (DLMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DLMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        _headerView.delegate = self;
    }
    return _headerView;
}


@end
