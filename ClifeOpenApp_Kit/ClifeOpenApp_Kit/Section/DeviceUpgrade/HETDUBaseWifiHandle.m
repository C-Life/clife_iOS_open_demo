//
//  HETDUBaseWifi.m
//  HETPublicSDK_DeviceUpgrade
//
//  Created by tl on 16/5/17.
//  Copyright © 2016年 HET. All rights reserved.
//

#import "HETDUBaseWifiHandle.h"
#import "HETDUResource.h"
@implementation HETDUBaseWifiHandle

@synthesize tipMsg = _tipMsg;
@synthesize progress = _progress;
@synthesize upgradeFailure = _upgradeFailure;
@synthesize upgradeSuccess = _upgradeSuccess;
@synthesize deviceInfo = _deviceInfo;
@synthesize versionModel = _versionModel;

+(instancetype)deviceInfo:(HETDevice *)deviceInfo version:(HETDeviceVersionModel *)versionModel{
    HETDUBaseWifiHandle *wifi = [self new];
    wifi.deviceInfo = deviceInfo;
    wifi.versionModel = versionModel;
    return wifi;
}

-(void)upgrade{
    _checkProgressFailCount = 0;
    self.progress = 0.f;
    [self confimRequest];
}

/**
 *  确认设备升级
 *  eviceId 设备标识
 *  deviceVersionType 设备版本类型（1-WIFI，2-PCB（目前蓝牙设备、wifi设备都只升级pcb）,3-蓝牙模块升级）
 *  deviceVersionModel 设备版本类
 */
-(void)confimRequest{
    @weakify(self);
    [HETDeviceUpgradeBusiness  deviceUpgradeConfirmWithDeviceId:self.deviceInfo.deviceId deviceVersionType:@"2" deviceVersionModel:self.versionModel success:^(id responseObject) {
        OPLog(@"确认升级");
        @strongify(self);
        self-> _getProgressTime = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getUpgradeProgress) userInfo:nil repeats:YES];
    } failure:^(NSError *error) {
        OPLog(@"error:%@",error);
        self.tipMsg =[error.userInfo objectForKey:@"NSLocalizedDescription"];
        [self failure];
    }];
}

-(void)getUpgradeProgress{
    @weakify(self);
    [HETDeviceUpgradeBusiness fetchDeviceUpgradeProgress:self.deviceInfo.deviceId deviceVersionModel:self.versionModel success:^(id responseObject) {
        @strongify(self);
        OPLog(@"%@",responseObject);
        NSInteger upgradeStatus = [responseObject[@"upgradeStatus"] integerValue];
        if (upgradeStatus  == 2) {
            self.progress = 1.f;
            [self success];
            return;
        }else if(upgradeStatus == 3){
            self.tipMsg =HETDULocalizedString(@"升级失败");
            [self failure];
            return;
        }else if(upgradeStatus == 5){
            self.progress = self.progress+0.1f>1.f?1.f:self.progress+0.1f;
            return;
        }
        self.progress = [responseObject[@"progress"] integerValue]/100.*0.85;
    } failure:^(NSError *error) {
        @strongify(self);
        self->  _checkProgressFailCount++;
        if (self->_checkProgressFailCount > 60) {
            self.tipMsg =HETDULocalizedString(@"升级失败");
            [self failure];
        }
        if (error.code == 100022006) {//设备不在线直接退回
            self.tipMsg =[error.userInfo objectForKey:@"NSLocalizedDescription"];
            [self failure];
        }
       OPLog(@"error:%@",error);
    }];
}

/**
 *  在升级过程中lebal的提示文字
 *
 *  @param index    第几行的label
 *  @param timeLine 时间节点：0：预升级 1：升级成功 2：升级中  3：升级失败
 */
-(NSString*)titleAtIndex:(NSInteger)index timeLine:(NSInteger)timeLine{
    NSArray *titleArray = @[@[HETDULocalizedString(@"固件升级"),HETDULocalizedString(@"检测到新版本，快去更新吧！"),@" "],
                            @[HETDULocalizedString(@"升级成功"),HETDULocalizedString(@"升级完成，快去体验吧！"),@" "],
                            @[HETDULocalizedString(@"固件升级"),HETDULocalizedString(@"固件升级中，请稍候！"),@" "],
                            @[HETDULocalizedString(@"升级失败"),HETDULocalizedString(@"升级失败，请重新升级！"),@" "]];
    return titleArray[timeLine][index];
}
-(UIColor *)progressColor{
    return nil;
}
#pragma mark --- 结果
-(void)failure{
    [_getProgressTime invalidate];
    _getProgressTime = nil;
    !self.upgradeFailure?:self.upgradeFailure();
}
-(void)success{
    [_getProgressTime invalidate];
    _getProgressTime = nil;
    //切换到成功页面
    !self.upgradeSuccess?:self.upgradeSuccess();
    self.tipMsg = HETDULocalizedString(@"升级成功");
}
@end
