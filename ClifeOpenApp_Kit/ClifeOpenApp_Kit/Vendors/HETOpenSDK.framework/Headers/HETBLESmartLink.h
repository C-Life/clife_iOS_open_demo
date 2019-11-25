//
//  HETBLESmartLink.h
//  HETPublicSDK_DeviceBind
//
//  Created by mr.cao on 2017/6/1.
//  Copyright © 2017年 HET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HETPeripheral.h"
#import "HETDevice.h"
static NSString *const HETBLEDeviceBindErrorDomain = @"HETBLEDeviceBindErrorDomain";

typedef NS_ENUM(NSInteger, HETDeviceBindError) {
    
    HETBLEDeviceBindGetServerIPError = 0,    // 获取绑定服务器的IP地址和端口错误
    HETBLEDeviceBindGetDeviceInfoError,      // 获取设备基本信息失败
    HETBLEDeviceBindSendDeviceInfoError,   // 提交设备信息给服务器失败
    HETBLEDeviceBindTimeOutError,            // 绑定超时
};
@interface HETBLESmartLink : NSObject

/**
 扫描蓝牙设备
 
 @param timeOut         设置扫描的超时时间,单位秒
 @param name            设置蓝牙名字，可为nil
 @param mac         设置蓝牙mac地址，可为nil
 @param scanResultBlock 蓝牙扫描的结果
 */
-(void)scanForPeripheralsWithTimeOut:(NSTimeInterval)timeOut name:(NSString *)name mac:(NSString *)mac scanForPeripheralsBlock:(void(^)(NSArray<CBPeripheral*>*  peripherals,NSError *error))scanResultBlock;


/**
 停止扫描
 */
-(void)stopScanForPeripherals;


/**
 绑定蓝牙设备
 
 @param peripheral 蓝牙对象
 @param devicemodel       设备对象
 @param ssid              设备所需要接入的路由器名称
 @param password          设备所需要接入的路由器密码
 @param handler           绑定结果的回调函数
 */
-(void)bindDeviceWithWithPeripheral:(CBPeripheral*)peripheral
                          deviceModel:(HETDevice *)devicemodel
                               SSID:(NSString *)ssid
                           password:(NSString *)password
                            timeOut:(NSTimeInterval)interval
                  completionHandler:(void (^)(NSString *deviceId, NSError *error))handler;


-(void)stop;
@end
