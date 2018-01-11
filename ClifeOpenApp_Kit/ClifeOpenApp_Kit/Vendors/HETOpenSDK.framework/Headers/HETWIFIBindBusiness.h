//
//  HETWIFIBindBusiness.h
//  HETOpenSDK
//
//  Created by mr.cao on 15/6/24.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "HETDevice.h"



typedef NS_ENUM(NSInteger, HETWiFiDeviceBindError) {
    
    HETWiFiDeviceBindGetServerIPError = 0,    // 获取绑定服务器的IP地址和端口错误
    HETWiFiDeviceBindGetDeviceInfoError,      // 获取设备基本信息失败
    HETWiFiDeviceBindSendDeviceInfoError,   // 提交设备信息给服务器失败
    HETWiFiDeviceBindTimeOutError,           // 绑定超时
    HETWiFiDeviceBindbroadCastIPError,       // 广播地址出错
};


typedef NS_ENUM(NSInteger, HETWiFiDeviceBindState) {
    
    HETWiFiDeviceScaning = 0,    // 扫描设备中
    HETWiFiDeviceBinding,      // 绑定中
    HETWiFiDeviceBindSuccess,      // 绑定成功
    HETWiFiDeviceBindFail,      // 绑定失败
};

@interface HETWIFIBindBusiness : NSObject




+ (HETWIFIBindBusiness *)sharedInstance;


/**
 *  获取手机所连WIFI得SSID
 *
 *  @param interval 时间间隔，每隔interval 获取一次
 *  @param times    次数
 *  @param success  获取SSID的回调
 */
-(void)fetchSSIDInfoWithInterVal:(NSTimeInterval)interval
                       WithTimes:(NSTimeInterval)times
                    SuccessBlock:(void(^)(NSString* ssidStr))success;


/**
 *  停止获取手机所连WIFI得SSID
 */

-(void)stopFetchSSIDInfo;




/**
 *  获得所连Wi-Fi的Mac地址
 *
 *  @return 返回mac地址
 */
-(NSString *)fetchmacSSIDInfo;




/**
 *  绑定SmartLink模式WiFi设备
 *
 *  @param productId         设备的productId
 *  @param ssid              设备所需要接入的路由器名称
 *  @param password          设备所需要接入的路由器密码
 *  @param interval          绑定的超时时间,单位是秒
 *  @param handler           绑定的回调
 */
-(void)startSmartLinkBindDeviceWithProductId:(NSString *)productId
                               withSSID:(NSString *)ssid
                           withPassWord:(NSString *)password
                        withTimeOut:(NSTimeInterval)interval
                  bindHandler:(void (^)(HETWiFiDeviceBindState state,HETDevice *deviceObj, NSError *error))handler;



/**
 *  绑定AP模式的WiFi设备
 *
 *  @param productId         设备型号标识
 *  @param deviceTypeId      设备的大类
 *  @param deviceSubtypeId   设备的小类
 *  @param ssid              AP设备所需要接入的路由器名称
 *  @param password          AP设备所需要接入的路由器密码
 *  @param interval          绑定的超时时间,单位是秒
 *  @param handler           绑定的回调
 */
-(void)startAPBindDeviceWithProductId:(NSString *)productId
                     withDeviceTypeId:(NSString *)deviceTypeId
                  withDeviceSubtypeId:(NSString *)deviceSubtypeId
                             withSSID:(NSString *)ssid
                         withPassWord:(NSString *)password
                          withTimeOut:(NSTimeInterval)interval
                    bindHandler:(void (^)(HETWiFiDeviceBindState state,HETDevice *deviceObj, NSError *error))handler;



/**
 *  停止服务，关闭socket
 */
-(void) stop;

@end
