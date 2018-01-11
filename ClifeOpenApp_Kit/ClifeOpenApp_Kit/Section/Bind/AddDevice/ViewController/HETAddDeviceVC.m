//
//  HETAddDeviceVC.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/8/31.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETAddDeviceVC.h"
#import "HETBindInstructionVC.h"
#import "HETScanQrcodeVC.h"
#import "HETSetPassWordVC.h"
#import "HETDeviceSubTypeListVC.h"

#import "AddDevcieCell.h"
#import "HETAddDeviceTopView.h"


#define cellH 48.0f

@interface HETAddDeviceVC ()<UITableViewDataSource,UITableViewDelegate>
/** 顶部视图 **/
@property (nonatomic,strong) HETAddDeviceTopView                                   *topView;
/** 大类设备列表 **/
@property (nonatomic,strong) UITableView                                           *deviceListTableView;
/** 设备数组 **/
@property (nonatomic,strong) NSMutableArray                                        *deviceArr;

/** 小类设备数组 **/
@property (nonatomic,strong) NSMutableArray                                        *subTypeDeviceArr;
@end

@implementation HETAddDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置背景颜色
    self.view.backgroundColor = VCBgColor;

    // 2.设置导航栏
    [self createNavViews];

    // 3.初始化界面
    [self createSubView];

    // 4.查询设备大类
    [self fetchDeviceTypeList];

    // 5.添加事件处理
    [self addAction];
}

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

- (void)fetchDeviceTypeList
{
    WEAKSELF
    [HETDeviceRequestBusiness fetchDeviceTypeListSuccess:^(id responseObject) {
        OPLog(@"responseObject = %@",responseObject);
        OPLog(@"[NSThread currentThread] = %@",[NSThread currentThread]);
        if ([[responseObject allKeys] containsObject:@"data"]) {
            weakSelf.deviceArr = [responseObject valueForKey:@"data"];
            [weakSelf.deviceListTableView reloadData];
        }
        [weakSelf.deviceListTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        OPLog(@"error = %@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:PuLLDownRefresh];
        [weakSelf.deviceListTableView.mj_header endRefreshing];
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

    AddDevcieCell *cell =  [AddDevcieCell initWithTableView:tableView];
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
//    [self fetchDeviceSubtypeList:[NSString stringWithFormat:@"%@",[device valueForKey:@"deviceTypeId"]]];
    HETDeviceSubTypeListVC *subTypeListVC = [HETDeviceSubTypeListVC new];
    subTypeListVC.deviceTypeId = [device valueForKey:@"deviceTypeId"];
    [self.navigationController pushViewController:subTypeListVC animated:YES];
}

#pragma mark - btnAction

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
                [weakSelf.navigationController pushViewController:[HETScanQrcodeVC new] animated:YES];
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
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf fetchDeviceTypeList];
    }];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"XiaoC_loading@2x.gif" ofType:nil];
    UIImage *xiaoC_refresh = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:filePath]];
    [header setImages:xiaoC_refresh.images forState:MJRefreshStateIdle];
    [header setImages:xiaoC_refresh.images forState:MJRefreshStatePulling];
    [header setImages:xiaoC_refresh.images forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;

    self.deviceListTableView.mj_header = header;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (HETAddDeviceTopView *)topView
{
    if (!_topView) {
        _topView = [HETAddDeviceTopView new];
        _topView.backgroundColor = [UIColor colorFromHexRGB:@"efeff4"];
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
    }
    return _deviceListTableView;
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
