//
//  BLEDataEncodeAndDecode.h
//  HETOpenSDKDemo
//
//  Created by mr.cao on 2017/4/12.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface HETEncodeAndDecodeData : NSObject

/**
 

 @param productId       设备的productId
 @param deviceTypeId    设备的大类deviceTypeId
 @param deviceSubtypeId 设备的小类deviceSubtypeId

 @return 实例化对象
 */
- (instancetype)initWithProductId:(NSUInteger)productId deviceTypeId:(NSUInteger)deviceTypeId deviceSubtypeId:(NSUInteger)deviceSubtypeId;


/**
 根据命令字，发送的数据字典组包

 @param command 命令字
 @param dic     发送的数据字典

 @return 数据包
 */
-(NSData *)encodeDataWithCommand:(NSString *)command  commandDictionary:(NSDictionary *)dic;


/**
 根据命令字，收到的数据解包为字典

 @param command 命令字
 @param data    收到的数据（data为空的时候获取默认的协议字段的字典，方便给页面初始化使用）

 @return 解包为字典
 */
-(NSDictionary *)decodeDataWithCommand:(NSString *)command  data:(NSData *)data;

@end
