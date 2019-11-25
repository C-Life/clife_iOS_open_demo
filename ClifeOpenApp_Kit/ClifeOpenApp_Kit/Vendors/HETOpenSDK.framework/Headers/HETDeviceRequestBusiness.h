//
//  HETDeviceRequestBusiness.h
//  HETOpenSDK
//
//  Created by mr.cao on 15/8/13.
//  Copyright (c) 2015年 peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HETNetWorkRequestHeader.h"
#import "HETFileInfo.h"
#import "HETDevice.h"
#import "HETNetWorkRequestHeader.h"

typedef NS_ENUM(NSUInteger,HETDeviceBindType)
{
    HETWIFIDeviceBindType=1,//WiFi绑定类型
    HETBLEDeviceBindType=2,//蓝牙绑定类型
};


typedef NS_ENUM(NSUInteger,HETBLEDeviceDataUploadType)
{
    HETBLEDeviceHistoryDataUploadType=1,//蓝牙设备历史数据上传类型
    HETBLEDeviceRealTimeDataUploadType=2,//蓝牙设备实时数据上传类型
    HETBLEDeviceControlDataUploadType=3,//蓝牙设备实时控制数据上传类型
    HETBLEDeviceHistoryControlDataUploadType=4,//蓝牙设备历史控制数据上传类型
    HETBLEDeviceStatusDataUploadType=5,//蓝牙设备状态数据上传类型
};

@interface HETDeviceRequestBusiness : NSObject

/**
 *  下发控制设备
 *
 *  @param json     设备控制json
 *  @param deviceId 设备deviceId
 *  @param success  设备控制成功的回调
 *  @param failure  设备控制失败的回调
 */
+ (void)deviceControlWithJSON:(NSString *)json
                 withDeviceId:(NSString *)deviceId
                      success:(HETSuccessBlock)success
                      failure:(HETFailureBlock)failure;



/**
 *  下发控制设备，新接口
 *
 *  @param json     设备控制json
 *  @param deviceId 设备deviceId
 *  @param isOfflineSend 是否离线下发标识（0：是； 1：否。默认1），NBIOT设备需要离线下发
 *  @param success  设备控制成功的回调
 *  @param failure  设备控制失败的回调
 */
+ (void)deviceControlWithJSON:(NSString *)json
                 withDeviceId:(NSString *)deviceId
            withIsOfflineSend:(NSNumber *)isOfflineSend
                      success:(HETSuccessBlock)success
                      failure:(HETFailureBlock)failure;

/**
 *  查询绑定的所有设备列表
 *
 *  @param success  设备列表返回HETDevice对象数组
 *  @param failure 失败的回调
 */
+ (void)fetchAllBindDeviceSuccess:(void (^)(NSArray<HETDevice *>* deviceArray))success
                          failure:(HETFailureBlock)failure;



/**
 *  查询设备大类
 *
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */


+ (void)fetchDeviceTypeListSuccess:(HETSuccessBlock)success
                           failure:(HETFailureBlock)failure;






/**
 *  根据设备大类查询APP支持的设备型号
 *
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */

+ (void)fetchDeviceProductListWithDeviceTypeId:(NSString *)deviceTypeId
                                       success:(HETSuccessBlock)success
                                       failure:(HETFailureBlock)failure;



/**
 *  根据设备大类查询APP支持的设备型号
 *
 *  @param success  设备列表返回HETDevice对象数组
 *  @param failure 失败的回调
 */

+ (void)fetchDeviceProductList:(NSString *)deviceTypeId
                       success:(void (^)(NSArray<HETDevice *>* deviceArray))success
                       failure:(HETFailureBlock)failure;

/**
 *  解除设备绑定
 *
 *  @param deviceId 设备deviceId
 *  @param success  解除绑定成功的回调
 *  @param failure  解除绑定失败的回调
 */
+ (void)unbindDeviceWithDeviceId:(NSString *)deviceId
                         success:(HETSuccessBlock)success
                         failure:(HETFailureBlock)failure;



/**
 *  设备绑定
 *
 *  @param macAddr         设备mac地址
 *  @param deviceProductId  设备型号标识
 *  @param deviceId         设备标识（更换MAC地址)
 *  @param success         绑定成功的回调
 *  @param failure         绑定失败的回调
 */


+(void)bindDeviceWithDeviceMAC:(NSString *)macAddr
               deviceProductId:(NSInteger) deviceProductId
                      deviceId:(NSString *) deviceId
                       success:(HETSuccessBlock)success
                       failure:(HETFailureBlock)failure;


/**
 *  GPRS设备绑定
 *
 *  @param mac       MAC地址 (mac和imei必传一个）
 *  @param imei    GPRS设备IMEI号 (mac和imei必传一个）
 *  @param productId     设备产品ID
 *  @param success       绑定成功的回调
 *  @param failure       绑定失败的回调
 */
+ (void)bindGRPSDeviceWithMac:(NSString *)mac
                   deviceImei:(NSString *)imei
                    productId:(NSString *)productId
                      success:(HETSuccessBlock)success
                      failure:(HETFailureBlock)failure;

/**
 *  根据productId获取产品的详细信息
 *
 *  @param productId 设备型号标识
 *  @param success  查询设备信息成功的回调
 *  @param failure  查询设备信息失败的回调
 */
+(void)fetchDeviceInfoWithProductId:(NSString *)productId
                            success:(HETSuccessBlock)success
                            failure:(HETFailureBlock)failure;


/**
 *  根据deviceId获取设备的基本信息
 *
 *  @param deviceId 设备标识
 *  @param success  查询设备信息成功的回调
 *  @param failure  查询设备信息失败的回调
 */
+(void)fetchDeviceInfoWithDeviceId:(NSString *)deviceId
                            success:(HETSuccessBlock)success
                            failure:(HETFailureBlock)failure;


/**
 *  设备数据上传（蓝牙）
 *
 *  @param deviceId 设备deviceId
 *  @param dataType 数据类型
 *  @param data     需要上传的数据
 *  @param jsonStr  根据协议解析的json数据
 *  @param success  上传成功的回调
 *  @param failure  上传失败的回调
 */
//+ (void)uploadDeviceDataWithDeviceId:(NSString *)deviceId
//                            dataType:(HETBLEDeviceDataUploadType) dataType
//                                data:(NSData *)data
//                             success:(HETSuccessBlock)success
//                             failure:(HETFailureBlock)failure;

+ (void)uploadDeviceDataWithDeviceId:(NSString *)deviceId
                            dataType:(HETBLEDeviceDataUploadType) dataType
                                data:(NSData *)data
                                json:(NSString *)jsonStr
                             success:(HETSuccessBlock)success
                             failure:(HETFailureBlock)failure;
/**
 *  设备数据上传（蓝牙）
 *
 *  @param deviceId 设备deviceId
 *  @param dataType 数据类型
 *  @param jsonStr  需要上传的数据
 *  @param success  上传成功的回调
 *  @param failure  上传失败的回调
 */
+ (void)uploadDeviceJsonDataWithDeviceId:(NSString *)deviceId
                                dataType:(HETBLEDeviceDataUploadType) dataType
                                    data:(NSString *)jsonStr
                                 success:(HETSuccessBlock)success
                                 failure:(HETFailureBlock)failure;


/**
 *  获取蓝牙历史数据
 *
 *  @param deviceId  设备标识
 *  @param order     排序方式（0-降序 1-升序 默认0-降序）
 *  @param pageRows  每页显示的行数(默认20)
 *  @param pageIndex 当前页（默认1）
 *  @param success   成功的回调
 *  @param failure   失败的回调
 */
+(void)getBluetoothListWithDeviceId:(NSString *)deviceId
                          withOrder:(NSUInteger)order
                       withPageRows:(NSUInteger)pageRows
                      withPageIndex:(NSUInteger)pageIndex
                            success:(HETSuccessBlock)success
                            failure:(HETFailureBlock)failure;





/**
 *  修改设备基础信息
 *
 *  @param deviceId   设备标识
 *  @param deviceName 设备名称
 *  @param roomId     房间标识（绑定者才可以修改房间位置）
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */

+ (void)updateDeviceInfoWithDeviceId:(NSString *)deviceId
                          deviceName:(NSString *)deviceName
                              roomId:(NSString *)roomId
                             success:(HETSuccessBlock)success
                             failure:(HETFailureBlock)failure;





/**
 *  获取设备运行数据列表（七天之内）
 *
 *  @param deviceId  设备标识
 *  @param startDate 开始时间
 *  @param endDate   结束时间（默认为当天）
 *  @param pageRows  每页显示的行数，默认为20
 *  @param pageIndex 当前页，默认为1
 *  @param success   成功的回调
 *  @param failure   失败的回调
 */
+ (void)fetchDeviceRundataListWithDeviceId:(NSString *)deviceId
                                 startDate:(NSString *)startDate
                                   endDate:(NSString *)endDate
                                  pageRows:(NSString *)pageRows
                                 pageIndex:(NSString *)pageIndex
                                   success:(HETSuccessBlock)success
                                   failure:(HETFailureBlock)failure;



/**
 *  获取设备控制数据列表（七天之内）
 *
 *  @param deviceId  设备标识
 *  @param startDate 开始时间
 *  @param endDate   结束时间（默认为当天）
 *  @param pageRows  每页显示的行数，默认为20
 *  @param pageIndex 当前页，默认为1
 *  @param success   成功的回调
 *  @param failure   失败的回调
 */
+ (void)fetchDeviceConfigDataListWithDeviceId:(NSString *)deviceId
                                    startDate:(NSString *)startDate
                                      endDate:(NSString *)endDate
                                     pageRows:(NSString *)pageRows
                                    pageIndex:(NSString *)pageIndex
                                      success:(HETSuccessBlock)success
                                      failure:(HETFailureBlock)failure;



/**
 *  获取设备故障数据列表（七天之内）
 *
 *  @param deviceId  设备标识
 *  @param startDate 开始时间
 *  @param endDate   结束时间（默认为当天）
 *  @param pageRows  每页显示的行数，默认为20
 *  @param pageIndex 当前页，默认为1
 *  @param success   成功的回调
 *  @param failure   失败的回调
 */
+ (void)fetchDeviceErrorDataListWithDeviceId:(NSString *)deviceId
                                   startDate:(NSString *)startDate
                                     endDate:(NSString *)endDate
                                    pageRows:(NSString *)pageRows
                                   pageIndex:(NSString *)pageIndex
                                     success:(HETSuccessBlock)success
                                     failure:(HETFailureBlock)failure;


/**
 *  获取设备状态数据列表（七天之内）
 *
 *  @param deviceId  设备标识
 *  @param startDate 开始时间
 *  @param endDate   结束时间（默认为当天）
 *  @param pageRows  每页显示的行数，默认为20
 *  @param pageIndex 当前页，默认为1
 *  @param success   成功的回调
 *  @param failure   失败的回调
 */
+ (void)fetchDeviceStatusDataListWithDeviceId:(NSString *)deviceId
                                    startDate:(NSString *)startDate
                                      endDate:(NSString *)endDate
                                     pageRows:(NSString *)pageRows
                                    pageIndex:(NSString *)pageIndex
                                      success:(HETSuccessBlock)success
                                      failure:(HETFailureBlock)failure;





/**
 *  获取蓝牙历史数据
 *
 *  @param deviceId  设备标识
 *  @param order     排序方式（0-降序 1-升序 默认0-降序）
 *  @param pageRows  每页显示的行数(默认20)
 *  @param pageIndex 当前页（默认1）
 *  @param success   成功的回调
 *  @param failure   失败的回调
 */
+(void)fetchHistoryWithDeviceId:(NSString *)deviceId
                      withOrder:(NSUInteger)order
                   withPageRows:(NSUInteger)pageRows
                  withPageIndex:(NSUInteger)pageIndex
                        success:(HETSuccessBlock)success
                        failure:(HETFailureBlock)failure;






/**
 *  普通网络请求   “accessToken”  “timestamp”  “appId” 会自动添加
 *
 *
 *  @param method     HTTP网络请求方法
 *  @param requestUrl 网络请求的URL
 *  @param params     请求参数
 *  @param needSign   是否需要签名
 *  @param success    网络请求成功的回调
 *  @param failure    网络请求失败的回调
 */
+(void)startRequestWithHTTPMethod:(HETRequestMethod)method
                   withRequestUrl:(NSString *)requestUrl
                    processParams:(NSDictionary *)params
                         needSign:(BOOL)needSign
                 BlockWithSuccess:(HETSuccessBlock)success
                          failure:(HETFailureBlock)failure;

/**
 *  普通网络请求   “accessToken”  “timestamp”  “appId” 会自动添加
 *
 *
 *  @param method     HTTP网络请求方法
 *  @param requestUrl 网络请求的URL
 *  @param params     请求参数
 *  @param needSign   是否需要签名
 *  @param clife      是否为Clife接口 
 *  @param success    网络请求成功的回调
 *  @param failure    网络请求失败的回调
 */
+(void)startRequestWithHTTPMethod:(HETRequestMethod)method
                   withRequestUrl:(NSString *)requestUrl
                    processParams:(NSDictionary *)params
                         needSign:(BOOL)needSign
                            clife:(BOOL)clife
                 BlockWithSuccess:(HETSuccessBlock)success
                          failure:(HETFailureBlock)failure;





/**
 *  上传文件的接口
 *
 *  @param requestUrl 网络请求的URL
 *  @param params     请求参数
 *  @param success    网络请求成功的回调
 *  @param failure    网络请求失败的回调
 */

+(void)startMultipartFormDataRequestWithRequestUrl:(NSString *)requestUrl
                                     processParams:(NSDictionary *)params
                                    uploadFileInfo:(NSArray<HETFileInfo *>*)fileInfoArray
                                  BlockWithSuccess:(HETSuccessBlock)success
                                           failure:(HETFailureBlock)failure;


/**
 *  普通网络请求
 *
 *
 *  @param method     HTTP网络请求方法，MultipartFormData模式的时候填HETRequestMethodMultipart
 *  @param requestUrl 网络请求的URL
 *  @param params     请求参数
 *  @param fileInfoArray MultipartFormData模式的时候需要上传的文件内容
 *  @param success    网络请求成功的回调
 *  @param failure    网络请求失败的回调
 */
+(void)generalHTTPRequestWithHTTPMethod:(HETRequestMethod)method
                   withRequestUrl:(NSString *)requestUrl
                    processParams:(NSDictionary *)params
                  uploadFileInfo:(NSArray<HETFileInfo *>*)fileInfoArray
                 BlockWithSuccess:(HETSuccessBlock)success
                          failure:(HETFailureBlock)failure;

/**
 *  proxyHttpWithHet JS接口调用app端HTTP功能（带het业务）
 *
 *  @param host    http请求地址
 *  @param path    http接口的path
 *  @param paramJson   配置http参数，以及http请求参数
 *  @param success    网络请求成功的回调
 *  @param failure    网络请求失败的回调
 
 */
+(void)proxyHttpWithHet:(NSString *)host path:(NSString *)path paramJson:(NSString *)paramJson BlockWithSuccess:(HETSuccessBlock)success
                failure:(HETFailureBlock)failure;

@end

