//
//  HETPeripheral.h
//  blencryptor
//
//  Created by mr.cao on 2017/4/10.
//  Copyright © 2017年 com.het. All rights reserved.
//
#import <CoreBluetooth/CoreBluetooth.h>
#import "HETBLEError.h"

extern NSString * const kHETBLECenterSendDataNotification ;
extern NSString * const kHETBLECenterRecvDataNotification ;
extern NSString * const kHETBLECenterRecvAndParseDataNotification;
extern NSString * const kHETBLEDisconnectNotification;

typedef NS_ENUM(NSInteger, HETPeripheralConnectState) {
    HETPeripheralStateUnconnect = 0,//未连接
    HETPeripheralStateConnecting,//连接中
    HETPeripheralStateConnected,//连接上
    HETPeripheralStateConnectFail,//连接失败
    HETPeripheralStateDisconnected,//设备端主动断开了连接
    HETPeripheralStateConnectRetrying,//设备重连中
    HETPeripheralStateConnectedAndAuthorized,//连接上并且认证成功
};

static  NSString *const kHETBLE_DEVINFO_SYSTEM_ID=@"2A23";//System ID,产品唯一标示符,由 MAC 地址和芯片厂 商代号组成.如:蓝牙地址: 0002 5B00 1580; 厂商标识: fffe,system id 值: 8015 00 feff 5b 0200
static  NSString *const kHETBLE_DEVINFO_MODEL_NUMBER=@"2A24";//Model number,蓝牙模组型号(英文字符.例 如:”HET-BT2541”)最大长度为 20
static  NSString *const kHETBLE_DEVINFO_SERIAL_NUMBER=@"2A25";//Serial number,产品序列号(英文字符。例 如:”00121123”) 最大长度为 20
static  NSString *const kHETBLE_DEVINFO_FIRMWARE_REV=@"2A26";//Firmware Revision,蓝牙固件版本(英文字符)最大长度为 20
static  NSString *const kHETBLE_DEVINFO_HARDWARE_REV=@"2A27";//Hardware Revision,PCBA 版本(英文字符。)最大长度 为 20
static  NSString *const kHETBLE_DEVINFO_SOFTWARE_REV=@"2A28";//Software Revision,MCU 软件版本(英文字符。)最大长 度为 20
static  NSString *const kHETBLE_DEVINFO_MANUFACTURER_NAME=@"2A29";//Manufacture name,整机品牌商代码(英文字符。)最大 长度为 20

static  NSString *const kHETBLE_BATTRY_LEVEL=@"2A19";//Battery level,Current battery level of the module


@interface CBPeripheral()

@property NSNumber* rssi;
@property NSString* uuidString;
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 70000
@property CFUUID *uuid;
#else
@property NSUUID *uuid;

#endif
@property NSString   *mac;//设备的mac地址
@property NSString   *localName;//设备的广播名
@property NSNumber   *deviceBrand;//设备的品牌
@property NSNumber   *deviceType;//设备的大类
@property NSNumber   *deviceSubType;//设备的小类

@property HETPeripheralConnectState connectState;//设备连接状态


@end
