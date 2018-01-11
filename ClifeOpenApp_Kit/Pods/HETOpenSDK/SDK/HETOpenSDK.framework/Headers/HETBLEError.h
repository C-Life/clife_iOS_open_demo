//
//  HETBLEError.h
//  HETPublicSDK_BLE
//
//  Created by mr.cao on 2017/9/5.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#ifndef HETBLEError_h
#define HETBLEError_h


#endif /* HETBLEError_h */

#pragma mark - Error Domains
extern NSString * const kHETBLEErrorDomain;

// Error Codes
extern const NSInteger kHETBLEBoardNameErrorCode;
extern const NSInteger kHETBLEConnectErrorCode ;
extern const NSInteger kHETBLEDisConnectErrorCode;
extern const NSInteger kHETBLERecvDataErrorCode;
extern const NSInteger kHETBLEBusyErrorCode;
extern const NSInteger kHETBLEUUIDErrorCode;
extern const NSInteger kHETBLEFindErrorCode ;
extern const NSInteger kHETBLEIsconnectErrorCode;
extern const NSInteger kHETBLEReadCharactErrorCode;
extern const NSInteger kHETBLEWriteCharactErrorCode ;
extern const NSInteger kHETBLECommunTimeOutErrorCode ;
extern const NSInteger kHETBLEObjIsNilErrorCode ;
extern const NSInteger kHETBLEBLEBindDeviceTypeErrorCode ;
extern const NSInteger kHETBLEBLEOperationCancleErrorCode;
extern const NSInteger kHETBLERecvDataAnalyErrorCode;
extern const NSInteger kHETBLERecvPacketDataErrorCode;
extern const NSInteger kHETBLEMCUVersionErrorCode;
extern const NSInteger kHETBLEMCUUpdateFileErrorCode;

extern NSString * const kHETBLEBoardNameErrorCodeErrorMessage;//  @"未扫到指定的蓝牙广播";
extern NSString * const kHETBLEConnectErrorCodeErrorMessage ;//  @"扫到但是无法连接上";
extern NSString * const kHETBLEDisConnectErrorCodeErrorMessage ;//  @"蓝牙断开了";
//NSString * const kHETBLERecvDataErrorCodeErrorMessage ;//  @"通信过程数据异常";
extern NSString * const kHETBLEBusyErrorCodeErrorMessage;//  @"蓝牙繁忙";
extern NSString * const kHETBLEUUIDErrorCodeErrorMessage ;// @"没有指定UUID";
extern NSString * const kHETBLEFindErrorCodeErrorMessage ;//  @"没有搜索到设备";
extern NSString * const kHETBLEIsconnectErrorCodeErrorMessage;//  @"蓝牙正在连接";
extern NSString * const kHETBLEReadCharactErrorCodeErrorMessage;//  @"找不到ReadCharact";
extern NSString * const kHETBLEWriteCharactErrorCodeErrorMessage ;//  @"找不到WriteCharact";
extern NSString * const kHETBLECommunTimeOutErrorCodeErrorMessage;//  @"蓝牙通信超时";
extern NSString * const kHETBLEObjIsNilErrorCodeErrorMessage;//  @"蓝牙连接对象是空";
extern NSString * const kHETBLEBindDeviceTypeErrorCodeErrorMessage;//  @"蓝牙绑定时大小类不匹配";
extern NSString * const kHETBLEOperationCancleErrorCodeErrorMessage;//  @"蓝牙指令操作取消";
extern NSString * const kHETBLERecvDataAnalyErrorCodeErrorMessage;//  @"蓝牙收到的数据解包异常";
extern NSString * const kHETBLERecvPacketDataErrorCodeErrorMessage;//  @"蓝牙收到的数据包异常";
extern NSString * const kHETBLEMCUVersionErrorCodeErrorMessage;//  @"蓝牙MCU版本格式不对，定义为V0.0.1类似";
extern NSString * const kHETBLEMCUUpdateFileErrorCodeErrorMessage;//  @"蓝牙MCU升级的bin文件路径为空";
