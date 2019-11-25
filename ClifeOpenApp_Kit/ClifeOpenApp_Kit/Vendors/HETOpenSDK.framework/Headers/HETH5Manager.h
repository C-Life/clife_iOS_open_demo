//
//  HETH5Manager.h
//  HETOpenSDK
//
//  Created by mr.cao on 2017/11/24.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HETH5Manager : NSObject

/**
 *  请在程序启动时调用
 *
 *
 */
+(void)launch;

+(instancetype)shareInstance;

/**
 获取H5地址
 @param h5Path 定位到page页面
 @param needRefresh 是否需要刷新页面（本地存在的话，会先返回地址，更新成功后再次返回地址）
 @param h5ConfigLibVersion h5的配置版本，用于区分新老容器
 @param error 错误信息
 @param progressBlock 下载进度
 @param productId 产品id，不可为空
 */
-(void)getH5Path:(void (^)(NSString *h5Path,BOOL needRefresh,NSString *h5ConfigLibVersion,NSError *error))block downloadProgressBlock:(void (^)(NSProgress *progress))progressBlock productId:(NSString *)productId;
@end
