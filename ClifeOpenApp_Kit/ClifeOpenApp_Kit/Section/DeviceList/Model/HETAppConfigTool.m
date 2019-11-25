//
//  HETAppConfigTool.m
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2019/5/24.
//  Copyright © 2019年 het. All rights reserved.
//

#import "HETAppConfigTool.h"

@implementation HETAppConfigTool
+(void)saveAppId:(NSString *)appId
{
    [[NSUserDefaults standardUserDefaults]setObject:appId forKey:kUserDefaultAppId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveAppSecret:(NSString *)appSecret
{
    [[NSUserDefaults standardUserDefaults]setObject:appSecret forKey:kUserDefaultAppSecret];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveNetWorkConfigType:(HETNetWorkConfigType)netWorkConfigType
{
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithUnsignedInteger:netWorkConfigType] forKey:kUserDefaultNetWorkConfig];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveLoginUIVersion:(NSString *)loginUIVersion
{
    [[NSUserDefaults standardUserDefaults]setObject:loginUIVersion forKey:kUserDefaultLoginUIVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveAppId:(NSString *)appId saveAppSecret:(NSString *)appSecret
{
    [[NSUserDefaults standardUserDefaults]setObject:appId forKey:kUserDefaultAppId];
    [[NSUserDefaults standardUserDefaults]setObject:appSecret forKey:kUserDefaultAppSecret];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



+(NSString *)getAppId
{
    NSString *appId= [[NSUserDefaults standardUserDefaults]objectForKey:kUserDefaultAppId];
    if (appId.length> 0) {
        OPLog(@"{\n\n当前appId 缓存 %@\n\n}",appId);
        return appId;
    }

    OPLog(@"{\n\n当前appId HET_IS_ENTERPRISE == %d %@\n\n}",HET_IS_ENTERPRISE,kTestAPPKEY);
    return kTestAPPKEY;
}

+(NSString *)getAppSecret
{
    NSString *appSecret= [[NSUserDefaults standardUserDefaults]objectForKey:kUserDefaultAppSecret];
    if (appSecret.length> 0) {
        return appSecret;
    }
    return kTestAPPSECRET;
}

+(HETNetWorkConfigType)getNetWorkConfigType
{
    //缓存用户默认配置，防止每次重启后都需要重新登录的问题。
    id object =  [[NSUserDefaults standardUserDefaults]objectForKey:kUserDefaultNetWorkConfig] ;
    if (object) {
        NSNumber *networkType = (NSNumber *)object;
        return  networkType.unsignedIntegerValue;
    }
    return HETNetWorkConfigType_PE;
}

+(NSString *)getLoginUIVersion
{
    NSString *loginUIVersion= [[NSUserDefaults standardUserDefaults]objectForKey:kUserDefaultLoginUIVersion];
    if (loginUIVersion.length > 0) {
        return loginUIVersion;
    }
    return @"2";
}

+(BOOL)cleanChace
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUserDefaultAppId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUserDefaultAppSecret"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUserDefaultNetWorkConfig"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUserDefaultLoginUIVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *appId= [[NSUserDefaults standardUserDefaults]objectForKey:kUserDefaultAppId];
    if (appId.length> 0) {
        return NO;
    }
    return YES;
}
@end
