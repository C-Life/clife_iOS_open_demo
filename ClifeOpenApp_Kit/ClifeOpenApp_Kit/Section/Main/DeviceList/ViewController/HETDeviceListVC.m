//
//  HETDeviceVC.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/8/29.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETDeviceListVC.h"
#import "HETUserVC.h"
#import "HETAddDeviceVC.h"
#import "LEDDeviceVC.h"
#import "LEDBleDeviceVC.h"
#import "HETBleControllerViewController.h"
#import "DeviceCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "HETH5ViewController.h"

#define cellH  72.0f

@interface HETDeviceListVC ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UINavigationControllerDelegate>
/** 设备列表 **/
@property (nonatomic,strong) UITableView                                           *deviceListTableView;
/** 设备数组 **/
@property (nonatomic,strong) NSMutableArray                                        *deviceArr;
/** 授权登录manager **/
@property (nonatomic,strong) HETAuthorize                                          *auth;

/** 提示未登录图片 **/
@property (nonatomic,strong) UIImageView                                           *unLoginIcon;
/** 提示未登录文字 **/
@property (nonatomic,strong) UILabel                                               *unLoginLabel;
/** 登录按钮 **/
@property (nonatomic,strong) UIButton                                              *loginBtn;
/** 是否已经登录 **/
@property (nonatomic,assign) BOOL                                                  isLogin;
/** 是否展示空白页 **/
@property (nonatomic,assign) BOOL                                                  isShowEmpty;

@end

@implementation HETDeviceListVC

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
    if ([self.auth isAuthenticated]){
        [self getDeviceList];
    }

    // 5.增加通知监听
    [self addNSNotification];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 没登录：显示提示站位图、文字   已经登录：显示设备列表)
    if (![self.auth isAuthenticated]) {
        self.isLogin = NO;
    }else{
        self.isLogin = YES;
    }
}

- (void)createSubView
{
    // 1.设备列表
    [self.view addSubview:self.deviceListTableView];
    [self.deviceListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    // 2.未登录提示图片、文字，登录按钮
    // 未登录图片 距离 父视图顶部 的距离
    CGFloat unLoginIconMargin_top = (160 + 64) *BasicHeight;
    [self.view addSubview:self.unLoginIcon];
    [self.unLoginIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(unLoginIconMargin_top);
        make.width.equalTo(@(118/2));
        make.height.equalTo(@(118/2));
    }];

    [self.view addSubview:self.unLoginLabel];
    // 未登录文案 距离 未登录图片 底部 的距离
    CGFloat marginH_label = 18 *BasicHeight;
    [self.unLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.unLoginIcon.mas_bottom).offset(marginH_label);
    }];

    [self.view addSubview:self.loginBtn];
    // 未登录按钮 距离 未登录文案 底部 的距离
    CGFloat marginH_btn = 29 *BasicHeight;
    CGFloat loginBtnW = 120 *BasicWidth;
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.unLoginLabel.mas_bottom).offset(marginH_btn);
        make.width.equalTo(@(loginBtnW));
        make.height.equalTo(@(36*BasicHeight));
    }];

}


#pragma mark - BtnAction
- (void)exitLoginAction
{
    // 在授权登录成功的情况才执行操作
    if ([self.auth isAuthenticated]) {
        [self.auth unauthorize];
        if (![self.auth isAuthenticated])
        {
            self.isLogin = NO;
        }
    }
}

- (void)createNavViews
{
    // 1.中间标题
    self.navigationItem.title = DeviceListVCTitle;

    // 2.添加设备按妞
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_my"] style:UIBarButtonItemStylePlain target:self action:@selector(myInfoAction)];

    UIBarButtonItem *addDevice = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_addDevcie"] style:UIBarButtonItemStylePlain target:self action:@selector(addDeviceAction)];
    UIBarButtonItem *cloudAtuh = [[UIBarButtonItem alloc] initWithTitle:@"云授权" style:UIBarButtonItemStylePlain target:self action:@selector(toCloudAuth)];
    self.navigationItem.rightBarButtonItems = @[addDevice,cloudAtuh];

}

- (void)getDeviceList
{
    WEAKSELF
    [HETDeviceRequestBusiness fetchAllBindDeviceSuccess:^(NSArray<HETDevice *> *deviceArray) {
        OPLog(@"responseObject ==%@",deviceArray);
        OPLog(@"[NSThread currentThread] = %@",[NSThread currentThread]);
        weakSelf.deviceArr = [deviceArray mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.deviceListTableView reloadData];
        });
        [weakSelf.deviceListTableView.mj_header endRefreshing];

    } failure:^(NSError *error) {
        [weakSelf.deviceListTableView.mj_header endRefreshing];
        OPLog(@"error ==%@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:PuLLDownRefresh];
    }];
}

- (void)addNSNotification{
    // 设备绑定通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeviceList) name:kBindDeviceSuccess object:nil];

    // accessToken失效  异地登陆
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenOutOfDate) name:kNotificationLogin object: nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deviceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DeviceCell *cell = [DeviceCell initWithTableView:tableView];

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
        //    if ([device.productId integerValue] == 63) {
        //        LEDDeviceVC *ledVc = [LEDDeviceVC new];
        //        ledVc.device = device;
        //        [self.navigationController pushViewController:ledVc animated:YES];
        //    }else
        if([device.productId integerValue] == 2275){
            HETBleControllerViewController *ledVC = [HETBleControllerViewController new];
            ledVC.device = device;
            [self.navigationController pushViewController:ledVC animated:true];
        }
        else if([device.productId integerValue] == 1755 || [device.productId integerValue] == 1533 || [device.productId integerValue] == 63 )
        {
            [self PushTpH5Device:device];
        }
        else{
            //  [HETCommonHelp showHudAutoHidenWithMessage:DeviceControlViewOndevelopment];
            [self PushTpH5Device:device];
        }
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
//MARK:---------------MonitorDelegate-----#
- (void) MonitorshowHudWithMessage:(NSString *)message{
    [HETCommonHelp showMessage:message toView:self.view];
}

- (void) MonitorshowHudAutoHidenWithMessage:(NSString *)message{
    [HETCommonHelp showAutoDissmissWithMessage:message];
}

- (void) MonitorHideHud{
    [HETCommonHelp HidHud];
}

#pragma mark - H5设备
- (void)PushTpH5Device:(HETDevice *)deviceModel
{
    HETH5ViewController *h5vc = [[HETH5ViewController alloc]init];
    h5vc.deviceModel=deviceModel;


    WEAKSELF
    //[HETCommonHelp showCustomHudtitle:@"正在加载"];
    [[HETH5Manager shareInstance] getH5Path:^(NSString *h5Path,BOOL needRefresh,NSError *error) {
        OPLog(@"needRefresh == %@",@(needRefresh));
        OPLog(@"h5PagePath--->:%@",h5Path);
        // [HETCommonHelp HidHud];
        if(error){
            NSLog(@"获取H5失败");
        }else{
            NSString *desPath  = [NSString stringWithFormat:@"%@/index.html",h5Path];
            h5vc.h5Path = @"http://10.8.9.77:8080/index.html";
            if(needRefresh == YES){
                [h5vc.wkWebView reload];
            }else{
                [h5vc reload];
            }
        }

    } productId:deviceModel.productId.stringValue];
 h5vc.h5Path = @"http://10.8.9.77:8080/index.html";
    [weakSelf.navigationController pushViewController:h5vc animated:YES];
}

#pragma mark - DZNEmptyDataSetSource
//无数据占位
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"deviceListVC_noData"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -64 *BasicHeight;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 16 *BasicHeight;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = AddDevcieTipStr;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f],NSForegroundColorAttributeName: [UIColor colorFromHexRGB:@"b9b9b9"]};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//是否显示空白页，默认YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    // 如果有登录，设备数组为空，显示空白页
    if (self.isLogin) {
        return self.deviceArr.count >0? NO:YES;
    }else{
        return NO;
    }
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - BtnAction
- (void)myInfoAction
{
    // 未授权就跳转登录 已授权则去我的界面
    if (![self.auth isAuthenticated]) {
        [self loginAction];
    }
    else
    {
        [self.navigationController pushViewController:[HETUserVC new] animated:YES];
    }
}

- (void)toCloudAuth
{
    if ([self.auth isAuthenticated]) {
        [self.auth unauthorize];

        UIStoryboard *hetCloudAuth =  [UIStoryboard storyboardWithName:@"HETCloudAuthStoryboard" bundle:nil];
        UIViewController *vc = [hetCloudAuth instantiateViewControllerWithIdentifier:@"HETCloudAuthViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIStoryboard *hetCloudAuth =  [UIStoryboard storyboardWithName:@"HETCloudAuthStoryboard" bundle:nil];
        UIViewController *vc = [hetCloudAuth instantiateViewControllerWithIdentifier:@"HETCloudAuthViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)addDeviceAction
{
    // 未授权就跳转登录 已授权则去添加设备界面
    if (![self.auth isAuthenticated]) {
        [self loginAction];
    }
    else
    {
        [self.navigationController pushViewController:[HETAddDeviceVC new] animated:YES];
    }
}

- (void)loginAction
{
    [self.auth authorizeWithCompleted:^(NSString *openId, NSError *error) {
        if(!error)
        {
            OPLog(@"openID:%@",openId);
            self.isLogin = YES;
            // 获取设备
            [self getDeviceList];
        }
        else
        {
            OPLog(@"error:%@",error);
            [HETCommonHelp showHudAutoHidenWithMessage:AuthorizError];
            self.isLogin = NO;
        }
    }];
}

- (void)addTableViewRefreshHeader
{
    WEAKSELF
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf getDeviceList];
    }];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"XiaoC_loading@2x.gif" ofType:nil];
    UIImage *xiaoC_refresh = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:filePath]];
    [header setImages:xiaoC_refresh.images forState:MJRefreshStateIdle];
    [header setImages:xiaoC_refresh.images forState:MJRefreshStatePulling];
    [header setImages:xiaoC_refresh.images forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;

    self.deviceListTableView.mj_header = header;
}

- (void)unBindDeviceAction:(NSIndexPath *)indexPath
{
    HETDevice *device = self.deviceArr[indexPath.row];
    WEAKSELF
    //设备分享（1-是，2-否，3-扫描分享）
    if ([device.share integerValue] == 1) {
        [HETDeviceShareBusiness deviceAuthDelWithDeviceId:device.deviceId userId:@"" success:^(id responseObject) {
            // 删除数据源的数据,self.cellData是你自己的数据
            [weakSelf.deviceArr removeObjectAtIndex:indexPath.row];
            // 删除列表中数据
            [weakSelf.deviceListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

            [weakSelf getDeviceList];
            [HETCommonHelp showHudAutoHidenWithMessage:UnBindDeviceSuccess];
        } failure:^(NSError *error) {
            [HETCommonHelp showHudAutoHidenWithMessage:UnBindDeviceError];
            [weakSelf.deviceListTableView endEditing:YES];
        }];
    }else{
        [HETDeviceRequestBusiness unbindDeviceWithDeviceId:device.deviceId success:^(id responseObject) {
            // 删除数据源的数据,self.cellData是你自己的数据
            [weakSelf.deviceArr removeObjectAtIndex:indexPath.row];
            // 删除列表中数据
            [weakSelf.deviceListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

            [weakSelf getDeviceList];
            [HETCommonHelp showHudAutoHidenWithMessage:UnBindDeviceSuccess];
        } failure:^(NSError *error) {
            [HETCommonHelp showHudAutoHidenWithMessage:UnBindDeviceError];
            [weakSelf.deviceListTableView endEditing:YES];
        }];
    }
}

#pragma mark - 通知触发方法
- (void)accessTokenOutOfDate{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.auth unauthorize];
    [HETCommonHelp showHudAutoHidenWithMessage:AccessTokenOutDate];
    self.isLogin = NO;
}

#pragma mark - 懒加载
- (void)setIsLogin:(BOOL)isLogin
{
    _isLogin  = isLogin;
    if (isLogin) {
        self.deviceListTableView.hidden = NO;

        self.unLoginLabel.hidden = YES;
        self.unLoginIcon.hidden = YES;
        self.loginBtn.hidden = YES;

    }else{
        self.deviceListTableView.hidden = YES;
        [self.deviceArr removeAllObjects];

        self.unLoginLabel.hidden = NO;
        self.unLoginIcon.hidden = NO;
        self.loginBtn.hidden = NO;
    }
}

- (NSMutableArray *)deviceArr
{
    if (!_deviceArr) {
        _deviceArr = [NSMutableArray array];
    }
    return _deviceArr;
}

- (HETAuthorize *)auth
{
    if (!_auth) {
        _auth = [[HETAuthorize alloc]init];
    }
    return _auth;
}

- (UITableView *)deviceListTableView
{
    if (!_deviceListTableView) {
        _deviceListTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _deviceListTableView.backgroundColor = [UIColor clearColor];
        _deviceListTableView.dataSource = self;
        _deviceListTableView.delegate = self;
        _deviceListTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _deviceListTableView.separatorColor = [UIColor colorFromHexRGB:@"c6c6c6"];
        _deviceListTableView.emptyDataSetSource = self;
        _deviceListTableView.emptyDataSetDelegate = self;

        //去掉TableView中的默认横线
        _deviceListTableView.tableFooterView = [UIView new];

        [self addTableViewRefreshHeader];
    }
    return _deviceListTableView;
}

- (UIImageView *)unLoginIcon
{
    if (!_unLoginIcon) {
        _unLoginIcon = [UIImageView new];
        _unLoginIcon.image = [UIImage imageNamed:@"deviceListVC_unlogin"];
    }
    return _unLoginIcon;
}

- (UILabel *)unLoginLabel
{
    if (!_unLoginLabel) {
        _unLoginLabel = [UILabel new];
        _unLoginLabel.text = UnLoginLabelStr;
        _unLoginLabel.textColor = [UIColor colorFromHexRGB:@"b9b9b9"];
        _unLoginLabel.font = OPFont(17);
    }
    return _unLoginLabel;
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton new];
        [_loginBtn setTitle:LoginBtnTitle forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor colorFromHexRGB:@"3285ff"] forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor clearColor];
        _loginBtn.layer.borderColor = [UIColor colorFromHexRGB:@"3285ff"].CGColor;
        _loginBtn.layer.borderWidth = 0.5;
        _loginBtn.layer.cornerRadius = 5;
        _loginBtn.clipsToBounds = YES;
        _loginBtn.titleLabel.font = OPFont(16);
        [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
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

