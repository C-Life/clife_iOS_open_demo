//
//  HETBLEMattressDevice.h
//  HETOpenSDK
//
//  Created by mr.cao on 16/2/18.
//  Copyright © 2016年 mr.cao. All rights reserved.
//  床垫设备业务类

#import <Foundation/Foundation.h>
@class LGPeripheral;

@interface HETBLEMattressDeviceInfo : NSObject

@property (nonatomic, strong) NSString * deviceId;//设备标示
@property (nonatomic, assign) NSInteger heartValue;//心率

@property (nonatomic, assign) NSInteger breathValue;//呼吸

@property (nonatomic, assign) NSInteger snoreValue;//打鼾

@property (nonatomic, assign) NSInteger turnOverValue;//翻身次数

@property (nonatomic, assign) NSInteger havePeople;//是否有人
@property (nonatomic, assign) NSInteger batteryValue;//电量
@property (nonatomic, assign) NSInteger fault;//设备故障
@property (nonatomic, assign) NSInteger protocol_version;//设备协议版本号,如果是0就是老协议，1就是新协议
@end







@interface HETBLEMattressDevice : NSObject


/**
 *  扫描蓝牙设备
 *
 *  @param deviceProductId 设备的productId
 *  @param timeout         设置蓝牙扫描的超时时间,单位是秒
 *  @param completionHandler  描到的蓝牙设备结果的回调
 *  @param timeout         设置蓝牙扫描的超时时间
 */

-(void)scanBleDevicesProductId:(NSUInteger) deviceProductId timeOut:(NSTimeInterval)timeout scanBleDevices:(void (^)(NSArray<LGPeripheral *>* deviceArray, NSError *error))completionHandler;

/**
 *  绑定设备
 *
 *  @param curPeripheral 需要绑定的蓝牙设备对象
 *  @param deviceProductId 设备型号标识

 *  @param successBlock  绑定成功的block
 *  @param failBlock     绑定失败的block
 */

- (void)bindBleDevice:(LGPeripheral *)curPeripheral deviceProductId:(NSUInteger) deviceProductId successBlock:(void(^)(NSString *deviceId))successBlock failBlock:(void(^)(NSError* error))failBlock;
/**
 *  获取历史数据
 *
 *  @param broadName  蓝牙设备名字，LGPeripheral.name
 *  @param deviceId   设备唯一deviceId，后台获取的
 *  @param successBlock 获取历史数据成功的回调
 *  @param failBlock   获取历史数据失败的回调
*  @param progressiveBlock   获取历史数据的进度，totalBytesRead当前已经获取到的数据大小，totalBytesExpected历史数据总共的数据大小
 */
-(void)fetchHistoryDatawithBLEBroadName:(NSString *)broadName withDeviceId:(NSString*)deviceId successBlock:(void(^)(void))successBlock
                              failBlock:(void(^)(NSError* error))failBlock
                       progressiveBlock:(void (^)(NSInteger totalBytesRead, NSInteger totalBytesExpected))progressiveBlock;





/**
 *  获取实时数据
 *
 *  @param broadName  蓝牙设备名字，LGPeripheral.name
 *  @param deviceId   设备唯一deviceId，后台获取的
 *  @param successBlock 实时数据返回的数据,HETBLEMattressDeviceInfo对象
 *  @param failBlock    获取数据失败的block
 */
-(void)fetchRealTimeDataWithBLEBroadName:(NSString *)broadName withDeviceId:(NSString*)deviceId  successBlock:(void(^)(HETBLEMattressDeviceInfo *deviceInfo))successBlock
                               failBlock:(void(^)(NSError* error))failBlock;



/**
 *  断开蓝牙设备
 */
-(void)disconnect;



/**
 *  获取睡眠带子天报告详细
 *
 *  @param deviceId 获取睡眠带子天报告详细
 *  @param dataTime 数据时间（例如：2016-12-21）
 */

+(void)fetchMattressDeviceSummaryDayDataWithDeviceId:(NSString *)deviceId
                                            dataTime:(NSString *)dataTime
                                             successBlock:(void(^)(id responseObject))successBlock
                                             failBlock:(void(^)(NSError* error))failBlock;


/**
 *  获取睡眠带子时间段内的统计报告
 *
 *  @param deviceId  设备id
 *  @param startDate 起始时间，查询结果包含该时间（例如：2016-12-21）
 *  @param endDate   结束时间，查询结果包含该时间（例如：2016-12-21）
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
+ (void)fetchMattressDeviceDayDataListWithDeviceId:(NSString *)deviceId
                                         startDate:(NSString *)startDate
                                           endDate:(NSString *)endDate
                                      successBlock:(void(^)(id responseObject))successBlock
                                         failBlock:(void(^)(NSError* error))failBlock;





@end
