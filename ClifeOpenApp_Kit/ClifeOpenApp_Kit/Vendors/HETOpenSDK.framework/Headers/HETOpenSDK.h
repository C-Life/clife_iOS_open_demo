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
#import "HETReachability.h"
#import "HETBLESmartLink.h"
extern NSString *const HETLoginOffNotification;
typedef NS_ENUM(NSUInteger,HETNetWorkConfigType)
{
    HETNetWorkConfigType_ITE=0,//内部测试环境
    HETNetWorkConfigType_ETE,//测试环境
    HETNetWorkConfigType_PRE,//预发布环境
    HETNetWorkConfigType_PE,//正式发布环境
    HETNetWorkConfigType_EU,//欧洲发布环境
};

typedef NS_ENUM (NSInteger, HETAuthPlatformType) {
    HETAuthPlatformType_Wechat   = 0,    // 微信
    HETAuthPlatformType_Weibo    = 1,    // 微博
    HETAuthPlatformType_QQ       = 2,    // QQ
};


typedef NS_ENUM(NSInteger, HETNetworkLocalization) {
    HETNetworkLocalization_zh_CN,  //    zh_CN  简体中文 zh-Hans-CN
    HETNetworkLocalization_zh_TW,  //    zh_TW  繁体中文（台湾）
    HETNetworkLocalization_zh_HK,  //    zh_HK  繁体中文（香港）
    HETNetworkLocalization_en,  //    en    英语
    HETNetworkLocalization_fr,  //    fr    法语
    HETNetworkLocalization_de,  //    de    德语
    HETNetworkLocalization_ja,  //    ja    日语
    HETNetworkLocalization_it,  //    it    意大利语
    HETNetworkLocalization_es,  //    es    西班牙语
    HETNetworkLocalization_ko,  //    ko    韩语
};

@class HETAuthorizeTheme;
@interface HETOpenSDK : NSObject
@property (nonatomic, assign,readonly) HETNetWorkConfigType currentNetWorkConfigType;        // 当前的网络环境
@property (assign, nonatomic) HETNetworkLocalization localizationType;     // 当前语言版本，默认简体中文
@property (nonatomic,strong)NSString *openId;
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
 *  第三方应用填入授权信息
 *
 *  @param openId    授权用户唯一标识
 *  @param accessToken 接口调用凭证
 *  @param refreshToken 用于调用accessToken，接口获取授权后的accessToken
 *  @param expiresIn accessToken接口调用凭证超时时间，单位（秒）
 *  @param account 帐号：手机号码或邮箱
 *
 */
+ (void)registerOpenId:(NSString *)openId
        accessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken expiresIn:(NSString *)expiresIn;


/**
 *  网络环境配置,需要配置。默认没环境
 *
 *  @param  netWorkConfigType 环境类型
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
