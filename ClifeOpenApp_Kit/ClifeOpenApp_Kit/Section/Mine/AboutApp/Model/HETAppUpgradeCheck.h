//
//  AppDelegate+AppUpgrade.h
//  ClifeOpenApp_Kit
//
//  Created by YY on 2018/7/25.
//  Copyright © 2018年 het. All rights reserved.
//

#import "AppDelegate.h"

@interface HETAPPInfoModel : NSObject
/** APP名称 **/
@property (nonatomic,copy) NSString                                        *appName;
/** APP包名 **/
@property (nonatomic,copy) NSString                                        *appPackage;
/** APP标识 **/
@property (nonatomic,copy) NSString                                        *appSign;
/** 外部版本 **/
@property (nonatomic,copy) NSString                                        *externalVersion;
/** 文件MD5 **/
@property (nonatomic,strong) NSNumber                                      *fileMd5;
/** 内部版本 **/
@property (nonatomic,assign) NSInteger                                     mainVersion;
/** 升级描述 **/
@property (nonatomic,copy) NSString                                        *releaseNote;
/** 设备数组 **/
@property (nonatomic,assign) NSInteger                                     status;
/** 附件链接 **/
@property (nonatomic,copy) NSString                                        *url;

@end

@interface HETAppUpgradeCheck : NSObject

//获取App版本信息
+ (void)GetAppVersionInfo:(void(^)(HETAPPInfoModel *))HETAPPInfo;

//被动、默认检查app升级
+ (void)AppUpgradeCheck:(void(^)(HETAPPInfoModel *))HETAPPInfo;

//主动、手动检查app升级
+ (void)activeAppUpgradeCheck:(void(^)(HETAPPInfoModel *))HETAPPInfo;

@end


