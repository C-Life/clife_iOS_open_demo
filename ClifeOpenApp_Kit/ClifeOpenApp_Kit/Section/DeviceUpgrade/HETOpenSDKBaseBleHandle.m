//
//  HETOpenSDKBaseBleHandle.m
//  HETPublicSDK_DeviceUpgrade
//
//  Created by mr.cao on 2018/2/8.
//  Copyright © 2018年 HET. All rights reserved.
//

#import "HETOpenSDKBaseBleHandle.h"
#import "HETDUResource.h"

@implementation HETOpenSDKBaseBleHandle

@synthesize tipMsg = _tipMsg;
@synthesize progress = _progress;
@synthesize upgradeFailure = _upgradeFailure;
@synthesize upgradeSuccess = _upgradeSuccess;
@synthesize deviceInfo = _deviceInfo;
@synthesize versionModel = _versionModel;

+(instancetype)deviceInfo:(HETDevice *)deviceInfo version:(HETDeviceVersionModel *)versionModel{
    HETOpenSDKBaseBleHandle *ble = [self new];
    ble.deviceInfo = deviceInfo;
    ble.versionModel = versionModel;
    return ble;
}

-(void)upgrade{
    self.progress = 0.f;
    [self confirmUpgrade];
    
}

-(void)dealloc{
    _bleHandle=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark --- 结果
-(void)failureWithMsg:(NSString *)msg{
    !self.upgradeFailure?:self.upgradeFailure();
}

-(void(^)())success{
    return ^void (){
        //切换到成功页面
        !self.upgradeSuccess?:self.upgradeSuccess();
        self.tipMsg = HETDULocalizedString(@"升级成功");
    };
}

/**
 *  3.获取蓝牙固件升级确认
 *
 *  @param prox 需要获取的proximity
 */
- (void)confirmUpgrade {
    
    @weakify(self);
    [HETDeviceUpgradeBusiness  deviceUpgradeConfirmWithDeviceId:self.deviceInfo.deviceId deviceVersionType:@"2" deviceVersionModel:self.versionModel success:^(id responseObject) {
        OPLog(@"确认升级");
    } failure:^(NSError *error) {
        OPLog(@"error:%@",error);
    }];
    
    if(!_bleHandle)
    {
        _bleHandle=[[HETBLEBusiness alloc]initWithProductId:self.deviceInfo.productId.integerValue deviceTypeId:self.deviceInfo.deviceTypeId.integerValue deviceSubtypeId:self.deviceInfo.deviceSubtypeId.integerValue];
    }
    
    [_bleHandle mcuUpgrade:nil macAddress:self.deviceInfo.macAddress deviceId:self.deviceInfo.deviceId deviceVersionModel:self.versionModel progress:^(float progress) {
        @strongify(self);
        self.progress = progress;
        if ((progress-1)>=0.000000001) {
            
        }
    } completionHandler:^(CBPeripheral *currentPeripheral, NSError *error) {
        @strongify(self);
        if (error) {
            OPLog(@"固件升级失败 error = %@",error);
            [self failureWithMsg:HETDULocalizedString(@"固件升级失败,请重试!")];
        }
        else
        {
            [self->_bleHandle disconnectWithPeripheral:currentPeripheral];
            [self updateSuccess:[self success]];
        }
    }];
}


-(void)updateSuccess:(void (^)())successBlock{
    !successBlock?:successBlock();
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

@end

