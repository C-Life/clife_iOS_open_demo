//
//  HETWiFiDeviceH5ViewController.m
//  HETPublicSDK_HETH5DeviceControl
//
//  Created by mr.cao on 2018/3/30.
//  Copyright © 2018年 HET. All rights reserved.
//

#import "HETWiFiDeviceH5ViewController.h"

@interface HETWiFiDeviceH5ViewController ()

@end

@implementation HETWiFiDeviceH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view.

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.wifiBusiness start];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.wifiBusiness stop];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    if (self.wifiBusiness.deviceCfgData)
    {
        [self.jsBridge webViewUpdataControlData:self.wifiBusiness.deviceCfgData];
    }
}

-(void)config:(id)data
{
    [super config:data];
    if (self.wifiBusiness.deviceCfgData)
    {
        [self.jsBridge webViewUpdataControlData:self.wifiBusiness.deviceCfgData];
    }
}

-(void)send:(id)data successCallback:(id)successCallback errorCallback:(id)errorCallback
{
    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSError * err;
    NSData * tempjsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    NSString * json = [[NSString alloc] initWithData:tempjsonData encoding:NSUTF8StringEncoding];
    [self.wifiBusiness deviceControlRequestWithJson:json withSuccessBlock:^(id responseObject) {
        [self.jsBridge updateDataSuccess:nil successCallBlock:successCallback];
    } withFailBlock:^(NSError *error) {
        [self.jsBridge updateDataError:nil errorCallBlock:errorCallback];
    }];
}

#pragma mark - 懒加载
-(HETDeviceControlBusiness *)wifiBusiness
{
    if(!_wifiBusiness)
    {
        WEAKSELF;
        _wifiBusiness=[[HETDeviceControlBusiness alloc] initWithHetDeviceModel:self.deviceModel deviceRunData:^(id responseObject) {
            STRONGSELF;
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                [strongSelf.jsBridge webViewUpdataRunData:responseObject];
            }
        } deviceCfgData:^(id responseObject) {
            STRONGSELF;
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                [strongSelf.jsBridge webViewConfigDataRepaint:responseObject];
            }
        } deviceErrorData:^(id responseObject) {
            STRONGSELF;
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                [strongSelf.jsBridge webViewUpdataErrorData:responseObject];
            }
        } deviceState:^(HETWiFiDeviceState state) {
            STRONGSELF;
            [strongSelf.jsBridge webViewUpdataOnOffState:[NSString stringWithFormat:@"%ld",2-(long)state]];
        } failBlock:^(NSError *error) {
            OPLog(@"Got an error: %@", error);
        }];
    }
    return _wifiBusiness;
}

- (void)dealloc
{
    OPLog(@"%@ dealloc！！！",[self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
