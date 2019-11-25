//
//  HETDeviceShareBusiness.h
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/7/11.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HETNetWorkRequestHeader.h"

typedef NS_ENUM(NSInteger,HETDeviceShareType) {
    HETDeviceShareType_FaceToFaceShare=5,
    HETDeviceShareType_ThirthShare=6,
};

@interface HETDeviceShareBusiness : NSObject

/**
 *  1.获取分享码
 *
 *  @param deviceId 分享的设备（加密的）
 *  @param shareType  分享方式 （5 -面对面；6-远程分享）
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
+(void)getShareCodeWithDeviceId:(NSString *)deviceId
                      shareType:(HETDeviceShareType)shareType
                        success:(HETSuccessBlock)success
                        failure:(HETFailureBlock)failure;

/**
 *  2.授权分享
 *
 *  @param shareCode 分享码
 *  @param shareType  分享方式 （5 -面对面；6-远程分享）
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
+(void)authShareDeviceWithShareCode:(NSString *)shareCode
                          shareType:(HETDeviceShareType)shareType
                            success:(HETSuccessBlock)success
                            failure:(HETFailureBlock)failure;

/**
 *  3.设备授权删除
 *
 *  @param deviceId  设备标识
 *  @param userId 用户标识，为空时表示删除所有授权信息或被授权人的授权信息 【2015-11-24修改为非必填参数】
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
+(void)deviceAuthDelWithDeviceId:(NSString *)deviceId
                          userId:(NSString *)userId
                         success:(HETSuccessBlock)success
                         failure:(HETFailureBlock)failure;

/**
 *  4.获取设备授权的用户
 *
 *  @param deviceId  设备标识
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */

+(void)deviceGetAuthUserWithDeviceId:(NSString *)deviceId
                             success:(HETSuccessBlock)success
                             failure:(HETFailureBlock)failure;

@end
