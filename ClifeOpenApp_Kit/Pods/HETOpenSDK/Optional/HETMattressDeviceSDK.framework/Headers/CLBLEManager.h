//
//  BLEManager.h
//  BLEForCSleep
//
//  Created by mr.cao on 15/6/1.
//  Copyright (c) 2015年 Het. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGBluetooth.h"
#import "CLBLEDataSource.h"
extern NSString * const kLGPeripheralDidFound;

#pragma mark - Error Domains -

/**
 * Error domains for Connection errors
 */
// Error Domains
extern NSString * const kCLBLEManagerErrorDomain;
// Error Codes
extern const NSInteger kBLEBoardNameErrorCode;
extern const NSInteger kBLEConnectErrorCode;
extern const NSInteger kBLECommunConnectErrorCode;
extern const NSInteger kBLERecvDataErrorCode;
extern const NSInteger kBLEBusyErrorCode;
extern const NSInteger kBLEUUIDErrorCode;
extern const NSInteger kBLEFindErrorCode;
extern const NSInteger kBLEReadCharactErrorCode;
extern const NSInteger kBLEWriteCharactErrorCode;
extern const NSInteger kBLETimeOutErrorCode;
extern const NSInteger kBLEObjErrorCode;

extern NSString * const kBLEBoardNameErrorCodeErrorMessage;
extern NSString * const kBLEConnectErrorCodeErrorMessage;
extern NSString * const kBLECommunConnectErrorCodeErrorMessage;
extern NSString * const kBLERecvDataErrorCodeErrorMessage;
extern NSString * const kBLEBusyErrorCodeErrorMessage;
extern NSString * const kBLEUUIDErrorCodeErrorMessage;
extern NSString * const kBLEFindErrorCodeErrorMessage;
extern NSString * const kBLEReadCharactErrorCodeErrorMessage;
extern NSString * const kBLEWriteCharactErrorCodeErrorMessage;
extern NSString * const kBLETimeOutErrorCodeErrorMessage;
extern NSString * const kBLEObjErrorCodeErrorMessage;

/**
 *  扫描蓝牙设备的代理方法
 */
@protocol CLBLEManagerDelegate <NSObject>

/**
 *  扫描所有蓝牙设备的代理方法
 *
 *  @param allLGPeripherals LGPeripheral对象的数组
 */
-(void)scanAllPeripherals:(NSArray<LGPeripheral *>*)allLGPeripherals;

@end

@interface CLBLEManager : NSObject

/**
 *  当前连接的蓝牙
 */
@property (strong, nonatomic) LGPeripheral  *currentLGPeripheral;

/**
 *  蓝牙中央管理器
 */
@property (strong, nonatomic) CBCentralManager *manager;


/**
 *  单例
 *
 *  @return
 */
+(CLBLEManager *)sharedInstance;



/**
 *  扫描蓝牙设备
 *
 *  @param child   CLBLEDataSource对象，如果扫描设备名字CLBLEDataSource对象的broadName为空，则扫描所有设备并返回列表，如果broadName不为空则返回包含broadName蓝牙设备 ,扫描到设备会执行CLBLEManagerDelegate方法
 *  @param timeOut 扫描超时时间
 */
-(void)scanbleWithObject:(id<CLBLEDataSource>)child
         withScanTimeOut:(NSInteger)timeOut;


/**
 *  普通业务连接蓝牙设备
 *
 *  @param child             CLBLEDataSource对象,必须设置扫描设备名字CLBLEDataSource对象的broadName，否则不会连接
 *  @param connectResultBlock 连接成功和失败的回调
 */
-(void)conntectPeripheralWithBLEDataSource:(id<CLBLEDataSource>)child
                           withResultBlock:(void(^)(LGPeripheral* peripheral,NSError *error))connectResultBlock;




/**
 *  OAD空中升级连接蓝牙设备
 *
 *  @param child               CLBLEDataSource对象,必须设置扫描设备名字CLBLEDataSource对象的broadName，否则不会连接
 *  @param connectResultBlock  连接成功和失败的回调
 */
-(void)oadConntectPeripheralWithBLEDataSource:(id<CLBLEDataSource>)child
                           withResultBlock:(void(^)(LGPeripheral* peripheral,NSError *error))connectResultBlock;


/**
 *  发送数据
 *
 *  @param data       需要发送的数据
 *  @param peripheral LGPeripheral 蓝牙对象
 */
-(void)sendData:(NSData *)data peripheral:(LGPeripheral *)peripheral;





/**
 *  断开蓝牙
 *
 *  @param peripheral LGPeripheral 蓝牙对象
 *  @param aCallback  断开成功失败的回调
 */
-(void)disconntectPeripheral:(LGPeripheral *)peripheral withResultBlock:(void(^)(NSError *error))aCallback;



/**
 *  添加一对多的代理方法
 *
 *  @param delegate      代理对象
 *  @param delegateQueue dispatch_queue_t队列对象
 */
-(void) addBleDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

/**
 *  移除一对多的代理方法
 *
 *  @param delegate      代理对象
 *  @param delegateQueue dispatch_queue_t队列对象
 */
-(void) removeBleDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;


@end
