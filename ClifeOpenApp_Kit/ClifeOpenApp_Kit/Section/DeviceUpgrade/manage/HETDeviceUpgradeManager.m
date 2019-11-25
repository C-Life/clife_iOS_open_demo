//
//  HETDeviceUpgradeManager.m
//  HETPublic
//
//  Created by tl on 15/8/17.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import "HETDeviceUpgradeManager.h"
#import "HETDeviceUpgradeController.h"
@interface HETDeviceUpgradeManager(){
    NSString *_deviceId;
    HETDeviceVersionModel *_versionModel;
}
@property (nonatomic,weak)HETDeviceUpgradeController *con;
@end
@implementation HETDeviceUpgradeManager
@synthesize upgradeSuccess = _upgradeSuccess;
@synthesize upgradeFailure = _upgradeFailure;


-(void)checkWithDeviceId:(NSString *)deviceId success:(void (^)(HETDeviceVersionModel *))checkSuccess{
    [self checkWithDeviceId:deviceId success:checkSuccess failure:nil];
}

-(void)checkWithDeviceId:(NSString *)deviceId success:(void (^)(HETDeviceVersionModel *))checkSuccess failure:(void (^)(NSError *))checkError{
    NSCAssert(deviceId, @"deviceId为空了");
    _deviceId = deviceId;
    
    [HETDeviceUpgradeBusiness deviceUpgradeCheckWithDeviceId:deviceId success:^(HETDeviceVersionModel *deviceVersionModel) {
        OPLog(@"deviceVersionModel:%@",deviceVersionModel);
        self-> _versionModel = deviceVersionModel;
        !checkSuccess?:checkSuccess(self->_versionModel);
    } failure:^(NSError *error) {
        OPLog(@"error:%@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
    }];
}

-(UIViewController *)upgradeVChandle:(id<HETDUProcessProtocol>)handle{
    HETDeviceUpgradeController *con = [HETDeviceUpgradeController new];
    con.viewModel = handle;
    @weakify(self);
    con.upgradeFailure = ^{
        @strongify(self);
        !self.upgradeFailure?:self.upgradeFailure();
    };
    con.upgradeSuccess = ^{
        @strongify(self);
        !self.upgradeSuccess?:self.upgradeSuccess();
    };
    self.con = con;
    return con;
}
-(void)refreshVChandle:(id<HETDUProcessProtocol>)handle{
    self.con.viewModel = handle;
}
@end
