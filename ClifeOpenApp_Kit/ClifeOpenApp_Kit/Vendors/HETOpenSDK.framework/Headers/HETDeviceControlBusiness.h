//
//  HETDeviceControlBusiness.h
//  HETOpenSDK
//
//  Created by mr.cao on 15/8/13.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "HETDevice.h"
#import "HETNetWorkRequestHeader.h"

@interface HETDeviceControlBusiness : NSObject

//当前是否小循环
@property (nonatomic,readonly ) BOOL        isLittleLoop;
///是否需要回复,针对F241老协议的
@property (nonatomic,assign) BOOL needReplay;
///设置小循环数据发送最大次数，默认发送10次
@property (nonatomic,assign) NSUInteger  packetSendTimes;
///设置小循环数据包重发的间隔时间，默认一秒发送一次
@property (nonatomic,assign) NSTimeInterval  packetSendTimeInterval;
///设置是否需要开启下发控制数据后屏蔽5s内的数据（不上传给业务层,默认是不开启此策略)
@property(nonatomic,assign) BOOL startRefreshAfterContol;
///设置开启下发控制数据后屏蔽数据的时间间隔，默认5秒
@property (nonatomic,assign) NSTimeInterval startRefreshAfterContolTimeInterval;
///协议解析出来的默认控制数据
@property (nonatomic,readonly) NSDictionary *deviceDefaultCfgData;

/**
 *
 *
 *  @param device                设备的对象
 *  @param runDataBlock          设备运行数据block回调
 *  @param cfgDataBlock          设备控制数据block回调
 *  @param errorDataBlock        设备故障数据block回调
 *  @param deviceStateBlock            设备在线状态block回调
 *  @param failureBlock          获取设备数据失败block回调
 */
- (instancetype)initWithHetDeviceModel:(HETDevice *)device
                         deviceRunData:(HETDeviceRunDataBlock)runDataBlock
                         deviceCfgData:(HETDeviceConfigDataBlock)cfgDataBlock
                       deviceErrorData:(HETDeviceErrorDataBlock)errorDataBlock
                           deviceState:(HETWifiDeviceStateBlock)deviceStateBlock
                             failBlock:(HETFailureBlock)failureBlock;


/**
 *  设备控制
 *
 *  @param jsonString   设备控制的json字符串
 *  @param successBlock 控制成功的回调
 *  @param failureBlock 控制失败的回调
 */
- (void)deviceControlRequestWithJson:(NSString *)jsonString
                    successBlock:(HETSuccessBlock)successBlock
                    failureBlock:(HETFailureBlock)failureBlock;


/**
 *  离线下发设备控制(适用于NBIoT设备)
 *
 *  @param jsonString   设备控制的json字符串
 *  @param successBlock 控制成功的回调
 *  @param failureBlock 控制失败的回调
 */
- (void)offlineDeviceControlRequestWithJson:(NSString *)jsonString
                               successBlock:(HETSuccessBlock)successBlock
                               failureBlock:(HETFailureBlock)failureBlock;

//启动服务
- (void)start;

//停止服务
- (void)stop;

//是否支持小循环，默认支持小循环（YES支持小循环,NO不支持小循环),默认是支持小循环
- (void)setSupportLittleLoop:(BOOL)support;

@end





