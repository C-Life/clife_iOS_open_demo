//
//  HETDeviceSubTypeListVC.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/9/13.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETDeviceSubTypeListVC.h"
#import "DeviceSubTypeCell.h"
#import "HETSetPassWordVC.h"
#import "HETBindBleDeviceVC.h"
#import "HETDeviceListVC.h"

#define cellH  72.0f

@interface HETDeviceSubTypeListVC ()<UITableViewDataSource,UITableViewDelegate>
/** 睡眠带子 **/

/** 设备列表 **/
@property (nonatomic,strong) UITableView                                           *deviceListTableView;
/** 设备数组 **/
@property (nonatomic,strong) NSMutableArray                                        *subTypeDeviceArr;
@end

@implementation HETDeviceSubTypeListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置背景颜色
    self.view.backgroundColor = VCBgColor;

    // 2.设置导航栏
    [self createNavViews];

    // 3.初始化界面
    [self createSubView];

    // 4.获取设备
    [self fetchDeviceSubtypeList:self.deviceTypeId];
}

- (void)createNavViews
{
    // 1.导航栏标题
    self.navigationItem.title = DeviceListTitle;

    // 2.添加返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

- (void)createSubView
{
    // 1.设备列表
    [self.view addSubview:self.deviceListTableView];
    [self.deviceListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)fetchDeviceSubtypeList:(NSNumber *)deviceTypeId
{
    WEAKSELF
    [HETDeviceRequestBusiness fetchDeviceProductListWithDeviceTypeId:[NSString stringWithFormat:@"%@",deviceTypeId] success:^(id responseObject) {
        OPLog(@"responseObject = %@",responseObject);
        OPLog(@"[NSThread currentThread] = %@",[NSThread currentThread]);
        if ([[responseObject allKeys] containsObject:@"data"]) {
            weakSelf.subTypeDeviceArr = [responseObject valueForKey:@"data"];
            if (weakSelf.subTypeDeviceArr.count>0) {
                [weakSelf.deviceListTableView reloadData];
            }
        }
        [weakSelf.deviceListTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        OPLog(@"error = %@",error);
        [weakSelf.deviceListTableView.mj_header endRefreshing];
        [HETCommonHelp showHudAutoHidenWithMessage:PuLLDownRefresh];
    }];
}

-(void)scanBleDeviceAction:(NSUInteger)productId{
    

 
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subTypeDeviceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DeviceSubTypeCell *cell = [DeviceSubTypeCell initWithTableView:tableView];
    NSDictionary  *deviceDict = self.subTypeDeviceArr[indexPath.row];
    [cell refreshData:deviceDict];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *dict = self.subTypeDeviceArr[indexPath.row];
    OPLog(@"dict = %@",dict);
    if (![[dict allKeys] containsObject:@"moduleType"]) {
        return;
    }

    HETDevice *device = [HETDevice mj_objectWithKeyValues:dict];
    // 蓝牙绑定
    if ([device.moduleType integerValue] == 2) {
        if([device.deviceTypeId integerValue]==6)
        {
            [self scanBleDeviceAction:[device.productId integerValue]];
            return;
        }
        HETBindBleDeviceVC *bindBleDeviceVC = [HETBindBleDeviceVC new];
        bindBleDeviceVC.device = device;
        [self.navigationController pushViewController:bindBleDeviceVC animated:YES];
        return;
    }
    // wifi 绑定
    if([device.moduleType integerValue] == 1 || [device.moduleType integerValue] == 9){
        HETSetPassWordVC *setPasswordVC = [HETSetPassWordVC new];
        setPasswordVC.device = device;
        [self.navigationController pushViewController:setPasswordVC animated:YES];
        return;
    }
}

- (void)addTableViewRefreshHeader
{
    WEAKSELF
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf fetchDeviceSubtypeList:self.deviceTypeId];
    }];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"XiaoC_loading@2x.gif" ofType:nil];
    UIImage *xiaoC_refresh = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:filePath]];
    [header setImages:xiaoC_refresh.images forState:MJRefreshStateIdle];
    [header setImages:xiaoC_refresh.images forState:MJRefreshStatePulling];
    [header setImages:xiaoC_refresh.images forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;

    self.deviceListTableView.mj_header = header;
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

        //去掉TableView中的默认横线
        _deviceListTableView.tableFooterView = [UIView new];

        [self addTableViewRefreshHeader];
    }
    return _deviceListTableView;
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
