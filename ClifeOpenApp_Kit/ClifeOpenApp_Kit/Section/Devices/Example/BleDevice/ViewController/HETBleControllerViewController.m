//
//  HETBleControllerViewController.m
//  ClifeOpenApp_Kit
//
//  Created by yuan yunlong on 2017/9/19.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETBleControllerViewController.h"
#import "HETCommonHelp.h"
@interface HETBleControllerViewController ()
{
    HETBLEBusiness *_bleBusiness;
    UInt8 ledColor;
    UInt8 ledState;
}

@property(nonatomic,strong)CBPeripheral *blePeripheral;
@property(nonatomic,strong)NSString  *macAddress;
@property(nonatomic,assign)NSUInteger deviceType;
@property(nonatomic,assign)NSUInteger deviceSubType;
@property(nonatomic,assign)NSUInteger productId;
@property(nonatomic,assign)NSString  *deviceId;


@property(nonatomic,strong)UIButton *realTimeDataButton;
@property(nonatomic,strong)UIButton *fetchHistoryDataButton;
@property(nonatomic,strong)UIButton *clearHistoryDataButton;
@property(nonatomic,strong)UIButton *getTimeDataButton;
@property(nonatomic,strong)UIButton *setTimeDataButton;
@property(nonatomic,strong)UIButton *deviceControlButton;
@property(nonatomic,strong)UIButton *mcuUpgradeButton;
@property(nonatomic,strong)UIButton *fetchRealTimeDataFromServerButton;
@property(nonatomic,strong)UIButton *fetchHistoryDataFromServerButton;
@property(nonatomic,strong)UIButton *fetchStatusDataFromServerButton;

@end

@implementation HETBleControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    ledColor=0;
    int btnHeight=64;
    int xpadding=15;
    int ypadding=(CGRectGetHeight([UIScreen mainScreen].bounds)-btnHeight*5-64)/6;
    [self.view addSubview:self.realTimeDataButton];
    [self.view addSubview:self.fetchHistoryDataButton];
    [self.view addSubview:self.clearHistoryDataButton];
    [self.view addSubview:self.getTimeDataButton];
    [self.view addSubview:self.setTimeDataButton];
    [self.view addSubview:self.deviceControlButton];
    [self.view addSubview:self.mcuUpgradeButton];
    [self.view addSubview:self.fetchRealTimeDataFromServerButton];
    [self.view addSubview:self.fetchHistoryDataFromServerButton];
    [self.view addSubview:self.fetchStatusDataFromServerButton];
    
    [self.realTimeDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(ypadding);
        make.left.equalTo(self.view.mas_left).offset(xpadding);
        make.right.equalTo(self.deviceControlButton.mas_left).offset(-xpadding);
        make.width.equalTo(self.deviceControlButton.mas_width);
        make.height.equalTo(@(btnHeight));
    }];
    
    [self.fetchHistoryDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.realTimeDataButton.mas_bottom).offset(ypadding);
        make.centerX.equalTo(self.realTimeDataButton.mas_centerX);
        make.width.equalTo(self.realTimeDataButton.mas_width);
        make.height.equalTo(self.realTimeDataButton.mas_height);
    }];
    
    [self.clearHistoryDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fetchHistoryDataButton.mas_bottom).offset(ypadding);
        make.centerX.equalTo(self.fetchHistoryDataButton.mas_centerX);
        make.width.equalTo(self.fetchHistoryDataButton.mas_width);
        make.height.equalTo(self.fetchHistoryDataButton.mas_height);
    }];
    
    
    [self.getTimeDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clearHistoryDataButton.mas_bottom).offset(ypadding);
        make.centerX.equalTo(self.clearHistoryDataButton.mas_centerX);
        make.width.equalTo(self.clearHistoryDataButton.mas_width);
        make.height.equalTo(self.clearHistoryDataButton.mas_height);
        
    }];
    
    [self.setTimeDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.getTimeDataButton.mas_bottom).offset(ypadding);
        make.centerX.equalTo(self.getTimeDataButton.mas_centerX);
        make.width.equalTo(self.getTimeDataButton.mas_width);
        make.bottom.equalTo(self.view.mas_bottom).offset(-ypadding);
        
        
    }];
    
    [self.deviceControlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.realTimeDataButton.mas_top);
        make.left.equalTo(self.realTimeDataButton.mas_right).offset(xpadding);
        make.right.equalTo(self.view.mas_right).offset(-xpadding);
        make.width.equalTo(self.realTimeDataButton.mas_width);
        make.height.equalTo(self.realTimeDataButton.mas_height);
    }];
    
    [self.mcuUpgradeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deviceControlButton.mas_bottom).offset(ypadding);
        make.centerX.equalTo(self.deviceControlButton.mas_centerX);
        make.width.equalTo(self.deviceControlButton.mas_width);
        make.height.equalTo(self.deviceControlButton.mas_height);
    }];
    [self.fetchRealTimeDataFromServerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mcuUpgradeButton.mas_bottom).offset(ypadding);
        make.centerX.equalTo(self.mcuUpgradeButton.mas_centerX);
        make.width.equalTo(self.mcuUpgradeButton.mas_width);
        make.height.equalTo(self.mcuUpgradeButton.mas_height);
    }];
    [self.fetchHistoryDataFromServerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fetchRealTimeDataFromServerButton.mas_bottom).offset(ypadding);
        make.centerX.equalTo(self.fetchRealTimeDataFromServerButton.mas_centerX);
        make.width.equalTo(self.fetchRealTimeDataFromServerButton.mas_width);
        make.height.equalTo(self.fetchRealTimeDataFromServerButton.mas_height);
    }];
    [self.fetchStatusDataFromServerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fetchHistoryDataFromServerButton.mas_bottom).offset(ypadding);
        make.centerX.equalTo(self.fetchHistoryDataFromServerButton.mas_centerX);
        make.width.equalTo(self.fetchHistoryDataFromServerButton.mas_width);
        make.height.equalTo(self.fetchHistoryDataFromServerButton.mas_height);
    }];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!_bleBusiness)
    {
        _bleBusiness=[[[HETBLEBusiness alloc]init]initWithProductId:self.productId deviceTypeId:self.deviceType deviceSubtypeId:self.deviceSubType];
        
    }
    WEAKSELF;
    [_bleBusiness fetchStatusDataWithPeripheral:self.blePeripheral macAddress:self.macAddress deviceId:self.deviceId completionHandler:^(CBPeripheral *currentPeripheral,NSDictionary *dic, NSError *error) {
        STRONGSELF;
        strongSelf.blePeripheral=currentPeripheral;
        NSLog(@"状态数据:%@,%@",dic,error);
        if(dic)
        {
            
            uint8_t state ;
            UInt8 color;
            NSString *colorStr=dic[@"LED"];
            NSString *stateStr=dic[@"LIGHT"];
            color=colorStr.intValue;//@"MIST":@"0",@"LIGHT":@"1",@"LED"
            state=stateStr.intValue;
            strongSelf->ledColor = color%9;
            strongSelf->ledState = state;
            if (state == 3) {
                [strongSelf changeLED_color:0];//灯是关掉的
            }else if(state == 1) {
                [strongSelf changeLED_color:color];
            }
            
        }
        
        
    }];
    
    
}
-(void)changeLED_color:(UInt8)state
{
    
    NSArray *ledColors = @[
                           [UIColor darkGrayColor],
                           [UIColor redColor],
                           [UIColor orangeColor],
                           [UIColor yellowColor],
                           [UIColor greenColor],
                           [UIColor cyanColor],
                           [UIColor blueColor],
                           [UIColor purpleColor],
                           [UIColor whiteColor],
                           ];
    
    UInt8 color = state %9;
    [self.deviceControlButton setBackgroundColor:[ledColors objectAtIndex:color]];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_bleBusiness disconnectWithPeripheral:self.blePeripheral];
    _bleBusiness=nil;
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

-(void)realTimeDataAction
{
    WEAKSELF;
    [HETCommonHelp showCustomHudtitle:@"正在获取实时数据"];
    [_bleBusiness fetchRealTimeDataWithPeripheral:self.blePeripheral macAddress:self.macAddress deviceId:self.deviceId completionHandler:^(CBPeripheral *currentPeripheral,NSDictionary *dic, NSError *error) {
        STRONGSELF;
        strongSelf.blePeripheral=currentPeripheral;
        NSLog(@"实时数据回调:%@,%@",dic,error);
        if(error)
        {
            [HETCommonHelp HidHud];
            [HETCommonHelp showHudAutoHidenWithMessage:@"获取实时数据失败"];
        }
        else
        {
            [HETCommonHelp HidHud];
            [HETCommonHelp showHudAutoHidenWithMessage:@"获取实时数据成功"];
        }
    }];
    
}
-(void)fetchHistoryDataAction
{
    
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].windows.lastObject] ;
    [[UIApplication sharedApplication].windows.lastObject addSubview:hud];
    hud.dimBackground = NO;
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.labelText = @"获取历史数据进度";
    [hud show:YES];
    WEAKSELF;
    [_bleBusiness fetchHistoryDataWithPeripheral:self.blePeripheral macAddress:self.macAddress deviceId:self.deviceId progress:^(UInt16 currentFrame, UInt16 totalFrame, NSData *data) {
        NSLog(@"历史数据当前的帧数:%d,总帧数:%d,当前数据帧:%@",currentFrame,totalFrame,data);
        hud.progress=(float)currentFrame/totalFrame;
    } completionHandler:^(CBPeripheral *currentPeripheral,NSData *data, NSError *error) {
        STRONGSELF;
        strongSelf.blePeripheral=currentPeripheral;
        NSLog(@"历史数据:%@,%@",data,error);
        if(error)
        {
            [HETCommonHelp HidHud];
            [HETCommonHelp showHudAutoHidenWithMessage:@"获取历史数据失败"];
        }
        else
        {
            [HETCommonHelp HidHud];
            [HETCommonHelp showHudAutoHidenWithMessage:@"获取历史数据成功"];
        }
        
        
    }];
}
-(void)clearHistoryDataAction
{
    WEAKSELF;
    [HETCommonHelp showCustomHudtitle:@"正在清除历史数据"];
    [_bleBusiness clearHistoryDataWithPeripheral:self.blePeripheral macAddress:self.macAddress completionHandler:^(CBPeripheral *currentPeripheral,NSError *error) {
        STRONGSELF;
        strongSelf.blePeripheral=currentPeripheral;
        NSLog(@"清除历史数据回调:%@",error);
        if(error)
        {
            [HETCommonHelp HidHud];
            [HETCommonHelp showHudAutoHidenWithMessage:@"清除历史数据失败"];
        }
        else
        {
            [HETCommonHelp HidHud];
            [HETCommonHelp showHudAutoHidenWithMessage:@"清除历史数据成功"];
        }
    }];
}
-(void)getTimeDataAction
{
    WEAKSELF;
    [HETCommonHelp showCustomHudtitle:@"正在获取时间数据"];
    [_bleBusiness getTimeWithPeripheral:self.blePeripheral macAddress:self.macAddress completionHandler:^(CBPeripheral *currentPeripheral,NSData *data, NSError *error) {
        STRONGSELF;
        strongSelf.blePeripheral=currentPeripheral;
        NSLog(@"获取时间数据回调:%@,%@",data,error);
        if(error)
        {
            [HETCommonHelp HidHud];
            [HETCommonHelp showHudAutoHidenWithMessage:@"获取时间数据失败"];
        }
        else
        {
            [HETCommonHelp HidHud];
            [HETCommonHelp showHudAutoHidenWithMessage:@"获取时间数据成功"];
        }
        
    }];
    
}
-(void)setTimeDataAction
{
    [HETCommonHelp showCustomHudtitle:@"正在设置时间数据"];
    WEAKSELF;
    [_bleBusiness setTimeWithPeripheral:self.blePeripheral macAddress:self.macAddress timeType:HETBLECSTTime completionHandler:^(CBPeripheral *currentPeripheral,NSData *data, NSError *error) {
        STRONGSELF;
        strongSelf.blePeripheral=currentPeripheral;
        NSLog(@"设置时间数据数据回调:%@,%@",data,error);
        if(error)
        {
            [HETCommonHelp HidHud];
            [HETCommonHelp showHudAutoHidenWithMessage:@"设置时间数据数据失败"];
        }
        else
        {
            [HETCommonHelp HidHud];
            [HETCommonHelp showHudAutoHidenWithMessage:@"设置时间数据数据成功"];
        }
        
    }];
}
/*
 mist -- 0x00 （不设置）1全功率 2半功率 3关
 light -- 0x00 （不设置）1高亮 2暗亮 3关
 rgb    -- 0x00 （不设置） 1～8 红～紫 、白
 
 */
-(void)deviceControlAction
{
    WEAKSELF;
    ledColor++;
    ledColor = ledColor %9;
    uint8_t state = ledColor;
    UInt8 bytes[3] = {0x00,0x01,state};
    NSData *data = [NSData dataWithBytes:bytes length:3];
    NSDictionary *dic;
    if (state==0 && ledState !=3)
    {
        UInt8 bytes[3] = {0x00,0x03,0x00};//关灯
        data = [NSData dataWithBytes:bytes length:3];
        dic=@{@"MIST":@"0",@"LIGHT":@"3",@"LED":@"0"};
        
    }else if (state==0 && ledState == 3){
        UInt8 bytes[3] = {0x00,0x01,0x01};//开灯 、红灯
        data = [NSData dataWithBytes:bytes length:3];
        dic=@{@"MIST":@"0",@"LIGHT":@"1",@"LED":@"1"};
    }
    else
    {
        dic=@{@"MIST":@"0",@"LIGHT":@"1",@"LED":[NSString stringWithFormat:@"%d",state]};
    }
    
    [HETCommonHelp showCustomHudtitle:@"正在发送数据"];//@{@"MIST":@"0",@"LIGHT":@"1",@"LED":[NSString stringWithFormat:@"%d",ledColor %9]}
    [_bleBusiness deviceControlRequestWithPeripheral:self.blePeripheral macAddress:self.macAddress sendDic:@{@"LED":@(ledColor %9)} completionHandler:^(CBPeripheral *currentPeripheral,NSError *error) {
        STRONGSELF;
        strongSelf.blePeripheral=currentPeripheral;
        NSLog(@"数据发送回调:%@",error);
        if(error)
        {
            [HETCommonHelp HidHud];
            [HETCommonHelp showHudAutoHidenWithMessage:@"数据发送失败"];
        }
        else
        {
            [HETCommonHelp HidHud];
            [HETCommonHelp showHudAutoHidenWithMessage:@"数据发送成功"];
        }
        
    }];
}

-(void)mcuUpgradeAction
{
    //获取最新版本
    WEAKSELF
    [HETDeviceUpgradeBusiness deviceUpgradeCheckWithDeviceId:self.deviceId success:^(HETDeviceVersionModel * deviceVersionModel) {
        //        deviceVersionId = 2024;
        //        filePath = "http://200.200.200.58:8981/group1/M00/0D/83/yMjIOlj4drWAeBL-AAB2rNrxQug170.bin";
        //        newDeviceVersion = "V1.1.2";
        //        oldDeviceVersion = "1.0.0";
        //        releaseNote = "\U6d4b\U8bd5\U7528\U4f8b\Uff0c\U56fa\U4ef6\U5347\U7ea7";
        //        status = 1;
        if(deviceVersionModel.newDeviceVersion&&![deviceVersionModel.newDeviceVersion isEqualToString:deviceVersionModel.oldDeviceVersion])//有新固件
        {
            MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].windows.lastObject] ;
            [[UIApplication sharedApplication].windows.lastObject addSubview:hud];
            hud.dimBackground = NO;
            hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
            hud.labelText = @"MCU升级中";
            [hud show:YES];
            [_bleBusiness mcuUpgrade:self.blePeripheral macAddress:self.macAddress deviceId:self.device.deviceId deviceVersionModel:deviceVersionModel progress:^(float progress) {
                hud.progress=progress;
            } completionHandler:^(CBPeripheral *currentPeripheral, NSError *error) {
                if(error)
                {
                    [HETCommonHelp HidHud];
                    [HETCommonHelp showHudAutoHidenWithMessage:@"MCU升级失败"];
                }
                else
                {
                    [HETCommonHelp HidHud];
                    [HETCommonHelp showHudAutoHidenWithMessage:@"MCU升级成功"];
                }
            }];
        
        }else{
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"获取硬件版本信息错误:%@",error);
    }];
}

-(void)fetchRealTimeDataFromServer
{
    [HETCommonHelp showCustomHudtitle:@"查询七天内的实时数据"];
    NSString *deviceId=self.deviceId;
    NSDate *senddate =[NSDate dateWithTimeIntervalSinceNow:+(24*60*60)]; //[NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    NSLog(@"locationString:%@", locationString);
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    
    NSString *lastlocationString = [dateformatter stringFromDate:yesterday];
    NSLog(@"lastlocationString:%@", lastlocationString);
    
    
    [HETDeviceRequestBusiness fetchDeviceRundataListWithDeviceId:deviceId startDate:lastlocationString endDate:locationString pageRows:nil pageIndex:nil success:^(id responseObject) {
        NSLog(@"历史实时数据:%@",responseObject);
        
        [HETCommonHelp HidHud];
        [HETCommonHelp showHudAutoHidenWithMessage:@"查询实时数据成功"];
        
        
    } failure:^(NSError *error) {
        NSLog(@"历史实时数据失败:%@",error);
        
        [HETCommonHelp HidHud];
        [HETCommonHelp showHudAutoHidenWithMessage:@"查询实时数据失败"];
        
    }];
}


-(void)fetchHistoryDataFromServer
{
    
    [HETCommonHelp showCustomHudtitle:@"查询历史数据"];
    [HETDeviceRequestBusiness fetchHistoryWithDeviceId:self.deviceId withOrder:0 withPageRows:20 withPageIndex:0 success:^(id responseObject) {
        
        
        [HETCommonHelp HidHud];
        [HETCommonHelp showHudAutoHidenWithMessage:@"查询历史数据成功"];
        
        
        
    } failure:^(NSError *error) {
        
        [HETCommonHelp HidHud];
        [HETCommonHelp showHudAutoHidenWithMessage:@"查询历史数据数据失败"];
        
        
    }];
}


-(void)fetchStatusDataFromServer
{
    [HETCommonHelp showCustomHudtitle:@"查询七天内的状态数据"];
    NSString *deviceId=self.deviceId;
    NSDate *senddate =[NSDate dateWithTimeIntervalSinceNow:+(24*60*60)]; //[NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    NSLog(@"locationString:%@", locationString);
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    
    NSString *lastlocationString = [dateformatter stringFromDate:yesterday];
    NSLog(@"lastlocationString:%@", lastlocationString);
    
    
    [HETDeviceRequestBusiness fetchDeviceStatusDataListWithDeviceId:deviceId startDate:lastlocationString endDate:locationString pageRows:nil pageIndex:nil success:^(id responseObject) {
        NSLog(@"历史的状态数据:%@",responseObject);
        
        
        [HETCommonHelp HidHud];
        [HETCommonHelp showHudAutoHidenWithMessage:@"查询状态数据成功"];
        
        
    } failure:^(NSError *error) {
        NSLog(@"历史状态数据失败:%@",error);
        
        [HETCommonHelp HidHud];
        [HETCommonHelp showHudAutoHidenWithMessage:@"查询状态数据失败"];
        
        
    }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(UIButton *)realTimeDataButton
{
    if(!_realTimeDataButton)
    {
        _realTimeDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_realTimeDataButton setTitle:@"获取实时数据" forState:UIControlStateNormal];
        [_realTimeDataButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_realTimeDataButton addTarget:self action:@selector(realTimeDataAction) forControlEvents:UIControlEventTouchUpInside];
        _realTimeDataButton.backgroundColor=[UIColor colorFromHexRGB:@"2E7BD3"];
        _realTimeDataButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        
    }
    return _realTimeDataButton;
}
-(UIButton *)fetchHistoryDataButton
{
    if(!_fetchHistoryDataButton)
    {
        _fetchHistoryDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fetchHistoryDataButton setTitle:@"获取历史数据" forState:UIControlStateNormal];
        [_fetchHistoryDataButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fetchHistoryDataButton addTarget:self action:@selector(fetchHistoryDataAction) forControlEvents:UIControlEventTouchUpInside];
        _fetchHistoryDataButton.backgroundColor=[UIColor colorFromHexRGB:@"2E7BD3"];
        _fetchHistoryDataButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        
    }
    return _fetchHistoryDataButton;
}

-(UIButton *)clearHistoryDataButton
{
    if(!_clearHistoryDataButton)
    {
        _clearHistoryDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearHistoryDataButton setTitle:@"清除历史数据" forState:UIControlStateNormal];
        [_clearHistoryDataButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_clearHistoryDataButton addTarget:self action:@selector(clearHistoryDataAction) forControlEvents:UIControlEventTouchUpInside];
        _clearHistoryDataButton.backgroundColor=[UIColor colorFromHexRGB:@"2E7BD3"];
        _clearHistoryDataButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        
    }
    return _clearHistoryDataButton;
}



-(UIButton *)getTimeDataButton
{
    if(!_getTimeDataButton)
    {
        _getTimeDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getTimeDataButton setTitle:@"获取时间" forState:UIControlStateNormal];
        [_getTimeDataButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getTimeDataButton addTarget:self action:@selector(getTimeDataAction) forControlEvents:UIControlEventTouchUpInside];
        _getTimeDataButton.backgroundColor=[UIColor colorFromHexRGB:@"2E7BD3"];
        _getTimeDataButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        
    }
    return _getTimeDataButton;
}

-(UIButton *)setTimeDataButton
{
    if(!_setTimeDataButton)
    {
        _setTimeDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setTimeDataButton setTitle:@"设置时间" forState:UIControlStateNormal];
        [_setTimeDataButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_setTimeDataButton addTarget:self action:@selector(setTimeDataAction) forControlEvents:UIControlEventTouchUpInside];
        _setTimeDataButton.backgroundColor=[UIColor colorFromHexRGB:@"2E7BD3"];
        _setTimeDataButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        
    }
    return _setTimeDataButton;
}


-(UIButton *)deviceControlButton
{
    if(!_deviceControlButton)
    {
        _deviceControlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deviceControlButton setTitle:@"设备控制" forState:UIControlStateNormal];
        [_deviceControlButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deviceControlButton addTarget:self action:@selector(deviceControlAction) forControlEvents:UIControlEventTouchUpInside];
        _deviceControlButton.backgroundColor=[UIColor colorFromHexRGB:@"2E7BD3"];
        _deviceControlButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        
    }
    return _deviceControlButton;
}

-(UIButton *)mcuUpgradeButton
{
    if(!_mcuUpgradeButton)
    {
        _mcuUpgradeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mcuUpgradeButton setTitle:@"MCU升级" forState:UIControlStateNormal];
        [_mcuUpgradeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mcuUpgradeButton addTarget:self action:@selector(mcuUpgradeAction) forControlEvents:UIControlEventTouchUpInside];
        _mcuUpgradeButton.backgroundColor=[UIColor colorFromHexRGB:@"2E7BD3"];
        _mcuUpgradeButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        
    }
    return _mcuUpgradeButton;
}
-(UIButton *)fetchRealTimeDataFromServerButton
{
    if(!_fetchRealTimeDataFromServerButton)
    {
        _fetchRealTimeDataFromServerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fetchRealTimeDataFromServerButton setTitle:@"从服务器获取蓝牙实时数据" forState:UIControlStateNormal];
        [_fetchRealTimeDataFromServerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fetchRealTimeDataFromServerButton addTarget:self action:@selector(fetchRealTimeDataFromServer) forControlEvents:UIControlEventTouchUpInside];
        _fetchRealTimeDataFromServerButton.backgroundColor=[UIColor colorFromHexRGB:@"2E7BD3"];
        _fetchRealTimeDataFromServerButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        
    }
    return _fetchRealTimeDataFromServerButton;
}
-(UIButton *)fetchHistoryDataFromServerButton
{
    if(!_fetchHistoryDataFromServerButton)
    {
        _fetchHistoryDataFromServerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fetchHistoryDataFromServerButton setTitle:@"从服务器获取蓝牙历史数据" forState:UIControlStateNormal];
        [_fetchHistoryDataFromServerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fetchHistoryDataFromServerButton addTarget:self action:@selector(fetchHistoryDataFromServer) forControlEvents:UIControlEventTouchUpInside];
        _fetchHistoryDataFromServerButton.backgroundColor=[UIColor colorFromHexRGB:@"2E7BD3"];
        _fetchHistoryDataFromServerButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        
    }
    return _fetchHistoryDataFromServerButton;
}
-(UIButton *)fetchStatusDataFromServerButton
{
    if(!_fetchStatusDataFromServerButton)
    {
        _fetchStatusDataFromServerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fetchStatusDataFromServerButton setTitle:@"从服务器获取蓝牙状态数据" forState:UIControlStateNormal];
        [_fetchStatusDataFromServerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fetchStatusDataFromServerButton addTarget:self action:@selector(fetchStatusDataFromServer) forControlEvents:UIControlEventTouchUpInside];
        _fetchStatusDataFromServerButton.backgroundColor=[UIColor colorFromHexRGB:@"2E7BD3"];
        _fetchStatusDataFromServerButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        
    }
    return _fetchStatusDataFromServerButton;
}

- (void)setDevice:(HETDevice *)device
{
    _device = device;

    _macAddress = device.macAddress;
    _deviceType = device.deviceTypeId.integerValue;
    _deviceSubType = device.deviceSubtypeId.integerValue;
    _productId = device.productId.integerValue;
    _deviceId = device.deviceId;
}
@end
