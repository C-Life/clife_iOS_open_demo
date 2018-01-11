//
//  HETOpenSDK.h
//  HETOpenSDK
//
//  Created by mr.cao on 16/4/26.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HETDevice.h"
#import "HETAuthorize.h"
#import "HETDeviceRequestBusiness.h"
#import "HETWIFIBindBusiness.h"
#import "HETDeviceControlBusiness.h"
#import "HETDeviceUpgradeBusiness.h"
#import "HETDeviceShareBusiness.h"
#import "HETPeripheral.h"
#import "HETBLEBusiness.h"
#import "HETApplicationInfoBusiness.h"
#import "HETApplicationMessageBusiness.h"
#import "HETThirdCloudAuthorize.h"
#import "HETDownloadRequestOperation.h"
#import "HETWKWebViewJavascriptBridge.h"
#import "HETH5Manager.h"
extern  NSString * const HETLoginOffNotification;//账号异地登录
typedef NS_ENUM(NSUInteger,HETNetWorkConfigType)
{
    HETNetWorkConfigType_ITE=0,//内部测试环境
    HETNetWorkConfigType_ETE,//测试环境
    HETNetWorkConfigType_PRE,//预发布环境
    HETNetWorkConfigType_PE,//正式发布环境
};

typedef NS_ENUM (NSInteger, HETAuthPlatformType) {
    HETAuthPlatformType_Wechat   = 0,    // 微信
    HETAuthPlatformType_Weibo    = 1,    // 微博
    HETAuthPlatformType_QQ       = 2,    // QQ
};

@class HETAuthorizeTheme;
@interface HETOpenSDK : NSObject
@property (nonatomic, assign,readonly) HETNetWorkConfigType currentNetWorkConfigType;        // 当前的网络环境

+(instancetype)shareInstance;

/**
 *  注册第三方应用
 *
 *  @param appId    注册开发者账号时的appId
 *  @param appSecret 注册开发者账号时的appSecret
 *
 */
+ (void)registerAppId:(NSString *)appId
            appSecret:(NSString *)appSecret;


/**
 *  网络环境配置,需要配置。默认没环境
 *
 *  @param  netWorkConfigType
 */
+ (void)setNetWorkConfig:(HETNetWorkConfigType)netWorkConfigType;
/**
 *  调试log
 *
 *  @param open    设置YES打开log调试日志
 *
 */
+ (void)openLog:(BOOL)open;

/*************************************************************************************************
                            ↓↓↓↓↓         第三方授权相关          ↓↓↓↓↓
 *************************************************************************************************/
/**
 设置第三方平台相关参数

 @param plaformType 第三方平台来源
 @param appKey      第三方appKey
 @param appSecret   第三方appSecret
 @param redirectURL 第三方回调url
 */
+ (void)setPlaform:(HETAuthPlatformType)plaformType
            appKey:(NSString *)appKey
         appSecret:(NSString *)appSecret
       redirectURL:(NSString *)redirectURL;

/**
 获得从sso或者web端回调到本app的回调

 @param url 第三方sdk的打开本app的回调的url
 @return 是否处理  YES代表处理成功，NO代表不处理
 */
+ (BOOL)handleOpenURL:(NSURL *)url;


/**
 获得从sso或者web端回调到本app的回调

 @param application         application
 @param url                 第三方sdk的打开本app的回调的url
 @param sourceApplication   回调来源程序
 @param annotation          annotation
 @return 是否处理  YES代表处理成功，NO代表不处理
 */
+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

/**
 设置授权主题

 @param authorizeTheme 主题参数
 */
+ (void)setAuthorizeTheme:(HETAuthorizeTheme *)authorizeTheme;

@end

// 授权主题
@interface HETAuthorizeTheme : NSObject

@property (nonatomic, strong) NSString *navHeadlineContent;         // 标题
@property (nonatomic, assign) BOOL logoshow;                        // logo显示
@property (nonatomic, assign) BOOL weixinLogin;                     // 微信登录显示
@property (nonatomic, assign) BOOL qqLogin;                         // QQ登录显示
@property (nonatomic, assign) BOOL weiboLogin;                      // 微博登录显示
@property (nonatomic, strong) NSString *loginType;                  // 主题样式（1、2、3）
@property (nonatomic, strong) NSString *navTitleColor;              // 导航标题文字颜色
@property (nonatomic, strong) NSString *loginBtnFontColor;          // 登录按钮文字颜色
@property (nonatomic, strong) NSString *navBackgroundColor;         // 导航颜色
@property (nonatomic, strong) NSString *navBackBtnType;             // 返回按钮(white、black)
@property (nonatomic, strong) NSString *loginBtnBackgroundColor;    // 登录按钮颜色
@property (nonatomic, strong) NSString *loginBtnBorderColor;        // 登录边框颜色

@end
