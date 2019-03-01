//
//  HETWiFiDeviceH5ViewController.m
//  HETPublicSDK_HETH5DeviceControl
//
//  Created by mr.cao on 2018/3/30.
//  Copyright © 2018年 HET. All rights reserved.
//

#import "HETWiFiDeviceH5ViewController.h"

@interface HETWiFiDeviceH5ViewController ()
{
   
}
@property(nonatomic,assign) HETWiFiDeviceState currentDeviceState;
@property(nonatomic,strong) NSDictionary *currentDeviceRunData;
@property(nonatomic,strong) NSDictionary *currentDeviceCfgData;
@end

@implementation HETWiFiDeviceH5ViewController

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
    NSAssert(self.deviceModel.deviceTypeId, @"Parameter 'deviceType' should not be nil");
    NSAssert(self.deviceModel.deviceSubtypeId, @"Parameter 'deviceSubType' should not be nil");
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
    //});
    }
}

-(void)config:(id)data
{
    [super config:data];
    if (self.wifiBusiness.deviceDefaultCfgData.count)
    {
         [self.jsBridge webViewUpdataControlData:self.wifiBusiness.deviceDefaultCfgData];
    }
}

-(void)send:(id)data successCallback:(id)successCallback errorCallback:(id)errorCallback
{
    NSLog(@"web send -------");
    if (data && ![data isEqualToString:@" "]) {
    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSError * err;
    NSData * tempjsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    NSString * json = [[NSString alloc] initWithData:tempjsonData encoding:NSUTF8StringEncoding];
    WEAKSELF;
        [_wifiBusiness deviceControlRequestWithJson:json successBlock:^(id responseObject) {
            STRONGSELF;
            [strongSelf.jsBridge updateDataSuccess:nil successCallBlock:successCallback];
        } failureBlock:^(NSError *error) {
            STRONGSELF;
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
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:responseObject];
                [dic removeObjectForKey:@"updateTime"];
                [dic removeObjectForKey:@"userId"];
                strongSelf.currentDeviceRunData=dic;
                [strongSelf.jsBridge webViewUpdataRunData:dic];
            }
        } deviceCfgData:^(id responseObject) {
            STRONGSELF;
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:responseObject];
                [dic removeObjectForKey:@"updateTime"];
                [dic removeObjectForKey:@"userId"];
                 strongSelf.currentDeviceCfgData=dic;
             [strongSelf.jsBridge webViewUpdataControlData:dic];
            }
        } deviceErrorData:^(id responseObject) {
            STRONGSELF;
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                [strongSelf.jsBridge webViewUpdataErrorData:responseObject];
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
@end
