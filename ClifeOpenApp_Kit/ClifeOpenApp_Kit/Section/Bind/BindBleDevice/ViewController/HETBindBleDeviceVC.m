//
//  HETBindBleDeviceVC.m
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/9/18.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETBindBleDeviceVC.h"
#import "HETSearchBindAnimationView.h"
#import "BleTableViewCell.h"

@interface HETBindBleDeviceVC ()<UITableViewDelegate,UITableViewDataSource>
/** 扫描到的蓝牙设备列表 **/
@property(nonatomic,strong) UITableView                 *tableView;
/** 扫描到的蓝牙设备数组 **/
@property(nonatomic,strong) NSMutableArray              *deviceArr;
/** 蓝牙绑定、扫描控制类 **/
@property(nonatomic,strong) HETBLEBusiness              *bleBusiness;
/** 搜索动画、绑定动画 **/
@property(nonatomic,strong) HETSearchBindAnimationView  *bindAnimationView;
/** 更新搜索设备进度定时器 **/
@property(nonatomic,strong) NSTimer                     *timer;
/** 搜索设备进度 **/
@property(nonatomic,assign) int                         progress;
/** 是否搜索到设备 **/
@property(nonatomic,assign) BOOL                        scanDevice;


@end

@implementation HETBindBleDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置背景颜色
    self.view.backgroundColor = VCBgColor;

    // 2.设置导航栏
    [self createNavViews];

    // 3.初始化界面
    [self createSubView];

    // 4.初始化蓝牙通讯类
    [self setUpBleBusiness];

    // 5.搜索设备
    [self searchDevice];
    self.deviceArr = [NSMutableArray array];

    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];

    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (self.timer) {
        [self.timer invalidate];
    }

    [self.bleBusiness stopScanForPeripherals];
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

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BleTableViewCell *cell = [BleTableViewCell initWithTableView:tableView];
    CBPeripheral *cbp = (CBPeripheral *)[self.deviceArr objectAtIndex:indexPath.row];
    [cell refreshData:cbp productIcon:self.device.productName productName:self.device.productName];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 148/2;
}

#pragma mark - UITableViewDelegate (选中设备绑定)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *cbp = (CBPeripheral *)[self.deviceArr objectAtIndex:indexPath.row];
    [UIView animateWithDuration:1.0 animations:^{
        self.bindAnimationView.productName = cbp.name;
        self.bindAnimationView.productCode = [NSString stringWithFormat:@"%@",self.device.productCode];
        [self.bindAnimationView startBinding];
    } completion:^(BOOL finished) {
        self.bindAnimationView.hidden = NO;
        self.tableView.hidden = YES;
    }];

    if (cbp.state!=CBPeripheralStateConnected)
    {
        __weak typeof(self) weakself = self;
        [self.bleBusiness bindBleDeviceWithPeripheral:cbp macAddress:nil completionHandler:^(NSString *deviceId, NSError *error) {

            [weakself.bleBusiness disconnectWithPeripheral:cbp];
            if(error)
            {
                [HETCommonHelp showHudAutoHidenWithMessage:BindBleBindFaile];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popViewControllerAnimated:YES];
                });
            }
            else
            {
                [weakself.bindAnimationView startBindsuccess];
                [[NSNotificationCenter defaultCenter] postNotificationName:kBindDeviceSuccess object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        }];
    }
}

- (void)setUpBleBusiness
{
    //初始化蓝牙设备的业务类，需要设备的productId，deviceTypeId，deviceSubtypeId
    self.bleBusiness=[[HETBLEBusiness alloc]initWithProductId:self.device.productId.integerValue deviceTypeId:self.device.deviceTypeId.integerValue deviceSubtypeId:self.device.deviceSubtypeId.integerValue];
}

#pragma mark -  搜索蓝牙设备
- (void)searchDevice
{
    // 这里的start 只是显示进度的动画层
    [self.bindAnimationView startSearchProgressing];

    // 扫描蓝牙设备超时时间
    CGFloat timeOut = 5.0f;

    // 更新进度的频率
    CGFloat inerval = 0.06f;

    if (self.timer) {
        [self.timer invalidate];
    }

    self.timer = [NSTimer scheduledTimerWithTimeInterval:inerval target:self selector:@selector(updataProgress) userInfo:nil repeats:YES];

    self.scanDevice = NO;

    WEAKSELF
    [self.bleBusiness scanForPeripheralsWithTimeOut:timeOut name:nil mac:nil scanForPeripheralsBlock:^(NSArray<CBPeripheral *> *peripherals, NSError *error) {
        OPLog(@"error = %@",error);
        if (error) {
            weakSelf.scanDevice = NO;
            [weakSelf scanDeviceFail];
            return ;
        }
        if (peripherals) {
            weakSelf.scanDevice = YES;
            OPLog(@"peripherals = %@",peripherals);
            OPLog(@"[NSThread currentThread] = %@",[NSThread currentThread]);
            [peripherals enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CBPeripheral *dev = (CBPeripheral*)obj;
                if (![weakSelf.deviceArr containsObject:dev]) {
                    [weakSelf.deviceArr addObject:dev];
                }
                [UIView animateWithDuration:1.0 animations:^{
                    [weakSelf.bindAnimationView stopSearchProgressing];
                    weakSelf.bindAnimationView.hidden = YES;
                } completion:^(BOOL finished) {
                    [weakSelf.tableView reloadData];
                    weakSelf.tableView.hidden = NO;
                }];
            }];
            return;
        }
    }];
}

- (void)checkBleState
{
    // 一次获取当前手机蓝牙状态
    CBManagerState state = [self.bleBusiness currentStateOfCBCentermanager];
    if (state == CBManagerStatePoweredOff) {
        [self.bleBusiness  stopScanForPeripherals];
        [self bleUnOnWorkTip];
    }

    if (state == CBManagerStatePoweredOn) {
        self.progress = 0;
        self.bindAnimationView.progressStr = [NSString stringWithFormat:@"%d",self.progress];
        [self searchDevice];
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
        [self searchDevice];
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

// 蓝牙未开启
- (void)bleUnOnWorkTip
{
    [self.bindAnimationView stopSearchProgressing];

    if (self.timer) {
        [self.timer invalidate];
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:BLEOpenAlert message:@"" preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:CommonSet style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:CommonOK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.progress = 0;
        self.bindAnimationView.progressStr = [NSString stringWithFormat:@"%d",self.progress];
        [self searchDevice];
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark -应用进入前台
- (void)appDidEnterPlayground
{
    if (self.scanDevice == NO) {
        [self checkBleState];
    }
}

- (void)appDidEnterBackground
{
    if (self.scanDevice == NO) {
        if (self.timer) {
            [self.timer invalidate];
        }
        [self.bindAnimationView stopSearchProgressing];
    }
}

#pragma mark - 更新扫描进度
-(void)updataProgress
{
    self.progress++;

    if (self.progress <= 100) {
        self.bindAnimationView.progressStr = [NSString stringWithFormat:@"%d",self.progress];
    }else{
        [self.bindAnimationView stopSearchProgressing];
        if (self.timer) {
            [self.timer invalidate];
        }
    }
}

#pragma mark - 懒加载
-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor= self.view.backgroundColor;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = [UIColor colorFromHexRGB:@"c6c6c6"];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.hidden = YES;
    }
    return _tableView;
}

#pragma mark - 返回事件
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
