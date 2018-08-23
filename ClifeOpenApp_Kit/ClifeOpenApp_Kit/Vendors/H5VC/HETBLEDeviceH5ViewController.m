//
//  HETBLEDeviceH5ViewController.m
//  HETPublicSDK_HETH5DeviceControl
//
//  Created by mr.cao on 2018/3/21.
//  Copyright © 2018年 HET. All rights reserved.
//

#import "HETBLEDeviceH5ViewController.h"

@interface HETBLEDeviceH5ViewController ()
{
    int lastBattery;
}

@end

@implementation HETBLEDeviceH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.customBLEDelegate)
    {
        return;
    }
    NSAssert(self.deviceModel.productId, @"Parameter 'productId' should not be nil");
    NSAssert(self.deviceModel.deviceTypeId, @"Parameter 'deviceType' should not be nil");
    NSAssert(self.deviceModel.deviceSubtypeId, @"Parameter 'deviceSubType' should not be nil");
    
    lastBattery=-1;
    
    [self.bleBusiness addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                          context:nil];
    [self.bleBusiness addObserver:self forKeyPath:@"managerState" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                          context:nil];
    self.bleBusiness.connectRetryTimes=3;
    self.bleBusiness.connectTimeoutInterval=5;
    
    @weakify(self);
    [_bleBusiness fetchStatusDataWithPeripheral:self.blePeripheral macAddress:self.deviceModel.macAddress deviceId:self.deviceModel.deviceId completionHandler:^(CBPeripheral *currentPeripheral,NSDictionary *dic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            self.blePeripheral=currentPeripheral;
            OPLog(@"状态数据:%@,%@",dic,error);
            if(dic)
            {
                [self.jsBridge webViewSendBLEStatusData:dic];
            }
        });
        
    }];
    [_bleBusiness fetchDeviceInfoCompletionHandler:^(CBPeripheral *currentPeripheral, NSDictionary *dic) {
        OPLog(@"设备信息:%@",dic);
        @strongify(self);
        if(dic[kHETBLE_BATTRY_LEVEL])
        {
            NSData *batteryData=dic[kHETBLE_BATTRY_LEVEL];
            int value = *(int*)([batteryData bytes]);
            if(value!=self->lastBattery)
            {
                self->lastBattery=value;
                OPLog(@"电池电量:%d",value);
                [self.jsBridge webViewSendBLEPower:[NSString stringWithFormat:@"%d",value]];
            }
            
        }
    }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(self.customBLEDelegate)
    {
        return;
    }
    [_bleBusiness removeObserver:self forKeyPath:@"state"];
    [_bleBusiness removeObserver:self forKeyPath:@"managerState"];
    
    [_bleBusiness disconnectWithPeripheral:_bleBusiness.currentPeripheral];
    _bleBusiness.scanDelegate=nil;
    _bleBusiness=nil;
    
}
#pragma 蓝牙扫描代理
-(NSArray *)servicesUUID
{
    return nil;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    //OPLog(@"子类KVO:%@,%@,%@,%@",keyPath,object,change,context);
    
    if ([keyPath isEqualToString:@"state"]) {
        // OPLog(@"%@", change);
        [self.jsBridge webViewSendBLEStateType:[NSString stringWithFormat:@"%@",[change valueForKey:@"new"]]];
    }
    else if([keyPath isEqualToString:@"managerState"])
    {
    }
    else
    {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
        
    }
}

//- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
//
//    [super webView:webView didFinishNavigation:navigation];
//
//    if (self.bleBusiness.state)
//    {
//        [self.jsBridge webViewSendBLEStateType:[NSString stringWithFormat:@"%ld",(long)self.bleBusiness.state]];
//    }
//
//}

#pragma mark

- (NSString *)dataToHexString:(NSData *)data
{
    const unsigned char *bytes = [data bytes];
    NSMutableString *string = [NSMutableString stringWithCapacity:(data.length*2)];
    for (int loop=0; loop<(data.length); loop++) {
        [string appendFormat:@"%02X", *bytes];
        bytes++;
    }
    return (string);
}





-(void)deviceControlAction:(NSDictionary *)dic
{
    @weakify(self);
    [_bleBusiness deviceControlRequestWithPeripheral:self.blePeripheral macAddress:self.deviceModel.macAddress sendDic:dic completionHandler:^(CBPeripheral *currentPeripheral,NSError *error) {
        @strongify(self);
        self.blePeripheral=currentPeripheral;
        OPLog(@"数据发送回调:%@",error);
        
        
    }];
    
}



-(void)mcuUpgradeAction
{
    
    /*
     @weakify(self);
     //获取最新版本
     HETDeviceUpgradeCheckRequest *request=[[HETDeviceUpgradeCheckRequest alloc]initWithAccessToken:[HETUserInfo userInfo].accessToken version1_1DeviceId:self.deviceId];
     [request startWithSuccessBlockDictionaryParameter:^(NSDictionary *dictValue) {
     
     HETDeviceVersionsModel *deviceVersionModel=[[HETDeviceVersionsModel alloc]init];
     deviceVersionModel.deviceVersionId=dictValue[@"deviceVersionId"];
     deviceVersionModel.oldDeviceVersion=dictValue[@"oldDeviceVersion"];
     deviceVersionModel.filePath=dictValue[@"filePath"];
     deviceVersionModel.deviceBleFirmId=dictValue[@"deviceBleFirmId"];
     deviceVersionModel.releaseNote=dictValue[@"releaseNote"];
     deviceVersionModel.deviceVersionId=dictValue[@"deviceVersionId"];
     deviceVersionModel.newDeviceVersion=dictValue[@"newDeviceVersion"];
     
     if(deviceVersionModel.newDeviceVersion&&![deviceVersionModel.newDeviceVersion isEqualToString:deviceVersionModel.oldDeviceVersion])//有新固件
     {
     
     
     [_bleBusiness mcuUpgrade:self.blePeripheral macAddress:self.macAddress  deviceId:self.deviceId deviceVersionModel:deviceVersionModel progress:^(float progress) {
     //升级进度
     
     
     } completionHandler:^(CBPeripheral *currentPeripheral,NSError *error) {
     @strongify(self);
     
     
     }];
     
     }else{
     
     }
     
     } failure:^(NSError *error, NSInteger statusCode) {
     
     @strongify(self);
     OPLog(@"获取硬件版本信息错误:%@",error);
     
     
     }];*/
    
    
}

-(void)bindAction
{
    //WEAKSELF;
    
    [_bleBusiness bindBleDeviceWithPeripheral: self.blePeripheral macAddress:self.deviceModel.macAddress completionHandler:^(NSString *deviceId, NSError *error) {
        if(error)
        {
            
        }
        else
        {
            
        }
    }];
    
    
    
}



#pragma 蓝牙js的实现
-(void)config:(id)data
{
    [super config:data];
    if(!self.customBLEDelegate)
    {
        [self.jsBridge webViewSendBLEStateType:[NSString stringWithFormat:@"%ld",(long)self.bleBusiness.state]];
    }
    
}
-(void)getBLERealTimeDataWithSuccessCallbackId:(id)successCallbackId failCallbackId:(id)failCallbackId
{
    @weakify(self);
    if(self.customBLEDelegate&&[self.customBLEDelegate respondsToSelector:@selector(fetchBLERealTimeDataWithSuccessBlock:failBlock:)])
    {
        [self.customBLEDelegate fetchBLERealTimeDataWithSuccessBlock:^(id responseObject) {
            @strongify(self);
            [self.jsBridge webViewGetBLERealTimeDataResponse:responseObject callBackId:successCallbackId];
        } failBlock:^(NSError *error) {
            @strongify(self);
            [self.jsBridge webViewGetBLERealTimeDataResponse:@{@"data": @{
                                                                       @"error":error.description
                                                                       }} callBackId:failCallbackId];
        }];
        return;
    }
    // [self.jsBridge webViewSendBLEStateType:[NSString stringWithFormat:@"%ld",(long)self.bleBusiness.state]];
    [_bleBusiness fetchRealTimeDataWithPeripheral:self.blePeripheral macAddress:self.deviceModel.macAddress deviceId:self.deviceModel.deviceId completionHandler:^(CBPeripheral *currentPeripheral,NSDictionary *dic, NSError *error) {
        @strongify(self);
        self.blePeripheral=currentPeripheral;
        OPLog(@"实时数据回调:%@,%@",dic,error);
        if(dic)
        {
            [self.jsBridge webViewGetBLERealTimeDataResponse:dic callBackId:successCallbackId];
        }
        else
        {
            [self.jsBridge webViewGetBLERealTimeDataResponse:@{@"data": @{
                                                                       @"error":error.description
                                                                       }} callBackId:failCallbackId];
        }
        
    }];
}
-(void)getBLETimeDataWithSuccessCallbackId:(id)successCallbackId failCallbackId:(id)failCallbackId
{
    @weakify(self);
    
    [_bleBusiness getTimeWithPeripheral:self.blePeripheral macAddress:self.deviceModel.macAddress completionHandler:^(CBPeripheral *currentPeripheral,NSData *data, NSError *error) {
        @strongify(self);
        self.blePeripheral=currentPeripheral;
        OPLog(@"获取时间数据回调:%@,%@",data,error);
        if(error)
        {
            [self.jsBridge webViewGetBLETimeDataResponse:nil callBackId:failCallbackId];
        }
        else
        {
            [self.jsBridge webViewGetBLETimeDataResponse:[self nsdataToHexString:data] callBackId:failCallbackId];
        }
        
        
    }];
}
-(void)getBLEHistoryDataWithSuccessCallbackId:(id)successCallbackId failCallbackId:(id)failCallbackId progressCallbackId:(id)progressCallbackId
{
    @weakify(self);
    
    if(self.customBLEDelegate&&[self.customBLEDelegate respondsToSelector:@selector(fetchBLEHistoryTimeDataWithSuccessBlock:failBlock:progress:)])
    {
        [self.customBLEDelegate fetchBLEHistoryTimeDataWithSuccessBlock:^{
            [self.jsBridge webViewGetBLEHistoryDataResponse:nil callBackId:successCallbackId];
        } failBlock:^(NSError *error) {
            [self.jsBridge webViewGetBLEHistoryDataResponse:@{@"data": @{
                                                                      @"error":error.description
                                                                      }} callBackId:failCallbackId];
        } progress:^(NSUInteger progress) {
            [self.jsBridge webViewGetBLEHistoryDataResponse:@{@"data": @{
                                                                      @"progress":@(progress)// 升级的进度，代表升级到10%
                                                                      }} callBackId:progressCallbackId];
        }];
        
        return;
    }
    //[self.jsBridge webViewSendBLEStateType:[NSString stringWithFormat:@"%ld",(long)self.bleBusiness.state]];
    [_bleBusiness fetchHistoryDataWithPeripheral:self.blePeripheral macAddress:self.deviceModel.macAddress deviceId:self.deviceModel.deviceId progress:^(UInt16 currentFrame, UInt16 totalFrame, NSData *data) {
        OPLog(@"历史数据当前的帧数:%d,总帧数:%d,当前数据帧:%@",currentFrame,totalFrame,data);
        [self.jsBridge webViewGetBLEHistoryDataResponse:@{@"data": @{
                                                                  @"progress":@(currentFrame*100/totalFrame)// 升级的进度，代表升级到10%
                                                                  }} callBackId:progressCallbackId];
        
    } completionHandler:^(CBPeripheral *currentPeripheral,NSData *data, NSError *error) {
        @strongify(self);
        self.blePeripheral=currentPeripheral;
        OPLog(@"获取历史数据:%@,%@，%ld",data,error,(unsigned long)data.length);
        if(error)
        {
            [self.jsBridge webViewGetBLEHistoryDataResponse:@{@"data": @{
                                                                      @"error":error.description
                                                                      }} callBackId:failCallbackId];
        }
        else
        {
            
            @weakify(self);
            
            [_bleBusiness clearHistoryDataWithPeripheral:self.blePeripheral macAddress:self.deviceModel.macAddress completionHandler:^(CBPeripheral *currentPeripheral,NSError *error) {
                @strongify(self);
                self.blePeripheral=currentPeripheral;
                OPLog(@"清除历史数据回调:%@",error);
                [self.jsBridge webViewGetBLEHistoryDataResponse:nil callBackId:successCallbackId];
                
            }];
        }
        
        
    }];
}
-(void)getDeviceMcuUpgradeWithSuccessCallbackId:(id)successCallbackId failCallbackId:(id)failCallbackId progressCallbackId:(id)progressCallbackId
{
    
}
-(void)setBLETimeDataWithSuccessCallbackId:(id)successCallbackId failCallbackId:(id)failCallbackId
{
    @weakify(self);
    [_bleBusiness setTimeWithPeripheral:self.blePeripheral macAddress:self.deviceModel.macAddress timeType:HETBLECSTTime completionHandler:^(CBPeripheral *currentPeripheral,NSData *data, NSError *error) {
        @strongify(self);
        self.blePeripheral=currentPeripheral;
        OPLog(@"设置时间数据数据回调:%@,%@",data,error);
        if(error)
        {
            [self.jsBridge webViewSetBLETimeDataResponse:nil callBackId:failCallbackId];
        }
        else
        {
            [self.jsBridge webViewSetBLETimeDataResponse:@"1" callBackId:successCallbackId];
            
        }
        
    }];
}
-(void)send:(id)data successCallback:(id)successCallback errorCallback:(id)errorCallback
{
    if (data && ![data isEqualToString:@" "]) {
    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    @weakify(self);
    [_bleBusiness deviceControlRequestWithPeripheral:self.blePeripheral macAddress:self.deviceModel.macAddress sendDic:dic completionHandler:^(CBPeripheral *currentPeripheral,NSError *error) {
        @strongify(self);
        self.blePeripheral=currentPeripheral;
        OPLog(@"数据发送回调:%@",error);
        if(error)
        {
            [self.jsBridge updateDataError:@{@"data": @{
                                                     @"error":error.description
                                                     }} errorCallBlock:errorCallback];
        }
        else
        {
            [self.jsBridge updateDataSuccess:dic successCallBlock:successCallback];
        }
        
    }];
    }
    else
    {
        [self.jsBridge updateDataError:nil errorCallBlock:errorCallback];
    }
    
}
-(NSString *) nsdataToHexString: (NSData *) data {
    
    if (data==nil)
        return (@"");
    
    const unsigned char *bytes = [data bytes];
    NSMutableString *string = [NSMutableString stringWithCapacity:(data.length*2)];
    for (int loop=0; loop<(data.length); loop++) {
        [string appendFormat:@"%02X", *bytes];
        bytes++;
    }
    return (string);
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(HETBLEBusiness*)bleBusiness
{
    if(!_bleBusiness)
    {
        _bleBusiness=[[HETBLEBusiness alloc]initWithProductId:self.deviceModel.productId.intValue deviceTypeId:self.deviceModel.deviceTypeId.integerValue deviceSubtypeId:self.deviceModel.deviceSubtypeId.integerValue];
    }
    return _bleBusiness;
}
@end
