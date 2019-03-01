//
//  HETDeviceVC.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/8/29.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETDeviceListVC.h"

#import "PopoverView.h"
#import "UIScrollView+EmptyDataSet.h"

#import "HETUserVC.h"
#import "HETAddDeviceVC.h"
#import "LEDDeviceVC.h"
#import "HETBleControllerViewController.h"
#import "HETH5ContainBaseViewController.h"
#import "HETWiFiDeviceH5ViewController.h"
#import "HETBLEDeviceH5ViewController.h"
#import "HETNBIoTDeviceH5ViewController.h"
#import "HETZigbeeDeviceH5ViewController.h"
#import "HETShareDevcieVC.h"
#import "DeviceDetailsVC.h"

#import "HETDeviceListCell.h"
#import "HETLoginEmptyView.h"
#import "HETEmptyView.h"

#define cellH  72.0f

@interface HETDeviceListVC ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate>

///设备列表
@property (nonatomic,strong) UITableView *deviceListTableView;
///设备数组
@property (nonatomic,strong) NSMutableArray *deviceArr;
///是否已经登录
@property (nonatomic,assign,getter=isUserLogin) BOOL userlogin;
///提示下载H5资源进度 **/
@property (nonatomic,strong) MBProgressHUD *progressHud;
///未登录空白页
@property (nonatomic,strong) HETLoginEmptyView *loginEmptyView;
///无数据、网络失败、加载中空白页
@property (nonatomic,strong) HETEmptyView *emptyView;
///空白页的状态
@property (nonatomic,assign) HETEmptyViewState emptyState;
@end

@implementation HETDeviceListVC
@synthesize deviceArr = _deviceArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 2.设置导航栏
    [self createNavViews];
    
    // 3.初始化界面
    [self createSubView];
    
    // 4.获取设备
    if ([[HETAuthorize shareManager] isAuthenticated]){
        [self getDeviceList];
    }
    
    // 5.增加通知监听
    [self addNSNotification];
    
    self.deviceArr = [NSMutableArray array];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![[HETAuthorize shareManager] isAuthenticated]) {
        self.userlogin = NO;//没登录：显示提示站位图、文字
    }else{
        self.userlogin = YES;//已经登录：显示设备列表
    }
}

#pragma mark - Init
- (void)createNavViews
{
    // 1.中间标题
    self.navigationItem.title = DeviceListVCTitle;
    
    // 2.导航栏我的按妞
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"deviceListVC_nav_my"] style:UIBarButtonItemStylePlain target:self action:@selector(myInfoAction)];
    
    // 3.导航栏添加设备按钮
    UIBarButtonItem *addDevice = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"deviceListVC_nav_addDevcie"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemAction:)];
    self.navigationItem.rightBarButtonItems = @[addDevice];
}

- (void)createSubView
{
    // 1.设备列表
    [self.view addSubview:self.deviceListTableView];
    [self.deviceListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    // 2.进度条
    self.progressHud = [[MBProgressHUD alloc]initWithView:self.view];
    self.progressHud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    self.progressHud.label.text = DeviceH5ViewLoading;
    [self.view addSubview:self.progressHud];
}

- (void)addNSNotification{
    // 设备绑定通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeviceList) name:kBindDeviceSuccess object:nil];
    
    // accessToken失效  异地登陆
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenOutOfDate) name:HETLoginOffNotification object: nil];
}

#pragma mark - Request
- (void)clifeCloudAuth
{
    NSDictionary *params = @{@"account":@"18825219025"};
    WEAKSELF
    [HETDeviceRequestBusiness startRequestWithHTTPMethod:HETRequestMethodPost withRequestUrl:@"/v1/oauth2/create" processParams:params needSign:YES BlockWithSuccess:^(id responseObject) {
        STRONGSELF
        OPLog(@"云授权授权信息：%@",responseObject);
        NSDictionary *dict = [(NSDictionary *)responseObject objectForKey:@"data"];
        NSString *accessToken   =  [dict objectForKey:@"accessToken"];
        NSString *openId        =  [dict objectForKey:@"openId"];
        NSString * expiresIn    =  [dict objectForKey:@"expiresIn"];
        NSString *refreshToken  =  [dict objectForKey:@"refreshToken"];
        //[HETOpenSDK registerOpenId:openId accessToken:accessToken refreshToken:refreshToken expiresIn:expiresIn ];
        strongSelf.userlogin = YES;
        [strongSelf getDeviceList];
    } failure:^(NSError *error) {

    }];
}

- (void)getDeviceList
{
    self.emptyState = HETEmptyViewStateLoading;
    WEAKSELF
    [HETDeviceRequestBusiness fetchAllBindDeviceSuccess:^(NSArray<HETDevice *> *deviceArray) {
        STRONGSELF
        OPLog(@"responseObject ==%@",deviceArray);
        OPLog(@"[NSThread currentThread] = %@",[NSThread currentThread]);
        [strongSelf.deviceListTableView.mj_header endRefreshing];
        strongSelf.deviceArr = [deviceArray mutableCopy];
        strongSelf.emptyState = strongSelf.deviceArr.count ? HETEmptyViewStateUnknow :HETEmptyViewStateNoData;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.deviceListTableView reloadData];
        });
    } failure:^(NSError *error) {
        STRONGSELF
        [strongSelf.deviceListTableView.mj_header endRefreshing];
        OPLog(@"error ==%@",error);
        strongSelf.emptyState = HETEmptyViewStateError;
        [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deviceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HETDeviceListCell *cell = [HETDeviceListCell initWithTableView:tableView];
    
    HETDevice *devcie = self.deviceArr[indexPath.row];
    [cell refreshData:devcie];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.deviceArr.count > indexPath.row) {
        HETDevice *device = self.deviceArr[indexPath.row];
        [self PushToDeviceControlVC:device];
        return;
        //  LED原生控制器的写法
        //        if ([device.productId integerValue] == 63) {
        //            LEDDeviceVC *ledVc = [LEDDeviceVC new];
        //            ledVc.device = device;
        //            [self.navigationController pushViewController:ledVc animated:YES];
        //        }else
        //            //   蓝牙控制器原生的写法
        //            if([device.productId integerValue] == 2275){
        //                HETBleControllerViewController *ledVC = [HETBleControllerViewController new];
        //                ledVC.device = device;
        //                [self.navigationController pushViewController:ledVC animated:true];
        //            }
        //            else{// H5设备控制
        //                [self PushToDeviceControlVC:device];
        //            }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self unBindDeviceAction:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UnBindDeviceStr;
}

#pragma mark - MonitorDelegate
//- (void) MonitorshowHudWithMessage:(NSString *)message{
//    [HETCommonHelp showMessage:message toView:self.view];
//}
//
//- (void) MonitorshowHudAutoHidenWithMessage:(NSString *)message{
//    [HETCommonHelp showAutoDissmissWithMessage:message];
//}
//
//- (void) MonitorHideHud{
//    [HETCommonHelp HidHud];
//}

#pragma mark - DZNEmptyDataSetSource
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isUserLogin == NO) {
        // 必须懒加载
        return self.loginEmptyView;
    }
    else{
        self.emptyView.emptyState = self.emptyState;
        return self.emptyView;
    }
}

//是否显示空白页，默认YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return self.isUserLogin ? self.emptyState != HETEmptyViewStateError && self.emptyState != HETEmptyViewStateLoading: NO;
}

#pragma mark - Event response
- (void)PushToDeviceControlVC:(HETDevice *)deviceModel
{
    HETH5ContainBaseViewController *h5vc =  [self getH5ContainerController:deviceModel] ;
    if(h5vc == nil){ return; }
    
    h5vc.deviceModel=deviceModel;
    @weakify(h5vc)
    h5vc.onClickLeftButton = ^(NSUInteger index, NSString *title) {
        @strongify(h5vc)
        h5vc.deviceModel=deviceModel;
        [h5vc.navigationController popToViewController:self animated:YES];
    };
    h5vc.onClickRightButton = ^(NSUInteger index, NSString *title) {
        @strongify(h5vc);
        DeviceDetailsVC *detailVC = [DeviceDetailsVC new];
        detailVC.deviceModel = deviceModel;
        detailVC.scanDebug = ^(NSString *h5path) {
            h5vc.h5Path = h5path;
            [h5vc loadRequest];
        };
        [h5vc.navigationController pushViewController:detailVC animated:YES];
    };
    
//    NSString *document = [[NSBundle mainBundle]pathForResource:@"webdata" ofType:nil];
//
//    NSString *path1755 = [document stringByAppendingPathComponent:@"/1755/page/index.html"];
//    NSString *bundlePath =  [[NSBundle mainBundle]pathForResource:@"humidi" ofType:@"bundle"];
//    NSString *path1755 = [bundlePath stringByAppendingPathComponent:@"/page/index.html"];
    
    @weakify(self)
    [[HETH5Manager shareInstance] getH5Path:^(NSString *h5Path, BOOL needRefresh, NSString *h5ConfigLibVersion, NSError *error) {
        OPLog(@"needRefresh == %@,h5PagePath--->:%@",@(needRefresh),h5Path);
        @strongify(self)
        dispatch_after( dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_MSEC)  , dispatch_get_main_queue(), ^{
            [self.progressHud hideAnimated:true];
        });
        if(error){
            OPLog(@"获取H5失败");
            [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [h5vc.navigationController popViewControllerAnimated:YES];
            });
        }else{
            
            NSString *desPath  = [NSString stringWithFormat:@"%@/index.html",h5Path];
            h5vc.h5Path = desPath;
            if(needRefresh){
                [h5vc loadRequest];
            }else{
                [self.navigationController pushViewController:h5vc animated:YES];
            }
        }
    } downloadProgressBlock:^(NSProgress *progress) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressHud showAnimated:true];
            self.progressHud.progress = progress.fractionCompleted;
        });
    } productId:deviceModel.productId.stringValue];
}

- (HETH5ContainBaseViewController *)getH5ContainerController:(HETDevice *)deviceModel{
    HETH5ContainBaseViewController *h5vc ;
    if (deviceModel.bindType.integerValue == 2) {
        //标准3A蓝牙协议
        h5vc = [HETBLEDeviceH5ViewController new];
    }else if(deviceModel.bindType.integerValue == 4){//82
        if ([deviceModel.moduleId integerValue] == 44) {
            h5vc = [HETWiFiDeviceH5ViewController new];
            return h5vc;
        }
        //NB设备
        h5vc = [HETNBIoTDeviceH5ViewController new];
    }else if(deviceModel.bindType.integerValue == 1 || deviceModel.bindType.integerValue == 6){
        //标准5AWIFI协议，还有直连设备
        h5vc = [HETWiFiDeviceH5ViewController new];
    }else if(deviceModel.bindType.integerValue == 8){
        //ZigBee设备
        h5vc = [HETZigbeeDeviceH5ViewController new];
    }else{
        // 绑定类型(1-WiFi，2-蓝牙，3-音频，4-GSM，5-红外，6-直连--内置Android系统，7-插拔式设备，8-Zigbee)
        [HETCommonHelp showHudAutoHidenWithMessage:@"不能识别音频或红外或者插拔式模组类型，请查看产品详情"];
        OPLog(@"不能识别音频或红外或者插拔式模组类型，请查看产品详情");
    }
    return h5vc;
}

- (void)myInfoAction
{
    // 未授权就跳转登录 已授权则去我的界面
    if (![[HETAuthorize shareManager] isAuthenticated]) {
        [self loginAction];
    }
    else
    {
        [self.navigationController pushViewController:[HETUserVC new] animated:YES];
    }
}

- (void)toCloudAuth
{
    if ([[HETAuthorize shareManager] isAuthenticated]) {
        [[HETAuthorize shareManager] unauthorize];
    }
    UIStoryboard *hetCloudAuth =  [UIStoryboard storyboardWithName:@"HETCloudAuthStoryboard" bundle:nil];
    UIViewController *vc = [hetCloudAuth instantiateViewControllerWithIdentifier:@"HETCloudAuthViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addDeviceAction
{
    // 未授权就跳转登录 已授权则去添加设备界面
    if (![[HETAuthorize shareManager] isAuthenticated]) {
        [self loginAction];
    }
    else
    {
        [self.navigationController pushViewController:[HETAddDeviceVC new] animated:YES];
    }
}

- (void)loginAction
{
    [[HETAuthorize shareManager] authorizeWithCompleted:^(NSString *openId, NSError *error) {
        if(!error)
        {
            OPLog(@"openID:%@",openId);
            self.userlogin = YES;
            // 获取设备
            [self getDeviceList];
        }
        else
        {
            OPLog(@"error:%@",error);
            if (error.code == -1009) {
                [HETCommonHelp showHudAutoHidenWithMessage:@"请检查手机网络"];
            }else{
                [HETCommonHelp showHudAutoHidenWithMessage:AuthorizError];
            }
            self.userlogin = NO;
        }
    }];
}

- (void)addTableViewRefreshHeader
{
    WEAKSELF
    self.deviceListTableView.mj_header = [HETComRefreshHeader headerWithRefreshingBlock:^{
        STRONGSELF
        [strongSelf getDeviceList];
    }];
}

- (void)unBindDeviceAction:(NSIndexPath *)indexPath
{
    HETDevice *device = self.deviceArr[indexPath.row];
    //设备分享（1-是，2-否，3-扫描分享）
    if ([device.share integerValue] == 1) {
        WEAKSELF
        [HETDeviceShareBusiness deviceAuthDelWithDeviceId:device.deviceId userId:@"" success:^(id responseObject) {
            STRONGSELF
            [strongSelf unBindSuccess:indexPath];
        } failure:^(NSError *error) {
            STRONGSELF
            [strongSelf unBindError];
        }];
    }else{
        WEAKSELF
        [HETDeviceRequestBusiness unbindDeviceWithDeviceId:device.deviceId success:^(id responseObject) {
            STRONGSELF
            [strongSelf unBindSuccess:indexPath];
        } failure:^(NSError *error) {
            STRONGSELF
            [strongSelf unBindError];
        }];
    }
}

- (void)unBindSuccess:(NSIndexPath *)indexPath{
    // 删除数据源的数据,self.cellData是你自己的数据
    [self.deviceArr removeObjectAtIndex:indexPath.row];
    // 删除列表中数据
    [self.deviceListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self getDeviceList];
    [HETCommonHelp showHudAutoHidenWithMessage:UnBindDeviceSuccess];
}

- (void)unBindError{
    [HETCommonHelp showHudAutoHidenWithMessage:UnBindDeviceError];
    [self.deviceListTableView endEditing:YES];
}

- (void)accessTokenOutOfDate{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[HETAuthorize shareManager] unauthorize];
    [HETCommonHelp showHudAutoHidenWithMessage:AccessTokenOutDate];
    self.userlogin = NO;
}

- (void)exitLoginAction
{
    [[HETAuthorize shareManager] unauthorize];
    self.userlogin = NO;
}

- (void)leftBarItemAction:(UIBarButtonItem *)sender {
    PopoverAction *action1 = [PopoverAction actionWithImage:[UIImage imageNamed:@"contacts_add_newmessage"] title:AddDeviceVCTitle handler:^(PopoverAction *action) {
        [self addDeviceAction];
    }];
    PopoverAction *action2 = [PopoverAction actionWithImage:[UIImage imageNamed:@"contacts_add_friend"] title:CloudAuth handler:^(PopoverAction *action) {
        [self toCloudAuth];
    }];
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDefault;
    // 在没有系统控件的情况下调用可以使用显示在指定的点坐标的方法弹出菜单控件.
    [popoverView showToPoint:CGPointMake(ScreenWidth - 20 , 64 + IPX_STATUSBAROFFSETHEIGHT) withActions:@[action1, action2]];
}

#pragma mark - getters and setters
- (void)setUserlogin:(BOOL)userlogin
{
    _userlogin = userlogin;
    if (_userlogin == YES) {
        self.deviceListTableView.scrollEnabled = YES;
    }else{
        self.deviceListTableView.scrollEnabled = NO;
        [self.deviceArr removeAllObjects];
        [self.deviceListTableView reloadData];
    }
}

- (void)setEmptyState:(HETEmptyViewState)emptyState
{
    _emptyState = emptyState;
    self.emptyView.emptyState = self.emptyState;
    [self.deviceListTableView  reloadEmptyDataSet];
}

- (UITableView *)deviceListTableView
{
    if (!_deviceListTableView) {
        _deviceListTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _deviceListTableView.backgroundColor = [UIColor clearColor];
        _deviceListTableView.dataSource = self;
        _deviceListTableView.delegate = self;
        _deviceListTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _deviceListTableView.separatorColor = OPColor(@"e5e5e5");
        _deviceListTableView.emptyDataSetSource = self;
        _deviceListTableView.emptyDataSetDelegate = self;
        //去掉TableView中的默认横线
        _deviceListTableView.tableFooterView = [UIView new];
        
        [self addTableViewRefreshHeader];
    }
    return _deviceListTableView;
}

- (HETEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [HETEmptyView new];
        WEAKSELF
        _emptyView.netWorkErrorBlock = ^{
            STRONGSELF
            [strongSelf getDeviceList];
        };
    }
    return _emptyView;
}

- (HETLoginEmptyView *)loginEmptyView
{
    if (!_loginEmptyView) {
        _loginEmptyView = [HETLoginEmptyView new];
        WEAKSELF
        _loginEmptyView.loginBlock = ^{
            STRONGSELF
            [strongSelf loginAction];
        };
        
        _loginEmptyView.netWorkBlock = ^{
            STRONGSELF
            [strongSelf exitLoginAction];
        };
    }
    return _loginEmptyView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    OPLog(@"%@ dealloc！！！",[self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

