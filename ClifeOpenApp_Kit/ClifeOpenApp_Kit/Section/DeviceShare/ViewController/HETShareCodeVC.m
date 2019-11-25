//
//  HETShareCodeVC.m
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/9/29.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETShareCodeVC.h"
#import "SGQRCodeGenerateManager.h"

@interface HETShareCodeVC ()

///分享二维码 **/
@property (nonatomic,strong) UIImageView *codeImageView;
///分享文字 **/
@property (nonatomic,strong) UILabel *shareTipLabel;
///分享时效提示 **/
@property (nonatomic,strong) UILabel *shareTimeLabel;
///分享二维码扫描帮助
@property (nonatomic,strong) UILabel *shareScanLabel;

@end

@implementation HETShareCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = ShareFunctionFaceToFace;
    [self createSubView];
    [self getShareCode];
}

#pragma mark - Init
- (void)createSubView
{
    [self.view addSubview:self.shareTimeLabel];
    [self.shareTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
        make.height.mas_equalTo(16);
    }];
    
    [self.view addSubview:self.codeImageView];
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.shareTimeLabel.mas_bottom).offset(16);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    [self.view addSubview:self.shareScanLabel];
    [self.shareScanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.codeImageView.mas_bottom).offset(24);
        make.height.mas_equalTo(16);
    }];
    
    [self.view addSubview:self.shareTipLabel];
    [self.shareTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.shareScanLabel.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(32);
        make.right.equalTo(self.view).offset(-32);
    }];
}

#pragma mark - Request
- (void)getShareCode{
    WEAKSELF
    [HETDeviceShareBusiness getShareCodeWithDeviceId:self.deviceId shareType:HETDeviceShareType_FaceToFaceShare success:^(id responseObject) {
        STRONGSELF
        OPLog(@"responseObject == %@",responseObject);
        if ([[responseObject allKeys] containsObject:@"data"]) {
           NSDictionary *shareCodeDict = [responseObject valueForKey:@"data"];
           NSString *shareCode = [shareCodeDict valueForKey:@"shareCode"];
           [strongSelf setupGenerateQRCode:shareCode];
        }
    } failure:^(NSError *error) {
        OPLog(@"error == %@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
    }];
}

// 生成二维码
- (void)setupGenerateQRCode:(NSString *)shareCode{
    NSString *code = [NSString stringWithFormat:@"shareCode=%@",shareCode];
    // 将CIImage转换成UIImage，并放大显示
    self.codeImageView.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:code imageViewWidth:300];
}

#pragma mark - getters and setters
- (UIImageView *)codeImageView
{
    if (!_codeImageView) {
        _codeImageView = [UIImageView new];
        _codeImageView.backgroundColor = [UIColor colorFromHexRGB:@"ffffff"];
    }
    return _codeImageView;
}

- (UILabel *)shareTipLabel
{
    if (!_shareTipLabel) {
        _shareTipLabel = [UILabel new];
        _shareTipLabel.text = ShareFunctionAlertTips;
        _shareTipLabel.numberOfLines = 0;
    }
    return _shareTipLabel;
}

- (UILabel *)shareTimeLabel
{
    if (!_shareTimeLabel) {
        _shareTimeLabel = [UILabel new];
        _shareTimeLabel.text = ShareFunctionTimeTips;
        _shareTimeLabel.numberOfLines = 0;
        _shareTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _shareTimeLabel;
}

- (UILabel *)shareScanLabel
{
    if (!_shareScanLabel) {
        _shareScanLabel = [UILabel new];
        NSString *content = ShareFunctionScanTips;
        _shareScanLabel.text = content;
        _shareScanLabel.numberOfLines = 0;
        _shareScanLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _shareScanLabel;
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
