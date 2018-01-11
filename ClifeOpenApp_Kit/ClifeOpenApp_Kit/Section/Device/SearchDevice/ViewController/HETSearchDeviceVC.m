//
//  HETSearchDeviceVC.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/9/2.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETSearchDeviceVC.h"
#import "HETSearchBindAnimationView.h"

typedef NS_ENUM(NSInteger, HETOPDeviceBindType) {
    HETOPWIFIDeviceBindType=1,//WiFi绑定类型
    HETOPBLEDeviceBindType=2,//蓝牙绑定类型
    HETOPAPDeviceBindType=3,//AP绑定类型
    HETOPNormalDeviceBindType=4 // 大类+小类绑定类型
};


@interface HETSearchDeviceVC ()
/** 搜索动画、绑定动画 **/
@property(nonatomic,strong) HETSearchBindAnimationView  *bindAnimationView;
/** 更新搜索设备进度定时器 **/
@property(nonatomic,strong) NSTimer                     *timer;
/** 搜索设备进度 **/
@property(nonatomic,assign) int                         progress;

@end

@implementation HETSearchDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置背景颜色
    self.view.backgroundColor = VCBgColor;

    // 2.设置导航栏
    [self createNavViews];

    // 3.初始化界面
    [self createSubView];

    // 4.搜索设备
    [self searchDevice];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (self.timer) {
        [self.timer invalidate];
    }

    [[HETWIFIBindBusiness sharedInstance] stop];
}

- (void)createNavViews
{
    // 1.导航栏标题
    self.navigationItem.title = AddDeviceVCTitle;

    // 2.添加返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];

//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)createSubView
{
    self.bindAnimationView = [[HETSearchBindAnimationView alloc]init];
    [self.view addSubview:self.bindAnimationView];
    [self.bindAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)searchDevice
{
    WEAKSELF
    CGFloat timeOut;
    if (self.bindType == 2) {
        timeOut = 4.8355f;
    }else{
        timeOut = 100.0f;
    }

    CGFloat inerval = 0.045f;
    if (self.bindType == 2) {
        inerval = 0.045f;
    }else{
        inerval = 1.0f;
    }

    if (self.timer) {
        [self.timer invalidate];
    }

    self.timer = [NSTimer scheduledTimerWithTimeInterval:inerval target:self selector:@selector(updataProgress) userInfo:nil repeats:YES];

    [[HETWIFIBindBusiness sharedInstance] startSmartLinkBindDeviceWithProductId:self.productId withSSID:self.ssid withPassWord:self.password withTimeOut:timeOut bindHandler:^(HETWiFiDeviceBindState state, HETDevice *deviceObj, NSError *error) {
        OPLog(@"HETWiFiDeviceBindState: %ld", state);
        // 扫描失败
        if (error) {
            // 异地登录
            NSInteger code = [[error.userInfo valueForKey:@"code"] integerValue];
            if (code == 100021006 || code == 100010102) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLogin object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                return ;
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf scanDeviceFail];
                });
                return;
            }
        }

        [weakSelf doSomeThingWithState:state deviceObj:deviceObj];
    }];
}

- (void)doSomeThingWithState:(HETWiFiDeviceBindState)state deviceObj:(HETDevice *)deviceObj
{
    OPLog(@"state = %ld",state);
    OPLog(@"deviceObj = %@",deviceObj);
    OPLog(@"[NSThread currentThread] = %@",[NSThread currentThread]);
    switch (state) {
            // 搜索设备
        case HETWiFiDeviceScaning:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.bindAnimationView startSearchProgressing];
            });
        }
            break;
            // 绑定设备
        case HETWiFiDeviceBinding:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (deviceObj) {
                    self.bindAnimationView.productName = deviceObj.productName;
                    self.bindAnimationView.productCode = deviceObj.productCode;

                }else{
                    self.bindAnimationView.productName = @"";
                    self.bindAnimationView.productCode = @"";
                }

                if (self.timer) {
                    [self.timer invalidate];
                }
                [self.bindAnimationView stopSearchProgressing];
                [self.bindAnimationView startBinding];
            });
        }
            break;
            // 绑定成功
        case HETWiFiDeviceBindSuccess:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.bindAnimationView startBindsuccess];
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出绑定" style:UIBarButtonItemStylePlain target:self action:@selector(exitBind)];
                [[NSNotificationCenter defaultCenter] postNotificationName:BindDeviceSuccess object:nil];
            });
        }
            break;
            // 绑定失败
        case HETWiFiDeviceBindFail:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self scanDeviceFail];
            });
        }
            break;
        default:
            break;
    }
}

/*
 * 扫描失败流程
 */
- (void)scanDeviceFail
{
    [self.bindAnimationView stopSearchProgressing];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:SearchDeviceErrorTitle message:SearchDeviceErrorMessage preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:ExitBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         [self.navigationController popViewControllerAnimated:YES];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:SearchAgainTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.progress = 0;
        [self updataProgress];
        [self searchDevice];
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 更新扫描进度
-(void)updataProgress
{
    self.progress++;

    if (self.progress <= 100) {
        self.bindAnimationView.progressStr = [NSString stringWithFormat:@"%d",_progress];
    }else{
        [self.bindAnimationView stopSearchProgressing];
        if (self.timer) {
            [self.timer invalidate];
        }
    }
}

#pragma mark - 返回事件
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 退出绑定
- (void)exitBind
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
