//
//  HETAppConfigTool.h
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2019/5/24.
//  Copyright © 2019年 het. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HETAppConfigTool : NSObject
+(void)saveAppId:(NSString *)appId;

+(void)saveAppSecret:(NSString *)appSecret;

+(void)saveNetWorkConfigType:(HETNetWorkConfigType)netWorkConfigType;

+(void)saveLoginUIVersion:(NSString *)loginUIVersion;

+(void)saveAppId:(NSString *)appId saveAppSecret:(NSString *)appSecret;

+(NSString *)getAppId;

+(NSString *)getAppSecret;

+(HETNetWorkConfigType)getNetWorkConfigType;

+(NSString *)getLoginUIVersion;

+(BOOL)cleanChace;
@end

