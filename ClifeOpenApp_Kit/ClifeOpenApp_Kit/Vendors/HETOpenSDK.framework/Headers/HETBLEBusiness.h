//
//  HETBLEBusiness.h
//  blencryptor
//
//  Created by mr.cao on 2017/4/10.
//  Copyright © 2017年 com.het. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HETPeripheral.h"
#import "HETDeviceVersionModel.h"


typedef NS_ENUM(NSInteger, HETBLETimeType) {
    HETBLEGMTTime      = 1,  //格林治时间
    HETBLECSTTime       = 2, //本地时间(如北京时间)
};

@interface HETBLEBusiness : NSObject

//当前蓝牙设备对象
@property (strong, nonatomic) CBPeripheral *currentPeripheral;

//当前蓝牙连接状态
@property (assign, readonly)HETPeripheralConnectState state;

//蓝牙连接超时时间,默认5秒时间
@property (assign, nonatomic)NSUInteger   connectTimeoutInterval;

//蓝牙连接重试次数,默认不重试
@property (assign, nonatomic)NSUInteger   connectRetryTimes;



/**
 
 
 @param productId       设备的productId
 @param deviceTypeId    设备的大类deviceTypeId
 @param deviceSubtypeId 设备的小类deviceSubtypeId
 
 @return
 */
- (instancetype)initWithProductId:(NSUInteger)productId
                     deviceTypeId:(NSUInteger)deviceTypeId
                  deviceSubtypeId:(NSUInteger)deviceSubtypeId;



/**
 获取当前手机蓝牙状态
 */
-(CBManagerState)currentStateOfCBCentermanager;


/**
 监听手机蓝牙状态
 */
-(void)observeStateOfCBCentermanager:(void(^)(CBManagerState state))stateBlock;


/**
 扫描蓝牙设备
 
 @param timeOut         设置扫描的超时时间,单位秒
 @param name            设置蓝牙名字，可为nil(name与mac地址都为nil的时候不会过滤设备)
 @param mac             设置蓝牙mac地址，可为nil
 @param scanResultBlock 蓝牙扫描的结果
 */
-(void)scanForPeripheralsWithTimeOut:(NSTimeInterval)timeOut name:(NSString *)name mac:(NSString *)mac scanForPeripheralsBlock:(void(^)(NSArray<CBPeripheral*>*  peripherals,NSError *error))scanResultBlock;



/**
 停止扫描
 */
-(void)stopScanForPeripherals;



/**
 连接蓝牙设备
 
 @param peripheral 蓝牙对象
 @param handler    连接蓝牙的回调
 */
-(void)connectWithPeripheral:(CBPeripheral*)peripheral  completionHandler:(void (^)(NSError *error))handler;


/**
 断开蓝牙设备
 
 @param peripheral 蓝牙对象
 */
-(void)disconnectWithPeripheral:(CBPeripheral*)peripheral;


/**
 绑定蓝牙设备
 
 @param peripheral 蓝牙对象(peripheral与mac至少需要一个不为空)
 @param mac        设备的mac地址
 @param handler    绑定结果的回调函数
 */
-(void)bindBleDeviceWithPeripheral:(CBPeripheral*)peripheral
                        macAddress:(NSString *)mac
                 completionHandler:(void (^)(NSString *deviceId, NSError *error))handler;


/**
 设备控制
 
 @param peripheral 蓝牙对象(peripheral与mac至少需要一个不为空)
 @param mac        设备的mac地址
 @param sendDic    需要发送的数据
 @param handler    设备控制的回调函数
 */
-(void)deviceControlRequestWithPeripheral:(CBPeripheral *) peripheral
                               macAddress:(NSString *)mac
                                  sendDic:(NSDictionary *)sendDic
                        completionHandler:(void (^)(CBPeripheral *currentPeripheral,NSError *error))handler;



/**
 获取实时数据
 
 @param peripheral 蓝牙对象(peripheral与mac至少需要一个不为空)
 @param mac        设备的mac地址
 @param deviceId   设备的deviceId
 @param handler    获取实时数据的回调函数
 */
-(void)fetchRealTimeDataWithPeripheral:(CBPeripheral *) peripheral
                            macAddress:(NSString *)mac
                              deviceId:(NSString *)deviceId
                     completionHandler:(void (^)(CBPeripheral *currentPeripheral,NSDictionary *dic,NSError *error))handler;


/**
 监听状态数据，设备主动上传状态数据
 
 @param peripheral 蓝牙对象(peripheral与mac至少需要一个不为空)
 @param mac        设备的mac地址
 @param deviceId   设备的deviceId
 @param handler    获取状态数据的回调函数
 */
-(void)fetchStatusDataWithPeripheral:(CBPeripheral *) peripheral
                          macAddress:(NSString *)mac
                            deviceId:(NSString *)deviceId
                   completionHandler:(void (^)(CBPeripheral *currentPeripheral,NSDictionary *dic,NSError *error))handler;





/**
 获取历史数据
 
 @param peripheral    蓝牙对象(peripheral与mac至少需要一个不为空)
 @param mac           设备的mac地址
 @param deviceId      设备的deviceId
 @param progressBlock 当前进度的回调函数，currentFrame当前的帧数,totalFrame总帧数，data当前的数据帧
 @param handler       data历史数据,error错误信息
 */
-(void)fetchHistoryDataWithPeripheral:(CBPeripheral *) peripheral
                           macAddress:(NSString *)mac
                             deviceId:(NSString *)deviceId
                             progress:(void (^)(UInt16 currentFrame, UInt16 totalFrame, NSData *data))progressBlock
                    completionHandler:(void (^)(CBPeripheral *currentPeripheral,NSData *data,NSError *error))handler;


/**
 清除历史数据
 
 @param peripheral 蓝牙对象(peripheral与mac至少需要一个不为空)
 @param mac        设备的mac地址
 @param handler    清除历史数据的回调函数
 */
-(void)clearHistoryDataWithPeripheral:(CBPeripheral *) peripheral
                           macAddress:(NSString *)mac
                    completionHandler:(void (^)(CBPeripheral *currentPeripheral,NSError *error))handler;




/**
 设置设备时间
 
 @param peripheral 蓝牙对象(peripheral与mac至少需要一个不为空)
 @param mac        设备的mac地址
 @param timeType   时间格式
 @param handler    回调函数
 */
-(void)setTimeWithPeripheral:(CBPeripheral *) peripheral
                  macAddress:(NSString *)mac
                    timeType:(HETBLETimeType)timeType
           completionHandler:(void (^)(CBPeripheral *currentPeripheral,NSData* data,NSError *error))handler;



/**
 获取设备时间
 
 @param peripheral 蓝牙对象(peripheral与mac至少需要一个不为空)
 @param mac        设备的mac地址
 @param handler    回调函数
 */
-(void)getTimeWithPeripheral:(CBPeripheral *) peripheral
                  macAddress:(NSString *)mac
           completionHandler:(void (^)(CBPeripheral *currentPeripheral,NSData* data,NSError *error))handler;


/**
 监听设备基本信息如电池电量，固件版本等
 
 @param handler    回调函数，里面的dic的key参考HETPeripheral.h文件，
 kHETBLE_DEVINFO_SYSTEM_ID//System ID,产品唯一标示符,由 MAC 地址和芯片厂 商代号组成.如:蓝牙地址: 0002 5B00 1580; 厂商标识: fffe,system id 值: 8015 00 feff 5b 0200
 kHETBLE_DEVINFO_MODEL_NUMBER//Model number,蓝牙模组型号(英文字符.例 如:”HET-BT2541”)最大长度为 20
 kHETBLE_DEVINFO_SERIAL_NUMBER//Serial number,产品序列号(英文字符。例 如:”00121123”) 最大长度为 20
 kHETBLE_DEVINFO_FIRMWARE_REV//Firmware Revision,蓝牙固件版本(英文字符)最大长度为 20
 kHETBLE_DEVINFO_HARDWARE_REV//Hardware Revision,PCBA 版本(英文字符。)最大长度 为 20
 kHETBLE_DEVINFO_SOFTWARE_REV//Software Revision,MCU 软件版本(英文字符。)最大长 度为 20
 kHETBLE_DEVINFO_MANUFACTURER_NAME//Manufacture name,整机品牌商代码(英文字符。)最大 长度为 20
 kHETBLE_BATTRY_LEVEL//Battery level,Current battery level of the module
 
 */
-(void)fetchDeviceInfoCompletionHandler:(void (^)(CBPeripheral *currentPeripheral,NSDictionary *dic))handler;



/**
 蓝牙设备MCU升级
 
 @param peripheral         蓝牙对象
 @param mac                设备的mac地址
 @param deviceId   设备的deviceId
 @param deviceVersionModel  设备版本信息
 @param progressBlock      升级的进度
 @param handler   升级的回调
 */
-(void)mcuUpgrade:(CBPeripheral *)peripheral
       macAddress:(NSString *)mac
         deviceId:(NSString *)deviceId
deviceVersionModel:(HETDeviceVersionModel *)deviceVersionModel
         progress:(void (^)(float progress))progressBlock
completionHandler:(void (^)(CBPeripheral *currentPeripheral,NSError *error))handler;

@end
