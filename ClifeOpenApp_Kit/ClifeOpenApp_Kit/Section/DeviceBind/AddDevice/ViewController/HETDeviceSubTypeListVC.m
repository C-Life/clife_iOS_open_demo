//
//  HETDeviceSubTypeListVC.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/9/13.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETDeviceSubTypeListVC.h"

//#import <HETMattressDeviceSDK/HETMattressDeviceSDK.h>
#import "HETSetPassWordVC.h"
#import "HETBindBleDeviceVC.h"
#import "HETDeviceListVC.h"
#import "HETBindGPRSDeviceVC.h"
#import "HETDeviceSubTypeCell.h"
#import "HETEmptyView.h"
#import "UIScrollView+EmptyDataSet.h"
#define cellH  72.0f
#define IOS91 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.1")

@interface HETDeviceSubTypeListVC ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

///睡眠带子1.5版本
//@property (nonatomic,strong) HETBLEMattressDevice *mattressDevice;
///设备列表
@property (nonatomic,strong) UITableView *deviceListTableView;
///设备数组
@property (nonatomic,strong) NSMutableArray *subTypeDeviceArr;
///满足搜索条件的数组
@property (nonatomic,strong) NSMutableArray *searchList;
///搜索框
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,assign,getter=isSearching) BOOL searching;
///无数据、网络失败、加载中空白页
@property (nonatomic,strong) HETEmptyView *emptyView;
///空白页的状态
@property (nonatomic,assign) HETEmptyViewState emptyState;

@end

@implementation HETDeviceSubTypeListVC

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = DeviceListTitle;
    
    // 初始化界面
    [self createSubView];
    
    // 获取设备
    [self fetchDeviceSubtypeList:self.deviceTypeId];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//
//    [self.navigationController.navigationBar setShadowImage:nil];
}

#pragma mark - Init
- (void)createSubView
{
    // 1.设备列表
    [self.view addSubview:self.deviceListTableView];
    [self.deviceListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    //创建UISearchController
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.placeholder = @"搜索型号";
    
    //包着搜索框外层的颜色
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
    if IOS91 {
        self.searchController.obscuresBackgroundDuringPresentation = NO;
    }
    
    //隐藏导航栏
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    //添加一张白色的图片（方法自己上网搜索）
    UIImage * image = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(self.view.frame.size.width, 34)];
    
    //把白色的图片弄成自己想要的样子（图片处理大小和切圆角，方法自己上网搜索）
    //    image =[UIImage createRoundedRectImage:image size:CGSizeMake(self.view.frame.size.width, 34) radius:34/2];
    [self.searchController.searchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];

    //    iOS11之后searchController有了新样式，可以放在导航栏
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling=NO;
    } else {
        self.deviceListTableView.tableHeaderView = self.searchController.searchBar;
    }
    
    self.definesPresentationContext = YES;
}

#pragma mark - Request
- (void)fetchDeviceSubtypeList:(NSNumber *)deviceTypeId
{
    self.emptyState = HETEmptyViewStateLoading;
    WEAKSELF
    [HETDeviceRequestBusiness fetchDeviceProductListWithDeviceTypeId:[NSString stringWithFormat:@"%@",deviceTypeId] success:^(id responseObject) {
        STRONGSELF
        OPLog(@"responseObject = %@",responseObject);
        OPLog(@"[NSThread currentThread] = %@",[NSThread currentThread]);
        if ([[responseObject allKeys] containsObject:@"data"]) {
            strongSelf.subTypeDeviceArr = [responseObject valueForKey:@"data"];
            if (strongSelf.subTypeDeviceArr.count>0) {
                [strongSelf.deviceListTableView reloadData];
            }
        }
        strongSelf.emptyState = HETEmptyViewStateUnknow;
        [strongSelf.deviceListTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        STRONGSELF
        OPLog(@"error = %@",error);
        strongSelf.emptyState = HETEmptyViewStateError;
        [strongSelf.deviceListTableView.mj_header endRefreshing];
        [HETCommonHelp showHudAutoHidenWithMessage:PuLLDownRefresh];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearching == YES) {
        return self.searchList.count;
    }
    return self.subTypeDeviceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HETDeviceSubTypeCell *cell = [HETDeviceSubTypeCell initWithTableView:tableView];
    
    if (self.isSearching == YES) {
        NSDictionary  *deviceDict = self.searchList[indexPath.row];
        [cell refreshData:deviceDict];
    }
    else{
        NSDictionary  *deviceDict = self.subTypeDeviceArr[indexPath.row];
        [cell refreshData:deviceDict];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchController.searchBar resignFirstResponder];
    [self tableViewCellClick:indexPath];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchController.searchBar resignFirstResponder];
}

#pragma mark - UISearchControllerDelegate代理
- (void)willPresentSearchController:(UISearchController *)searchController
{
    OPLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    OPLog(@"didPresentSearchController");
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    OPLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    OPLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController
{
    OPLog(@"presentSearchController");
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    for (id obj in [searchBar subviews]) {
        if ([obj isKindOfClass:[UIView class]]) {
            for (id obj2 in [obj subviews]) {
                if ([obj2 isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)obj2;
                    [btn setTitle:@"取消" forState:UIControlStateNormal];
                }
            }
        }
    }
    return YES;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    OPLog(@"搜索关键字：%@",searchController.searchBar.text);
    [self filterContentForSearchText:searchController.searchBar.text];
}

#pragma mark - DZNEmptyDataSetSource
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    self.emptyView.emptyState = self.emptyState;
    return self.emptyView;
}

//是否显示空白页，默认YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.emptyState == HETEmptyViewStateLoading;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - Event response
- (void)tableViewCellClick:(NSIndexPath *)indexPath{
    NSDictionary  *dict = [NSDictionary dictionary];
    if (self.isSearching == YES) {
        dict = self.searchList[indexPath.row];
    }
    else{
        dict = self.subTypeDeviceArr[indexPath.row];
    }
    OPLog(@"dict = %@",dict);
    if (![[dict allKeys] containsObject:@"bindType"]) {
        return;
    }
    
    HETDevice *device = [HETDevice mj_objectWithKeyValues:dict];
    // 蓝牙绑定
    if ([device.bindType integerValue] == 2) {
        // 睡眠带子1.5版本
        if([device.deviceTypeId integerValue]==6 && [device.deviceSubtypeId integerValue]==2)
        {
            [self scanBleDeviceAction:[device.productId integerValue]];
            return;
        }
        HETBindBleDeviceVC *bindBleDeviceVC = [HETBindBleDeviceVC new];
        bindBleDeviceVC.device = device;
        [self.navigationController pushViewController:bindBleDeviceVC animated:YES];
        return;
    }
    
    // wifi绑定
    if([device.bindType integerValue] == 1){
        HETSetPassWordVC *setPasswordVC = [HETSetPassWordVC new];
        setPasswordVC.device = device;
        [self.navigationController pushViewController:setPasswordVC animated:YES];
        return;
    }
    
    // 4、GSM绑定、6-直连--内置Android系统、8-Zigbee
    if ([device.bindType integerValue] == 4 || [device.bindType integerValue] == 6 || [device.bindType integerValue] == 8) {
        HETBindGPRSDeviceVC *gprsVC = [HETBindGPRSDeviceVC new];
        gprsVC.device = device;
        [self.navigationController pushViewController:gprsVC animated:YES];
        return;
    }
}

- (void)addTableViewRefreshHeader
{
    WEAKSELF
    self.deviceListTableView.mj_header = [HETComRefreshHeader headerWithRefreshingBlock:^{
        STRONGSELF
        [strongSelf fetchDeviceSubtypeList:self.deviceTypeId];
    }];
}

- (void)filterContentForSearchText:(NSString*)searchString{
    
    if (self.searchList != nil) {
        [self.searchList removeAllObjects];
    }
    
    if (searchString.length > 0 ) {
        self.searching = YES;
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in self.subTypeDeviceArr) {
            NSString *productCode = [dict valueForKey:@"productCode"];
            if ([productCode containsString:searchString]) {
                [arr addObject:dict];
            }
        }
        self.searchList = arr;
    }else{
        self.searching = NO;
    }
    
    [self.deviceListTableView reloadData];
}

//睡眠带子1.5版本的绑定方法
-(void)scanBleDeviceAction:(NSUInteger)productId{
    
    //    [HETCommonHelp showMessage:ScanningBleDevice toView:self.view];
    //
    //    self.mattressDevice=nil;
    //    self.mattressDevice=[[HETBLEMattressDevice alloc]init];
    //    WEAKSELF;
    //    [self.mattressDevice scanBleDevicesProductId:productId timeOut:10 scanBleDevices:^(NSArray<LGPeripheral *> *deviceArray, NSError *error) {
    //        STRONGSELF
    //        if(error)
    //        {
    //            OPLog(@"蓝牙扫描失败:%@",error);
    //            [HETCommonHelp hideHudFromView:strongSelf.view];
    //            [HETCommonHelp showHudAutoHidenWithMessage:BleScanFail];
    //            [strongSelf.mattressDevice disconnect];
    //            strongSelf.mattressDevice=nil;
    //        }
    //        else
    //        {
    //            [HETCommonHelp hideHudFromView:strongSelf.view];
    //            [HETCommonHelp showMessage:BindingBleDevice toView:strongSelf.view];
    //            LGPeripheral *per=[deviceArray firstObject];
    //
    //            [strongSelf.mattressDevice bindBleDevice:per deviceProductId:productId successBlock:^(NSString *deviceId){
    //                [strongSelf.mattressDevice disconnect];
    //                strongSelf.mattressDevice=nil;
    //                dispatch_async(dispatch_get_main_queue(), ^{
    //                    [HETCommonHelp HidHud];
    //                    [HETCommonHelp showHudAutoHidenWithMessage:BindBleDeviceSuccess];
    //                    dispatch_async(dispatch_get_main_queue(), ^{
    //                        [[NSNotificationCenter defaultCenter] postNotificationName:kBindDeviceSuccess object:nil];
    //                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                            [self.navigationController popToRootViewControllerAnimated:true];
    //                        });
    //                    });
    //                });
    //
    //            } failBlock:^(NSError *error) {
    //                OPLog(@"绑定失败");
    //                [strongSelf.mattressDevice disconnect];
    //                strongSelf.mattressDevice=nil;
    //                [HETCommonHelp hideHudFromView:strongSelf.view];
    //                [HETCommonHelp showHudAutoHidenWithMessage:BindBleDeviceFail];
    //            }];
    //
    //        }
    //    }];
}

#pragma mark - getters and setters
- (UITableView *)deviceListTableView
{
    if (!_deviceListTableView) {
        _deviceListTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _deviceListTableView.backgroundColor = [UIColor clearColor];
        _deviceListTableView.dataSource = self;
        _deviceListTableView.delegate = self;
        _deviceListTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _deviceListTableView.separatorColor = OPColor(@"c6c6c6");
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
            [strongSelf fetchDeviceSubtypeList:strongSelf.deviceTypeId];
        };
    }
    return _emptyView;
}

- (void)setEmptyState:(HETEmptyViewState)emptyState
{
    _emptyState = emptyState;
    self.emptyView.emptyState = self.emptyState;
    [self.deviceListTableView  reloadEmptyDataSet];
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
