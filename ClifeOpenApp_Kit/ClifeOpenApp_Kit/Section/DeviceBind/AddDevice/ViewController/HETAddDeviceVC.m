//
//  HETAddDeviceVC.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/8/31.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETAddDeviceVC.h"
#import "HETBindInstructionVC.h"
#import "HETSetPassWordVC.h"
#import "HETDeviceSubTypeListVC.h"
#import "HETSQRCodeScanningVC.h"

#import "HETAddDevcieCell.h"
#import "HETAddDeviceTopView.h"
#import <AVFoundation/AVFoundation.h>
#define cellH 48.0f

@interface HETAddDeviceVC ()<UITableViewDataSource,UITableViewDelegate>

///顶部视图
@property (nonatomic,strong) HETAddDeviceTopView *topView;
///大类设备列表
@property (nonatomic,strong) UITableView *deviceListTableView;
///设备数组
@property (nonatomic,strong) NSMutableArray *deviceArr;
///小类设备数组
@property (nonatomic,strong) NSMutableArray *subTypeDeviceArr;

@end

@implementation HETAddDeviceVC

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 2.设置导航栏
    [self createNavViews];
    
    // 3.初始化界面
    [self createSubView];
    
    // 4.查询设备大类
    [self fetchDeviceTypeList];
    
    // 5.添加事件处理
    [self addAction];
}

#pragma mark - Init
- (void)createNavViews
{
    // 1.导航栏标题
    self.navigationItem.title = AddDeviceVCTitle;
    
    // 2.添加返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    // 3.求解按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bindHelp"] style:UIBarButtonItemStylePlain target:self action:@selector(bindInstructionsAction)];
}

- (void)createSubView
{
    [self.view addSubview:self.topView];
    // 顶部视图 距离 父视图顶部 的距离
    CGFloat topViewMargin_top = 64;
    // 顶部视图的高度
    CGFloat topViewH = 208 *BasicHeight;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(topViewH));
        make.top.equalTo(self.view).offset(topViewMargin_top);
    }];
    
    [self.view addSubview:self.deviceListTableView];
    [self.deviceListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

#pragma mark - Request
- (void)fetchDeviceTypeList
{
    WEAKSELF
    [HETDeviceRequestBusiness fetchDeviceTypeListSuccess:^(id responseObject) {
        STRONGSELF
        OPLog(@"responseObject = %@",responseObject);
        OPLog(@"[NSThread currentThread] = %@",[NSThread currentThread]);
        if ([[responseObject allKeys] containsObject:@"data"]) {
            strongSelf.deviceArr = [responseObject valueForKey:@"data"];
            [strongSelf.deviceListTableView reloadData];
        }
        [weakSelf.deviceListTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        STRONGSELF
        OPLog(@"error = %@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:PuLLDownRefresh];
        [strongSelf.deviceListTableView.mj_header endRefreshing];
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
    
    HETAddDevcieCell *cell =  [HETAddDevcieCell initWithTableView:tableView];
    NSDictionary  *deviceDict = self.deviceArr[indexPath.row];
    [cell refreshMainType:deviceDict];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *device = self.deviceArr[indexPath.row];
    OPLog(@"device.deviceTypeId = %@" ,[device valueForKey:@"deviceTypeId"]);
    
    HETDeviceSubTypeListVC *subTypeListVC = [HETDeviceSubTypeListVC new];
    subTypeListVC.deviceTypeId = [device valueForKey:@"deviceTypeId"];
    [self.navigationController pushViewController:subTypeListVC animated:YES];
}

#pragma mark - Event response
- (void)bindInstructionsAction
{
    // 常见问题界面
    HETBindInstructionVC *vc = [[HETBindInstructionVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addAction{
    WEAKSELF
    self.topView.selectIndex = ^(NSInteger index) {
        switch (index) {
            case 0:
            {
                //判断是否有相机权限
                //读取媒体类型
                NSString *mediaType = AVMediaTypeVideo;
                //读取设备授权状态
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                    //        NSString *errorStr = @"应用相机权限受限,请在iPhone的“设置-隐私-相机”选项中，允许好享玩访问你的相机。";
                    //        [HETCommonHelp showAutoDissmissWithMessage:errorStr];
                    
                    //无权限 做一个友好的提示
                    UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相机->设置->隐私->相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]; [alart show];
                    return ;
                }else{
                    [weakSelf.navigationController pushViewController:[HETSQRCodeScanningVC new] animated:YES];
                }
            }
                
                break;
            case 1:
                break;
            default:
                break;
        }
    };
    
    [self addTableViewRefreshHeader];
}

- (void)addTableViewRefreshHeader
{
    WEAKSELF
    self.deviceListTableView.mj_header = [HETComRefreshHeader headerWithRefreshingBlock:^{
        STRONGSELF
        [strongSelf fetchDeviceTypeList];
    }];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getters and setters
- (HETAddDeviceTopView *)topView
{
    if (!_topView) {
        _topView = [HETAddDeviceTopView new];
        _topView.backgroundColor = OPColor(@"efeff4");
        _topView.imageArr =  [@[@"addVC_scanDevice"]mutableCopy];
    }
    return _topView;
}

- (UITableView *)deviceListTableView
{
    if (!_deviceListTableView) {
        _deviceListTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _deviceListTableView.backgroundColor = [UIColor whiteColor];
        _deviceListTableView.dataSource = self;
        _deviceListTableView.delegate = self;
        
        //去掉TableView中的默认横线
        _deviceListTableView.tableFooterView = [UIView new];
        _deviceListTableView.separatorInset = UIEdgeInsetsMake(0,0,0,0);
        _deviceListTableView.separatorColor = OPColor(@"e5e5e5");
    }
    return _deviceListTableView;
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
