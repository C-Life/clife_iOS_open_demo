//
//  HETSQRCodeScanningVC.m
//  ClifeOpenApp_Kit
//
//  Created by miao on 2018/1/23.
//  Copyright © 2018年 het. All rights reserved.
//

#import "HETSQRCodeScanningVC.h"
#import "HETSetPassWordVC.h"
#import "HETBindBleDeviceVC.h"
#import "HETBindGPRSDeviceVC.h"
#import "SGQRCode.h"

@interface HETSQRCodeScanningVC () <SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation HETSQRCodeScanningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // 1.设置背景颜色
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    // 2.设置导航栏
    [self createNavViews];
    [self setupQRCodeScanning];

    // 3.初始化界面
    [self createSubView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scanningView addTimer];
    [_manager resetSampleBufferDelegate];
    [self.manager startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
    [self removeFlashlightBtn];
    [_manager cancelSampleBufferDelegate];
}

- (void)createNavViews {
    self.navigationItem.title = ScanQRCodeTitle;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:PhotoLibrary style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
}

- (void)createSubView
{
    [self.view addSubview:self.scanningView];
    [self.view addSubview:self.promptLabel];
    CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(promptLabelY);
        make.left.right.equalTo(self.view);
    }];
    [self.view addSubview:self.bottomView];
}

#pragma mark - - - SGQRCodeAlbumManagerDelegate
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    [self.view addSubview:self.scanningView];
}
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    [self getScanResult:result];
}

- (void)QRCodeAlbumManagerDidReadQRCodeFailure:(SGQRCodeAlbumManager *)albumManager {
    NSLog(@"暂未识别出二维码");
}

#pragma mark - - - SGQRCodeScanManagerDelegate
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    OPLog(@"metadataObjects - - %@", metadataObjects);
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [scanManager playSoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];
//        [scanManager videoPreviewLayerRemoveFromSuperlayer];
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        [self getScanResult:[obj stringValue]];
    } else {
        OPLog(@"暂未识别出扫描的二维码");
        [self scanError];
    }
}

- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue {
    if (brightnessValue < - 1) {
        [self.view addSubview:self.flashlightBtn];
    } else {
        if (self.isSelectedFlashlightBtn == NO) {
            [self removeFlashlightBtn];
        }
    }
}

#pragma mark - 点击事件
- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)rightBarButtonItenAction {
    SGQRCodeAlbumManager *manager = [SGQRCodeAlbumManager sharedManager];
    [manager readQRCodeFromAlbumWithCurrentController:self];
    manager.delegate = self;

    if (manager.isPHAuthorization == YES) {
        [self.scanningView removeTimer];
    }
}

- (void)setupQRCodeScanning {
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    //    [manager cancelSampleBufferDelegate];
    _manager.delegate = self;
}

- (void)flashlightBtn_action:(UIButton *)button {
    if (button.selected == NO) {
        [SGQRCodeHelperTool SG_openFlashlight];
        self.isSelectedFlashlightBtn = YES;
        button.selected = YES;
    } else {
        [self removeFlashlightBtn];
    }
}

- (void)removeFlashlightBtn {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SGQRCodeHelperTool SG_CloseFlashlight];
        self.isSelectedFlashlightBtn = NO;
        self.flashlightBtn.selected = NO;
        [self.flashlightBtn removeFromSuperview];
    });
}

- (void)getScanResult:(NSString *)urlStr
{
    // 例子：urlStr: http://open.clife.net/v1/web/open/product?param={"a":xxx}
    // 直接扫描二维码获取产品id，再获取设备信息
    if ([urlStr rangeOfString:@"product?param="].length > 0) {
        [self scanDevice:urlStr];
    }
    // https://api.clife.cn/v1/device/getQrcode?param={"a":xxx,"m":"xxx","i":"xxx"}
    // 扫描二维码，获取产品id,mac地址，设备imei，再绑定GSM设备
    else if ([urlStr rangeOfString:@"getQrcode?param"].length > 0) {
        [self bindGSMDevice:urlStr];
    }
    // 扫描获取分享码
    else if ([urlStr rangeOfString:@"shareCode"].length > 0) {
        [self scanShareCode:urlStr];
    }
    // 扫描条形码获取设备信息
    else if ([self isDigital:urlStr]){
        [self getDeviceInfoWithUrlStr:urlStr];
    }
    // 扫描H5调试地址
    else if ([urlStr rangeOfString:@"http"].length > 0) {
        if (self.h5PathBlock)
        {
            self.h5PathBlock(urlStr);
            [HETCommonHelp showAutoDissmissWithMessage:@"获取到新的H5调试地址!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else{
             [self.manager startRunning];
        }
    }
    // 扫描失败
    else{
        [self scanError];
    }
}

// 判断是是数字开头
- (BOOL)isDigital:(NSString *)resultStr
{
    const char *tempstr = [resultStr UTF8String];
    char temp = tempstr[0];
    printf("----->首字符:%c\n\r",temp);
    if (temp>='0' && temp<= '9')
        return YES;
    else
        return NO;
}

- (void)scanDevice:(NSString *)urlStr
{
    NSArray *arr = [urlStr componentsSeparatedByString:@"="];
    NSString *jsonStr = [arr lastObject];
    NSData *JSONData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSONDict = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    NSNumber *productId = [responseJSONDict valueForKey:@"a"];
    //    NSNumber *productId = @2275;
    [self getDeviceInfoWithProductId:[NSString stringWithFormat:@"%@",productId]];
}

- (void)scanShareCode:(NSString *)urlStr
{
    NSArray *array = [urlStr componentsSeparatedByString:@"="];
    NSString *shareCode = [array lastObject];
    WEAKSELF
    [HETDeviceShareBusiness authShareDeviceWithShareCode:shareCode shareType:HETDeviceShareType_FaceToFaceShare success:^(id responseObject) {
        STRONGSELF
        OPLog(@"responseObject == %@",responseObject);
        [HETCommonHelp showHudAutoHidenWithMessage:GetDeviceControlAuthSuccess];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBindDeviceSuccess object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        STRONGSELF
        OPLog(@"error == %@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf backAction];
        });
    }];
}

- (void)scanError
{
    //二维码内容解析失败
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:ScanQRCodeFailed message:ScanQRCodeFailedAlertMessage preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self) weakSelf = self;
    UIAlertAction *action = [UIAlertAction actionWithTitle:CommonSure style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //重新扫描
        [weakSelf.manager startRunning];
    }];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:^{
    }];
}

- (void)getDeviceInfoWithProductId:(NSString *)productId
{
    [HETCommonHelp showMessage:ScanQRCodeGetDeiceInfoLoading toView:self.view];
    WEAKSELF
    [HETDeviceRequestBusiness fetchDeviceInfoWithProductId:productId success:^(id responseObject) {
        STRONGSELF
        [HETCommonHelp hideHudFromView:strongSelf.view];
        if ([[responseObject allKeys] containsObject:@"data"]) {
            NSDictionary *dataDict = [responseObject valueForKey:@"data"];
            // 根据bindType 区分设备绑定类型
            HETDevice *device = [HETDevice mj_objectWithKeyValues:dataDict];
            // wifi绑定
            if ([device.bindType integerValue] == 1) {
                HETSetPassWordVC *setPasswordVC =  [HETSetPassWordVC new];
                setPasswordVC.device = device;
                [strongSelf.navigationController pushViewController:setPasswordVC animated:YES];
                return ;
            }
            // 蓝牙绑定
            if ([device.bindType integerValue] == 2) {
                HETBindBleDeviceVC *bindBleDeviceVC = [HETBindBleDeviceVC new];
                bindBleDeviceVC.device = device;
                [strongSelf.navigationController pushViewController:bindBleDeviceVC animated:YES];
                return ;
            }
            
            // GPRS绑定
            if ([device.bindType integerValue] == 4 || [device.bindType integerValue] == 6 || [device.bindType integerValue] == 8) {
                HETBindGPRSDeviceVC *gprsVC = [HETBindGPRSDeviceVC new];
                gprsVC.device = device;
                [self.navigationController pushViewController:gprsVC animated:YES];
                return;
            }
            [HETCommonHelp showHudAutoHidenWithMessage:ScanQRCodeGetMessageFailed];
            [strongSelf.manager startRunning];
        }
    } failure:^(NSError *error) {
        STRONGSELF
        [HETCommonHelp hideHudFromView:strongSelf.view];
        [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf backAction];
        });
    }];
}

- (void)bindGSMDevice:(NSString *)urlStr
{
    NSArray *arr = [urlStr componentsSeparatedByString:@"="];
    NSString *jsonStr = [arr lastObject];
    NSData *JSONData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSONDict = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    NSNumber *productId = [responseJSONDict valueForKey:@"a"];
    NSNumber *mac = [responseJSONDict valueForKey:@"m"];
    NSNumber *imei = [responseJSONDict valueForKey:@"i"];

    if (productId && (mac || imei)) {
    
        NSString *imeiStr = [NSString stringWithFormat:@"%@",imei?imei:@""];
        NSString *macStr = [NSString stringWithFormat:@"%@",mac?mac:@""];
        HETBindGPRSDeviceVC *gprsVC = [HETBindGPRSDeviceVC new];
        gprsVC.mac = macStr;
        gprsVC.imei = imeiStr;
        gprsVC.productId = [NSString stringWithFormat:@"%@",productId];
        [self.navigationController pushViewController:gprsVC animated:YES];
    }else{
        [self scanError];
    }
}

- (void)getDeviceInfoWithUrlStr:(NSString *)urlStr{
    NSDictionary *params = @{@"barCode":urlStr};
    WEAKSELF
    [HETCommonHelp showMessage:ScanQRCodeGetDeiceInfoLoading toView:self.view];
    [HETDeviceRequestBusiness startRequestWithHTTPMethod:HETRequestMethodPost withRequestUrl:GetProductByIdOrCode processParams:params needSign:NO BlockWithSuccess:^(id responseObject) {
        STRONGSELF
        [HETCommonHelp hideHudFromView:strongSelf.view];
        if ([[responseObject allKeys] containsObject:@"data"]) {
            NSDictionary *dataDict = [responseObject valueForKey:@"data"];
            // 根据bindType 区分设备绑定类型
            HETDevice *device = [HETDevice mj_objectWithKeyValues:dataDict];
            // wifi绑定
            if ([device.bindType integerValue] == 1) {
                HETSetPassWordVC *setPasswordVC =  [HETSetPassWordVC new];
                setPasswordVC.device = device;
                [strongSelf.navigationController pushViewController:setPasswordVC animated:YES];
                return ;
            }
            // 蓝牙绑定
            if ([device.bindType integerValue] == 2) {
                HETBindBleDeviceVC *bindBleDeviceVC = [HETBindBleDeviceVC new];
                bindBleDeviceVC.device = device;
                [strongSelf.navigationController pushViewController:bindBleDeviceVC animated:YES];
                return ;
            }
            
            // GPRS绑定
            if ([device.bindType integerValue] == 4 || [device.bindType integerValue] == 6 || [device.bindType integerValue] == 8) {
                HETBindGPRSDeviceVC *gprsVC = [HETBindGPRSDeviceVC new];
                gprsVC.device = device;
                [self.navigationController pushViewController:gprsVC animated:YES];
                return;
            }
            [HETCommonHelp showHudAutoHidenWithMessage:ScanQRCodeGetMessageFailed];
            [strongSelf.manager startRunning];
        }
    } failure:^(NSError *error) {
        STRONGSELF
        [HETCommonHelp hideHudFromView:strongSelf.view];
        [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf backAction];
        });
    }];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.9 * self.view.frame.size.height)];
    }
    return _scanningView;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.numberOfLines = 0;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = ScanQRCodeHelpInfo;
    }
    return _promptLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanningView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.scanningView.frame))];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bottomView;
}

#pragma mark - - - 闪光灯按钮
- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        // 添加闪光灯按钮
        _flashlightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat flashlightBtnW = 30;
        CGFloat flashlightBtnH = 30;
        CGFloat flashlightBtnX = 0.5 * (self.view.frame.size.width - flashlightBtnW);
        CGFloat flashlightBtnY = 0.55 * self.view.frame.size.height;
        _flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightOpenImage"] forState:(UIControlStateNormal)];
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightCloseImage"] forState:(UIControlStateSelected)];
        [_flashlightBtn addTarget:self action:@selector(flashlightBtn_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashlightBtn;
}

- (void)dealloc {
    OPLog(@"%@ dealloc！！！",[self class]);
    [self removeScanningView];
}
@end
