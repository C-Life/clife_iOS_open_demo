//
//  HETZigbeeDeviceH5ViewController.m
//  HETPublicSDK_H5ContainerVC
//
//  Created by mr.cao on 2018/4/25.
//  Copyright © 2018年 mr.cao. All rights reserved.
//

#import "HETZigbeeDeviceH5ViewController.h"

@interface HETZigbeeDeviceH5ViewController()
{
    
}
@property(nonatomic,assign) HETWiFiDeviceState currentDeviceState;
@property(nonatomic,strong) NSDictionary *currentDeviceRunData;
@property(nonatomic,strong) NSDictionary *currentDeviceCfgData;
@end

@implementation HETZigbeeDeviceH5ViewController

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
    NSAssert(self.deviceModel.userKey, @"Parameter 'userKey' should not be nil");
    NSAssert(self.deviceModel.productId, @"Parameter 'productId' should not be nil");
    NSAssert(self.deviceModel.deviceTypeId, @"Parameter 'deviceTypeId' should not be nil");
    NSAssert(self.deviceModel.deviceSubtypeId, @"Parameter 'deviceSubtypeId' should not be nil");
    NSAssert(self.deviceModel.macAddress, @"Parameter 'macAddress' should not be nil");
    [self.wifiBusiness start];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_wifiBusiness stop];
    _wifiBusiness=nil;
    
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [super webView:webView didFinishNavigation:navigation];
    [self renderData];
    
}
-(void)renderData
{
    if (self.wifiBusiness.deviceDefaultCfgData.count)
    {
        [self.jsBridge webViewUpdataControlData:self.wifiBusiness.deviceDefaultCfgData];
    }
    if (_currentDeviceCfgData.count)
    {
        [self.jsBridge webViewUpdataControlData:_currentDeviceCfgData];
    }
    if (_currentDeviceRunData.count)
    {
        [self.jsBridge webViewUpdataRunData:_currentDeviceRunData];
    }
    if(_currentDeviceState)
    {
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.jsBridge webViewUpdataOnOffState:[NSString stringWithFormat:@"%ld",2-(long)_currentDeviceState]];
        // });
    }
}
-(void)config:(id)data
{
    [super config:data];
    [self renderData];
}

-(void)send:(id)data successCallback:(id)successCallback errorCallback:(id)errorCallback
{
    
    if (data && ![data isEqualToString:@" "]) {
        NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSError * err;
        NSData * tempjsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
        NSString * json = [[NSString alloc] initWithData:tempjsonData encoding:NSUTF8StringEncoding];
        NSLog(@"发送命令json ====== %@",json);
        WEAKSELF;
        [_wifiBusiness deviceControlRequestWithJson:json successBlock:^(id responseObject) {
            STRONGSELF;
            [strongSelf.jsBridge updateDataSuccess:nil successCallBlock:successCallback];
        } failureBlock:^(NSError *error) {
            STRONGSELF;
            NSLog(@"发送命令json失败原因 ====%@",error);
            [strongSelf.jsBridge updateDataError:nil errorCallBlock:errorCallback];
        }];
    }
    else
    {
        [self.jsBridge updateDataError:nil errorCallBlock:errorCallback];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(HETDeviceControlBusiness *)wifiBusiness
{
    if(!_wifiBusiness)
    {
        WEAKSELF;
        _wifiBusiness=[[HETDeviceControlBusiness alloc] initWithHetDeviceModel:self.deviceModel deviceRunData:^(id responseObject) {
            STRONGSELF;
            NSLog(@"获取运行数据");
            NSLog(@"responseObject ==== %@",responseObject);
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                if (strongSelf.deviceModel.moduleId.integerValue == 190 ) {// zigbee3.0
                    strongSelf.currentDeviceRunData= responseObject;
                    if(strongSelf.currentDeviceRunData.count)
                    {
                        [strongSelf.jsBridge webViewUpdataRunData:responseObject];
                    }
                }else{
                    strongSelf.currentDeviceCfgData=responseObject;
                    if(strongSelf.currentDeviceCfgData.count)
                    {
                        [strongSelf.jsBridge webViewUpdataControlData:responseObject];// zigbee2.0 运行数据走控制数据通道
                    }
                }
            }
        } deviceCfgData:^(id responseObject) {
            STRONGSELF;
            NSLog(@"获取控制数据");
            NSLog(@"responseObject ==== %@",responseObject);
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                strongSelf.currentDeviceCfgData=responseObject;
                if(strongSelf.currentDeviceCfgData.count)
                {
                    [strongSelf.jsBridge webViewUpdataControlData:responseObject];
                }
            }
        } deviceErrorData:^(id responseObject) {
            STRONGSELF;
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic=responseObject;
                if(dic.count)
                {
                    [strongSelf.jsBridge webViewUpdataErrorData:responseObject];
                }
            }
        } deviceState:^(HETWiFiDeviceState state) {
            STRONGSELF;
            strongSelf.currentDeviceState=state;
            [strongSelf.jsBridge webViewUpdataOnOffState:[NSString stringWithFormat:@"%ld",2-(long)state]];
            
        } failBlock:^(NSError *error) {
            
        }];
    }
    return _wifiBusiness;
}

- (void)dealloc
{
    OPLog(@"%@ dealloc！！！",[self class]);
}
@end
