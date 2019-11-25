//
//  HETDeviceUpgradeProtocol.h
//  HETPublic
//
//  Created by tl on 15/8/17.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HETDUProcessProtocol.h"
@protocol HETDeviceUpgradeProtocol <NSObject>

/**
 *  检查版本
 *
 *  @param deviceId     设备ID   （必须填）
 *  @param checkSuccess 当检查成功 返回一个HETDeviceVersionModel，里面包含版本信息
 */
-(void)checkWithDeviceId:(NSString *)deviceId success:(void (^)(HETDeviceVersionModel *versionModel))checkSuccess;

/**
 *  检查版本
 *
 *  @param deviceId     设备ID   （必须填）
 *  @param checkSuccess 当检查成功 返回一个HETDeviceVersionModel，里面包含版本信息
 *  @param checkError 网络请求失败
 */
-(void)checkWithDeviceId:(NSString *)deviceId success:(void (^)(HETDeviceVersionModel *versionModel))checkSuccess failure:(void (^)(NSError *error))checkError;

/**
 *  获取升级页面
 *
 *  公共模块升级处理逻辑：只负责提供UI部分，各个项目中升级处理需自行实现升级逻辑，必须实现HETDUProcessProtocol。
 *
 *  如果一头雾水的话，项目中也有提供HETDUBaseWifiHandle 和 HETDUBaseBleHandle 基础升级逻辑，可以根据需求继承重写或者仿写。
 *
 *  ps:为啥这么写？由于各个项目升级固件处理方式有可能会有细微的区别，所以我只想到了统一好UI样式，逻辑自己写（我也提供一套基本的）
 */

-(UIViewController *)upgradeVChandle:(id<HETDUProcessProtocol>)handle;

/**
 *  刷新当前升级页面的逻辑处理（由于存在单个设备有多个固件需要升级）
 */
-(void)refreshVChandle:(id<HETDUProcessProtocol>)handle;

/**
 *  升级成功
 */
@property (nonatomic,copy)void (^upgradeSuccess)();
/**
 *  升级失败
 */
@property (nonatomic,copy)void (^upgradeFailure)();
@end
