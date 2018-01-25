//
//  HETScanQrcodeVC.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/9/1.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETScanQrcodeVC.h"
#import "HETSetPassWordVC.h"
#import "HETBindBleDeviceVC.h"
#import "HETH5ViewController.h"
#import "HETBindGPRSDeviceVC.h"
#import "QRView.h"

#import "ZBarSDK.h"

@interface HETScanQrcodeVC ()<ZBarReaderDelegate,ZBarReaderViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/** 顶部视图 **/
@property (nonatomic,strong) ZBarReaderView                                   *readview;
@property (nonatomic,strong) QRView                                           *qrRectView;
@property (nonatomic,strong) UIButton                                         *lightingBtn;
@property (nonatomic,strong) UIImagePickerController                          *picker;
@end

@implementation HETScanQrcodeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置背景颜色
    self.view.backgroundColor = VCBgColor;

    // 2.设置导航栏
    [self createNavViews];

    // 3.初始化界面
    [self createSubView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开始扫描
    [self setZBarReaderViewStart];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //停止扫描
    [self setZBarReaderViewStop];
}

- (void)createNavViews
{
    // 1.导航栏标题
    self.navigationItem.title = ScanQRCodeTitle;

    // 2.添加返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];

    // 3.相册
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(presentImagePickerController)];
}

- (void)createSubView
{
    //初始化照相机窗口
    self.readview = [[ZBarReaderView alloc] init];
    //设置扫描代理
    self.readview.readerDelegate = self;
    //关闭闪光灯
    self.readview.torchMode = 0;
    //显示帧率 YES:显示  NO:不显示 (这里有bug)
    self.readview.showsFPS = NO;
    //将其照相机拍摄视图添加到要显示的视图上
    [self.view addSubview:self.readview];
    //二维码/条形码识别设置
    ZBarImageScanner *scanner = _readview.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    //Layout ZBarReaderView
    [self.readview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    //扫描的矩形方框视图
    _qrRectView = [[QRView alloc] init];
    _qrRectView.transparentArea = CGSizeMake(220, 220);
    _qrRectView.backgroundColor = [UIColor clearColor];
    [_readview addSubview:_qrRectView];
    [_qrRectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_readview).with.offset(0);
        make.left.equalTo(_readview).with.offset(0);
        make.right.equalTo(_readview).with.offset(0);
        make.bottom.equalTo(_readview).with.offset(0);
    }];

    UILabel *labIntroudction= [[ UILabel alloc ] init ];
    labIntroudction. backgroundColor = [ UIColor clearColor ];
    labIntroudction. frame = CGRectMake ( 0 , ScreenHeight/2+80 , ScreenWidth , 20 );
    labIntroudction. numberOfLines = 1 ;
    labIntroudction. font =[ UIFont systemFontOfSize : 15.0 ];
    labIntroudction. textAlignment = NSTextAlignmentCenter ;
    labIntroudction. textColor =[ UIColor whiteColor ];
    labIntroudction. text = ScanQRCodeHelpInfo ;
    [self.readview addSubview :labIntroudction];

    //照明按钮
    _lightingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_lightingBtn setTitle:ScanQRCodeLightOn forState:UIControlStateNormal];
    [_lightingBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    _lightingBtn.layer.borderColor = [UIColor colorFromHexRGB:@"3498db"].CGColor;
    _lightingBtn.layer.borderWidth = 1.0;
    _lightingBtn.layer.cornerRadius = 8.0;
    _lightingBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_lightingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_lightingBtn setBackgroundColor:[UIColor clearColor]];
    [_lightingBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_qrRectView addSubview:_lightingBtn];
    [_lightingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_qrRectView).with.offset(-100);
        make.centerX.equalTo(_qrRectView);
        make.size.mas_equalTo(CGSizeMake(88, 28));
    }];
}

- (void)buttonClicked:(UIButton *)sender{
    if(0 != _readview.torchMode){
        //关闭闪光灯
        _readview.torchMode = 0;
    }else if (0 == _readview.torchMode){
        //打开闪光灯
        _readview.torchMode = 1;
    }
}

/**
 * 打开二维码扫描视图ZBarReaderView
 * 打开闪光灯
 */
- (void)setZBarReaderViewStart{
    _readview.torchMode = 0;//关闭闪光灯
    [_readview start];//开始扫描二维码
    [_qrRectView startScan];
}

/**
 * 关闭二维码扫描视图ZBarReaderView
 * 关闭闪光灯
 */
- (void)setZBarReaderViewStop{
    _readview.torchMode = 0;//关闭闪光灯
    [_readview stop];//关闭扫描二维码
    [_qrRectView stopScan];
}

#pragma mark -
#pragma mark ZBarReaderViewDelegate
//扫描二维码的时候，识别成功会进入此方法，读取二维码内容
- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image{
    //停止扫描
    [self setZBarReaderViewStop];

    ZBarSymbol *symbol = nil;
    for (symbol in symbols) {
        break;
    }
    NSString *urlStr = symbol.data;

    if(urlStr==nil || urlStr.length<=0){
        //二维码内容解析失败
        [self scanError];
        return;
    }
    OPLog(@"urlStr: %@",urlStr);
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
            [self setZBarReaderViewStart];
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
        OPLog(@"responseObject == %@",responseObject);
        [HETCommonHelp showHudAutoHidenWithMessage:GetDeviceControlAuthSuccess];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBindDeviceSuccess object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        OPLog(@"error == %@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf backAction];
        });
        [weakSelf setZBarReaderViewStart];
    }];
}

- (void)scanError
{
    //二维码内容解析失败
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:ScanQRCodeFailed message:ScanQRCodeFailedAlertMessage preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self) weakSelf = self;
    UIAlertAction *action = [UIAlertAction actionWithTitle:CommonSure style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //重新扫描
        [weakSelf setZBarReaderViewStart];
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
            // 根据moduleType 区分设备绑定类型
            HETDevice *device = [HETDevice mj_objectWithKeyValues:dataDict];
            // wifi绑定
            if ([device.moduleType integerValue] == 1 || [device.moduleType integerValue] == 9) {
                HETSetPassWordVC *setPasswordVC =  [HETSetPassWordVC new];
                setPasswordVC.device = device;
                [strongSelf.navigationController pushViewController:setPasswordVC animated:YES];
                return ;
            }
            // 蓝牙绑定
            if ([device.moduleType integerValue] == 2) {
                HETBindBleDeviceVC *bindBleDeviceVC = [HETBindBleDeviceVC new];
                bindBleDeviceVC.device = device;
                [strongSelf.navigationController pushViewController:bindBleDeviceVC animated:YES];
                return ;
            }
            [HETCommonHelp showHudAutoHidenWithMessage:ScanQRCodeGetMessageFailed];
            [strongSelf setZBarReaderViewStart];
        }
    } failure:^(NSError *error) {
        [HETCommonHelp hideHudFromView:weakSelf.view];
        // msg=appId与产品未做关联
        if (error.code == 100022013) {
            [HETCommonHelp showHudAutoHidenWithMessage:ScanQRCodeGetMessageFailed];
        }else{
            [HETCommonHelp showHudAutoHidenWithMessage:ScanQRCodeGetMessageFailed];
            [weakSelf setZBarReaderViewStart];
        }
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
        NSString *imeiStr = [NSString stringWithFormat:@"%@",imei];
        NSString *macStr = [NSString stringWithFormat:@"%@",mac];
        HETBindGPRSDeviceVC *gprsVC = [HETBindGPRSDeviceVC new];
        gprsVC.mac = macStr;
        gprsVC.imei = imeiStr;
        gprsVC.productId = [NSString stringWithFormat:@"%@",productId];
        [self.navigationController pushViewController:gprsVC animated:YES];
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
            // 根据moduleType 区分设备绑定类型
            HETDevice *device = [HETDevice mj_objectWithKeyValues:dataDict];
            // wifi绑定
            if ([device.moduleType integerValue] == 1 || [device.moduleType integerValue] == 9) {
                HETSetPassWordVC *setPasswordVC =  [HETSetPassWordVC new];
                setPasswordVC.device = device;
                [strongSelf.navigationController pushViewController:setPasswordVC animated:YES];
                return ;
            }
            // 蓝牙绑定
            if ([device.moduleType integerValue] == 2) {
                HETBindBleDeviceVC *bindBleDeviceVC = [HETBindBleDeviceVC new];
                bindBleDeviceVC.device = device;
                [strongSelf.navigationController pushViewController:bindBleDeviceVC animated:YES];
                return ;
            }
            [HETCommonHelp showHudAutoHidenWithMessage:ScanQRCodeGetMessageFailed];
            [strongSelf setZBarReaderViewStart];
        }
    } failure:^(NSError *error) {
        STRONGSELF
        [HETCommonHelp hideHudFromView:strongSelf.view];
        // msg=appId与产品未做关联
        if (error.code == 100022013) {
            [strongSelf scanError];
        }else{
            [HETCommonHelp showHudAutoHidenWithMessage:ScanQRCodeGetMessageFailed];
            [strongSelf setZBarReaderViewStart];
        }
    }];
}

#pragma mark-========UIImagePickerControllerDelegate===============
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //停止扫描
    [self setZBarReaderViewStop];

    //处理选中的相片,获得二维码里面的内容
    ZBarReaderController *reader = [[ZBarReaderController alloc] init];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGImageRef cgimage = image.CGImage;
    ZBarSymbol *symbol = nil;
    for(symbol in [reader scanImage:cgimage])
        break;
    NSString *urlStr = symbol.data;

    [self dismissViewControllerAnimated:YES completion:nil];

    if(urlStr==nil || urlStr.length<=0){
        //二维码内容解析失败
        [self scanError];
        return;
    }

    OPLog(@"urlStr: %@",urlStr);
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
    else if ([urlStr rangeOfString:@"shareCode ="].length > 0) {
        [self scanShareCode:urlStr];
    }
    // 扫描条形码获取设备信息
    else if ([self isDigital:urlStr]){
        [self getDeviceInfoWithUrlStr:urlStr];
    }
    // 扫描H5调试地址
    else if ([urlStr rangeOfString:@"getPreviceUrl"].length > 0) {
        if (self.h5PathBlock)
        {
            self.h5PathBlock(urlStr);
            [HETCommonHelp showAutoDissmissWithMessage:@"获取到新的H5调试地址!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else{
            [self setZBarReaderViewStart];
        }
    }
    // 扫描失败
    else{
        [self scanError];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //收起相册
    [self dismissViewControllerAnimated:YES completion:nil];
}

//弹出系统相册、相机
-(void)presentImagePickerController{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker = [[UIImagePickerController alloc] init];
    _picker.sourceType               = sourceType;
    _picker.allowsEditing            = YES;
    _picker.delegate                 = self;
    [self presentViewController:_picker animated:YES completion:^{
    }];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    OPLog(@"%@ dealloc！！！",[self class]);
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

