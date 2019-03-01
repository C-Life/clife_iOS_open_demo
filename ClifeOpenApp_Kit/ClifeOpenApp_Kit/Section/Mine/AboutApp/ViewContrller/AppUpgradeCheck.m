//
//  AppDelegate+AppUpgrade.m
//  ClifeOpenApp_Kit
//
//  Created by YY on 2018/7/25.
//  Copyright © 2018年 het. All rights reserved.
//

#import "AppUpgradeCheck.h"

@implementation HETAPPInfoModel

@end 
@interface AppUpgradeCheck() <UIAlertViewDelegate>

@end

@implementation AppUpgradeCheck


+ (void)GetAppVersionInfo:(void(^)(HETAPPInfoModel *))HETAPPInfo{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app包名
    NSString *app_bundleId = [infoDictionary objectForKey:@"CFBundleIdentifier"];

    
    NSDictionary *params = @{@"appType":@2,@"appSign":app_bundleId};
    
    
    [HETDeviceRequestBusiness startRequestWithHTTPMethod:HETRequestMethodPost withRequestUrl:@"/v1/app/upgrade/get" processParams:params needSign:NO BlockWithSuccess:^(id responseObject) {
        OPLog(@"responseObject = %@",responseObject);

        if ([[responseObject allKeys] containsObject:@"data"]) {
            NSDictionary *dataDict = [responseObject valueForKey:@"data"];
            HETAPPInfoModel *appInfoModel = [HETAPPInfoModel mj_objectWithKeyValues:dataDict];
           
             if(HETAPPInfo){ HETAPPInfo(appInfoModel); }
        }
    } failure:^(NSError *error) {
        OPLog(@"error = %@",error);
        // 说明是最新
        if(HETAPPInfo){ HETAPPInfo(nil); }
        if (error.code == 100022707) {
            return ;
        }
      
    }];
}

+ (void)AppUpgradeCheck:(void (^)(HETAPPInfoModel *))HETAPPInfo
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    [self GetAppVersionInfo:^(HETAPPInfoModel *appInfoModel) {
        
        if(HETAPPInfo){ HETAPPInfo(appInfoModel); }
        
        
        NSInteger mainVersion = appInfoModel.mainVersion;
        NSString *externalVersion = appInfoModel.externalVersion;
        // app版本
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        // app build版本
        NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
        // 比较大版本
        if ([app_Version integerValue] > [externalVersion integerValue]) {
            OPLog(@"没有新的版本");
            return ;
        }
        // 比较build号
        if ([app_build integerValue] >= mainVersion) {
            OPLog(@"没有新的版本");
            return ;
        }
        
        [self showAlertWithAPPInfo:appInfoModel];
        
    }];
    
}

+ (void)showAlertWithAPPInfo:(HETAPPInfoModel *)appInfoModel
{
    UIAlertAction *alertActionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (appInfoModel.status == 1) {
                return;
            }
        
            NSURL *url = [NSURL URLWithString:appInfoModel.url];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            } else {
                // 否则使用 Mobile Safari 或者内嵌 WebView 来显示
                url = [NSURL URLWithString:appInfoModel.url];
                [[UIApplication sharedApplication] openURL:url];
            }
    }];
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"强制升级" message:appInfoModel.releaseNote preferredStyle:UIAlertControllerStyleAlert];
  
    if (appInfoModel.status == 2) {
        controller.title = @"强制升级";
        [controller addAction:alertActionOK];
    }else{
        controller.title = @"普通升级";
        [controller addAction:alertActionCancel];
        [controller addAction:alertActionOK];
    }
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:controller animated:true completion:nil];
}

#pragma mark - UIAlertView


@end
