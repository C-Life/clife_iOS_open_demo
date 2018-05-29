//
//  HETBLEDeviceH5ViewController.h
//  HETPublicSDK_HETH5DeviceControl
//
//  Created by mr.cao on 2018/3/21.
//  Copyright © 2018年 HET. All rights reserved.
//

#import "HETH5ContainBaseViewController.h"
//#import "HETBLEBusiness.h"

//非开放平台蓝牙协议的业务，自定义实现
@protocol HETCustomBLEDelegate<NSObject>

@optional

/**
 非开放平台蓝牙协议的业务，自定义实现获取蓝牙实时数据

 @param successBlock 获取实时数据成功的回调,根据协议生成字典数据
 @param failureBlock 获取实时数据失败的回调
 */
-(void)fetchBLERealTimeDataWithSuccessBlock:(void(^)(NSDictionary *responseObject))successBlock failBlock:(void(^)( NSError *error))failureBlock;



/**
 非开放平台蓝牙协议的业务，自定义实现获取蓝牙历史数据

 @param successBlock 获取历史数据成功的回调
 @param failureBlock 获取历史数据失败的回调
 @param progressBlock 获取历史数据的进度,progress代表升级的进度，例如progress为10代表升级到10%
 */
-(void)fetchBLEHistoryTimeDataWithSuccessBlock:(void(^)(void))successBlock failBlock:(void(^)( NSError *error))failureBlock progress:(void (^)(NSUInteger progress))progressBlock;



@end

@interface HETBLEDeviceH5ViewController : HETH5ContainBaseViewController

@property(nonatomic, strong) HETBLEBusiness *bleBusiness;//开放平台蓝牙业务类，内部已初始化
@property(nonatomic, strong) CBPeripheral  *blePeripheral;
@property(nonatomic, strong)id<HETCustomBLEDelegate>customBLEDelegate;//非开放平台蓝牙协议的业务

@end
