//
//  DeviceDetailsVC.m
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2018/5/17.
//  Copyright © 2018年 het. All rights reserved.
//

#import "DeviceDetailsVC.h"
#import "DeviceDetailsCell.h"
#import "DeviceDetailCellModel.h"
#import "HETShareDevcieVC.h"
#import "HETSQRCodeScanningVC.h"
#import "HETH5ContainBaseViewController.h"
#import "ChangeNameViewController.h"

#import "HETDeviceUpgradeProtocol.h"
#import "HETOpenSDKBaseBleHandle.h"
#import "HETDUBaseWifiHandle.h"
#import "HETDUProcessProtocol.h"

static CGFloat kDeviceDetailHeadCellHeight = 80.f;
static CGFloat kCellIOneRowHeight = 48.f;
@interface DeviceDetailsVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView    * deviceDetailTableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) HETDeviceVersionModel *deviceVersionModel;
@property (nonatomic,strong) id<HETDeviceUpgradeProtocol> upgradeManager;
@end

@implementation DeviceDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.设置背景颜色
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f2f3f7"];
    
    // 2.初始化数据
    [self setupData];
    
    // 3.设置导航栏
    [self createNavViews];
    
    // 4.初始化界面
    [self createSubView];
    
    // 5.检查固件版本
    [self deviceUpgradeCheck];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 2.初始化数据
    [self setupData];
    [self.deviceDetailTableView reloadData];
}

- (void)createNavViews
{
    // 1.中间标题
    self.navigationItem.title = DeviceDetailTitle;
    
    // 2.添加设备按妞
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

- (void)createSubView
{
    [self.view addSubview:self.deviceDetailTableView];
    [self.deviceDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setupData
{
    _dataSource = [NSMutableArray new];
    
    DeviceDetailCellModel *deviceNickName =  [DeviceDetailCellModel new];
    deviceNickName.imageName = @"deviceDetail_deviceName";
    deviceNickName.titleName = DeviceDetailTitleNickName ;
    deviceNickName.subTitleName = self.deviceModel.deviceName;
    
    DeviceDetailCellModel *deviceShareMode =  [DeviceDetailCellModel new];
    deviceShareMode.imageName = @"DeviceDetailsVC_deviceShare";
    deviceShareMode.titleName = ShareFuntionTitle ;
    
    DeviceDetailCellModel *scanMode =  [DeviceDetailCellModel new];
    scanMode.imageName = @"DeviceDetailsVC_deviceScan";
    scanMode.titleName = ScanQRCodeCellName ;
    
    DeviceDetailCellModel *updateModel =  [DeviceDetailCellModel new];
    updateModel.imageName = @"DeviceDetailsVC_deviceScan";
    updateModel.titleName = DeviceFirmwareUpgrade;
    
    [_dataSource addObject:deviceNickName];
    [_dataSource addObject:scanMode];
    [_dataSource addObject:updateModel];
    // 分享设备是没有下次分享权限
    if (_deviceModel.share.integerValue == 2) {
        [_dataSource addObject:deviceShareMode];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return _dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        DeviceDetailsCell *cell = [DeviceDetailsCell initWithTableView:tableView];
        [cell refreshData:self.deviceModel];
        return cell;
    }else{
        static NSString *ID = @"DeviceDetailsCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.backgroundColor = [UIColor whiteColor];
        }
        DeviceDetailCellModel *model = _dataSource[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:model.imageName];
        cell.textLabel.text = model.titleName;
        if (model.subTitleName) {
            cell.detailTextLabel.text = model.subTitleName;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 30.0f;
    }
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        return kDeviceDetailHeadCellHeight;
    }
    return kCellIOneRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
                [self pushChangeNameVC];
                break;
            case 1:
                [self pushToScanVC];
                break;
                
            case 2:
                [self pushToUpgradeVC];
                break;
            case 3:
                [self pushToShareVC];
            default:
                break;
        }
    }
}

#pragma mark -Action
- (void)pushChangeNameVC
{
    ChangeNameViewController  *changeNameVC =  [ChangeNameViewController new];
    changeNameVC.deviceModel = _deviceModel;
    [self.navigationController pushViewController:changeNameVC animated:true];
}

- (void)pushToShareVC
{
    HETShareDevcieVC *shareDeviceVC = [HETShareDevcieVC new];
    shareDeviceVC.deviceModel = _deviceModel;
    [self.navigationController pushViewController:shareDeviceVC animated:YES];
}

- (void)pushToScanVC
{
    HETSQRCodeScanningVC *scanVC = [HETSQRCodeScanningVC new];
    __weak typeof(self) weakself = self;
    scanVC.h5PathBlock = ^(NSString *h5Path) {
        if (h5Path.length > 0){
            if (weakself.scanDebug) {
                weakself.scanDebug(h5Path);
                [weakself backToDeviceControl];
            }
        }
    };
    [self.navigationController  pushViewController:scanVC animated:YES];
}

- (void)pushToUpgradeVC{
    // 分享设备是没有权限
    if (_deviceModel.share.integerValue == 1) {
        [HETCommonHelp showHudAutoHidenWithMessage:@"非绑定用户不能操作设备升级"];
        return;
    }
    
    self.upgradeManager = [[JSObjection defaultInjector] getObject:@protocol(HETDeviceUpgradeProtocol)] ;
    [self.upgradeManager checkWithDeviceId:self.deviceModel.deviceId success:^(HETDeviceVersionModel *versionModel) {
        if ([versionModel normalNeedUpgrade]) {
            [self upgradeAlert];
        }else{
            NSString *message = [NSString stringWithFormat:@"当前已是最新版本!"];
            [HETCommonHelp showHudAutoHidenWithMessage:message];
        }
    } failure:^(NSError *error) {
        OPLog(@"error:%@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
    }];
}

#pragma mark - 固件升级逻辑
- (void)upgradeAlert{
    NSString *message = [NSString stringWithFormat:@"当前版本:%@\n最新版本:%@ \n 确认进行固件升级？",self.deviceVersionModel.oldDeviceVersion,self.deviceVersionModel.newDeviceVersion];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"升级固件" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:CommonCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self upgradeHandleWithModuleType:self.deviceModel.moduleType.integerValue];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)upgradeHandleWithModuleType:(NSInteger)moduleType{
    switch (moduleType) {
        case 1:
        {
            id<HETDUProcessProtocol> Handle = [HETDUBaseWifiHandle deviceInfo:self.deviceModel version:self.deviceVersionModel];
            UIViewController *con = [self.upgradeManager upgradeVChandle:Handle];
            WEAKSELF
            self.upgradeManager.upgradeSuccess = ^{
                STRONGSELF
                [strongSelf deviceUpgradeCheck];
                [strongSelf.navigationController popViewControllerAnimated:YES];
            };
            self.upgradeManager.upgradeFailure = ^{
                STRONGSELF
                [strongSelf.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:con animated:YES];
        }
            break;
        case 2:
        {
            id<HETDUProcessProtocol> Handle = [HETOpenSDKBaseBleHandle deviceInfo:self.deviceModel version:self.deviceVersionModel];
            UIViewController *con = [self.upgradeManager upgradeVChandle:Handle];
            WEAKSELF
            self.upgradeManager.upgradeSuccess = ^{
                STRONGSELF
                [strongSelf deviceUpgradeCheck];
                [strongSelf.navigationController popViewControllerAnimated:YES];
            };
            self.upgradeManager.upgradeFailure = ^{
                STRONGSELF
                [strongSelf.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:con animated:YES];
        }
            break;
            
        default:
            [HETCommonHelp showHudAutoHidenWithMessage:@"此设备暂不支持升级"];
            break;
    }
}

- (void)deviceUpgradeCheck{
    WEAKSELF
    [HETDeviceUpgradeBusiness deviceUpgradeCheckWithDeviceId:self.deviceModel.deviceId success:^(HETDeviceVersionModel *deviceVersionModel) {
        STRONGSELF
        OPLog(@"deviceVersionModel:%@",deviceVersionModel);
        strongSelf.deviceVersionModel = deviceVersionModel;
        DeviceDetailCellModel *updateModel = strongSelf.dataSource[2];
        if (updateModel.titleName == DeviceFirmwareUpgrade) {
            updateModel.subTitleName = deviceVersionModel.oldDeviceVersion;
        }
        [strongSelf.deviceDetailTableView reloadData];
    } failure:^(NSError *error) {
        OPLog(@"error:%@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
    }];
}

- (void)backToDeviceControl
{
    NSArray *vcArray = self.navigationController.viewControllers;
    for (UIViewController *vc in vcArray) {
        if ([vc isKindOfClass:[HETH5ContainBaseViewController class]]) {
            [self.navigationController popToViewController:vc animated:true];
            break;
        }
    }
}

#pragma mark setter getter
- (UITableView *)deviceDetailTableView
{
    if (!_deviceDetailTableView) {
        _deviceDetailTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _deviceDetailTableView.backgroundColor = [UIColor clearColor];
        _deviceDetailTableView.dataSource = self;
        _deviceDetailTableView.delegate = self;
        _deviceDetailTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _deviceDetailTableView.separatorColor = [UIColor colorFromHexRGB:@"c6c6c6"];
        _deviceDetailTableView.sectionHeaderHeight = 5.0f;
        _deviceDetailTableView.sectionFooterHeight = 5.0f;
        
        //去掉TableView中的默认横线
        _deviceDetailTableView.tableFooterView = [UIView new];
    }
    return _deviceDetailTableView;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
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
