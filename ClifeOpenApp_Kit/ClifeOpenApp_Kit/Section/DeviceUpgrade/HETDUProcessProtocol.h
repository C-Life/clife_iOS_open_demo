//
//  HETDUProcessProtocol.h
//  HETPublicSDK_DeviceUpgrade
//
//  Created by tl on 16/5/17.
//  Copyright © 2016年 HET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol HETDUProcessProtocol <NSObject>

#pragma 以下方法需实现和赋值
/**
 *  指定初始化方式
 *
 *  @param deviceInfo 设备信息
 *  @param versionModel      固件升级信息
 */
+(instancetype)deviceInfo:(HETDevice *)deviceInfo version:(HETDeviceVersionModel *)versionModel;

/**
 *  提示信息(需要页面进行错误提示或者遮挡框提示时，赋值即可)
 */
@property (nonatomic,copy)NSString *tipMsg;

/**
 *  升级进度（controller会对其进行kvo，赋值即可）
 */
@property (nonatomic,assign)CGFloat progress;

/**
 *  检测到版本信息的内容，包含新旧版本，蓝牙文件下载地址
 */
@property (nonatomic,strong)HETDeviceVersionModel *versionModel;
/**
 *  设备信息
 */
@property (nonatomic,strong) HETDevice *deviceInfo;

/**
 *  开始升级
 */
-(void)upgrade;

/**
 *  在升级过程中lebal的提示文字,默认文字请调用super（如果继承的话）
 *
 *  @param index    第几行的label
 *  @param timeLine 时间节点：0：预升级 1：升级成功 2：升级中  3：升级失败
 */
-(NSString *)titleAtIndex:(NSInteger)index timeLine:(NSInteger)timeLine;

//升级进度条的颜色
-(UIColor *)progressColor;

#pragma 下面两个block调用即可，不用赋值
/**
 *  升级成功
 */
@property (nonatomic,copy)void (^upgradeSuccess)();

/**
 *  升级失败
 */
@property (nonatomic,copy)void (^upgradeFailure)();
@end
