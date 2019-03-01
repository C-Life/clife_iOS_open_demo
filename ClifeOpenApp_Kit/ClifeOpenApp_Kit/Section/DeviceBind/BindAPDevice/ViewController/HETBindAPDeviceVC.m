//
//  HETBindAPDeviceVC.m
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/9/20.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETBindAPDeviceVC.h"
#import "HETSearchBindAnimationView.h"

@interface HETBindAPDeviceVC ()
/** 搜索动画、绑定动画 **/
@property(nonatomic,strong) HETSearchBindAnimationView  *bindAnimationView;
/** 更新搜索设备进度定时器 **/
@property(nonatomic,strong) NSTimer                     *timer;
/** 搜索设备进度 **/
@property(nonatomic,assign) int                         progress;

@end

@implementation HETBindAPDeviceVC

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
    CGFloat timeOut = 100.0f;

    CGFloat inerval = 1.0f;

    if (self.timer) {
        [self.timer invalidate];
    }

    self.timer = [NSTimer scheduledTimerWithTimeInterval:inerval target:self selector:@selector(updataProgress) userInfo:nil repeats:YES];

    [[HETWIFIBindBusiness sharedInstance] startAPBindDeviceWithProductId:[NSString stringWithFormat:@"%@",self.device.productId] withDeviceTypeId:[NSString stringWithFormat:@"%@",self.device.deviceTypeId] withDeviceSubtypeId:[NSString stringWithFormat:@"%@",self.device.deviceSubtypeId]  withSSID:self.ssid withPassWord:self.password withTimeOut:timeOut bindHandler:^(HETWiFiDeviceBindState state, HETDevice *deviceObj, NSError *error) {
        OPLog(@"HETWiFiDeviceBindState: %ld", state);
        // 扫描失败
        if (error) {

            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf scanDeviceFail];
            });
            return;
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
                if (deviceObj.productCode.length >0 && deviceObj.productName >0) {
                    self.bindAnimationView.productName = deviceObj.productName;
                    self.bindAnimationView.productCode = deviceObj.productCode;

                }else{
                    self.bindAnimationView.productName = self.device.productName;
                    self.bindAnimationView.productCode = [NSString stringWithFormat:@"%@",self.device.productCode];
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
                [[NSNotificationCenter defaultCenter] postNotificationName:kBindDeviceSuccess object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:true];
                });
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
