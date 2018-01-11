//
//  HETBindBleDeviceViewController.m
//  HETOpenPlatformSDKDemo
//
//  Created by yuan yunlong on 2017/9/18.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETBindBleDeviceViewController.h"
#import "HETCommonHelp.h"
@interface HETBindBleDeviceViewController () <UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *deviceArr;
@property(strong, nonatomic) HETBLEBusiness *bleBusiness;

@end

@implementation HETBindBleDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.deviceArr = [@[] mutableCopy];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    WEAKSELF;
    //初始化蓝牙设备的业务类，需要设备的productId，deviceTypeId，deviceSubtypeId
    self.bleBusiness=[[HETBLEBusiness alloc]initWithProductId:self.productIdStr.integerValue deviceTypeId:self.deviceTypeStr.integerValue deviceSubtypeId:self.deviceSubTypeStr.integerValue];
    [self.bleBusiness scanForPeripheralsWithTimeOut:5 name:nil mac:nil scanForPeripheralsBlock:^(NSArray<CBPeripheral *> *peripherals, NSError *error) {
        STRONGSELF;
        
        [peripherals enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CBPeripheral *dev = (CBPeripheral*)obj;
            if (![strongSelf.deviceArr containsObject:dev]) {
                [strongSelf.deviceArr addObject:dev];
            }
            
        }];
        
        [strongSelf.tableView reloadData];

    }];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return _deviceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    CBPeripheral *cbp = (CBPeripheral *)[self.deviceArr objectAtIndex:indexPath.row];
    
    NSString *name = [[cbp valueForKey:@"name"] description]?:@"unknown";
    NSString *localname = cbp.localName;
    cell.textLabel.text = localname?:name;
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@(mac:%@)",[[cbp valueForKey:@"rssi"] description],cbp.mac];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *cbp = (CBPeripheral *)[self.deviceArr objectAtIndex:indexPath.row];
    if (cbp.state!=CBPeripheralStateConnected)
    {
        __weak typeof(self) weakself = self;
        [HETCommonHelp showCustomHudtitle:@"正在绑定设备"];
        [self.bleBusiness bindBleDeviceWithPeripheral:cbp macAddress:nil completionHandler:^(NSString *deviceId, NSError *error) {
            
            [weakself.bleBusiness disconnectWithPeripheral:cbp];
            [HETCommonHelp HidHud];
            
            if(error)
            {
                [HETCommonHelp showAutoDissmissWithMessage:@"绑定失败"];
                [weakself.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [HETCommonHelp showAutoDissmissWithMessage:@"绑定成功"];
                [weakself.navigationController popToRootViewControllerAnimated:true];
            }
        }];
        
        
    }
    
    
    
}
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark tableView
-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor= self.view.backgroundColor;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}



@end
