//
//  HETDeviceControlBusiness.h
//  HETOpenSDK
//
//  Created by mr.cao on 15/8/13.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "HETDevice.h"

typedef NS_ENUM(NSInteger, HETWiFiDeviceState) {
    HETWiFiDeviceOnState      = 1,  //设备在线状态
    HETWiFiDeviceOffState    //设备离线状态
};



@interface HETDeviceControlBusiness : NSObject
@property (nonatomic,readonly ) NSDictionary    *deviceCfgData;


/**
 *
 *
 *  @param device                设备的对象
 *  @param runDataBlock          设备运行数据block回调
 *  @param cfgDataBlock          设备配置数据block回调
 *  @param errorDataBlock        设备故障数据block回调
 *  @param stateBlock            设备在线状态block回调
 *  @param failureBlock          获取设备数据失败block回调
 */
- (instancetype)initWithHetDeviceModel:(HETDevice *)device
                        deviceRunData:(void(^)(id responseObject))runDataBlock
                        deviceCfgData:(void(^)(id responseObject))cfgDataBlock
                      deviceErrorData:(void(^)(id responseObject))errorDataBlock
                        deviceState:(void(^)(HETWiFiDeviceState state))stateBlock
                         failBlock:(void(^)( NSError *error))failureBlock;



/**
 *  设备控制
 *
 *  @param jsonString   设备控制的json字符串
 *  @param successBlock 控制成功的回调
 *  @param failureBlock 控制失败的回调
 */
- (void)deviceControlRequestWithJson:(NSString *)jsonString withSuccessBlock:(void(^)(id responseObject))successBlock withFailBlock:(void(^)( NSError *error))failureBlock;



//启动服务
- (void)start;


//停止服务
- (void)stop;



@end





