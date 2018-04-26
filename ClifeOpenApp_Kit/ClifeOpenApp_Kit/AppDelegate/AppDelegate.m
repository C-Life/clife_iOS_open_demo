//
//  AppDelegate.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/8/25.
//  Copyright © 2017年 het. All rights reserved.
//

#import "AppDelegate.h"

#import "HETDeviceListVC.h"
#import "HETNavigationVC.h"
#import <Bugly/Bugly.h>

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define kTestAPPKEY @"30765"
#define kTestAPPSECRET @"5f699a78c319444cb8a291296049572c"


#define WX_APP_KEY      @"xxxxxxx"
#define WX_APP_SECRET   @"xxxxxxx"

#define QQ_APP_ID       @"xxxxxx"
#define QQ_APP_KEY      @"xxxxxxx"

NSString *const KHETJPushAppKey = @"xxxxxxx";
#define WB_APP_KEY      @"xxxxxxx"
#define WB_APP_SECRET   @"xxxxxxx"
#define WB_RedirectURL  @"http://www.clife.net"

static NSString *KHETJPushchannel = @"Publish channel";
static BOOL isProduction = FALSE;


@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // 1.注册第三方应用
    [HETOpenSDK registerAppId:kTestAPPKEY appSecret:kTestAPPSECRET];
    [HETOpenSDK setNetWorkConfig:HETNetWorkConfigType_PE];
    [HETOpenSDK openLog:true];

    // 第三方登录
//    [HETOpenSDK setPlaform:HETAuthPlatformType_QQ appKey:QQ_APP_ID appSecret:nil redirectURL:nil];
//    [HETOpenSDK setPlaform:HETAuthPlatformType_Weibo appKey:WB_APP_KEY appSecret:WB_APP_SECRET redirectURL:WB_RedirectURL];
//    [HETOpenSDK setPlaform:HETAuthPlatformType_Wechat appKey:WX_APP_KEY appSecret:WX_APP_SECRET redirectURL:nil];

    // 2.设置导航栏相关
    // 设置全局状态栏为白色、全局导航栏标题颜色,文字大小,背景颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UINavigationBar appearance].titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:NavTitleColor};
    [UINavigationBar appearance].barTintColor = NavBarColor;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    // 3.设置主页
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    HETDeviceListVC *homePageVC = [[HETDeviceListVC alloc] init];
    HETNavigationVC *navVC = [[HETNavigationVC alloc]initWithRootViewController:homePageVC];
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];

    // 4.添加bugly检测
    //    AppID：
    //    1fc69c148a
    //    AppKey：
    //    4f64a319-71f5-49f3-a04c-a0edfd213e1a
    [Bugly startWithAppId:@"1fc69c148a"];

    // 5.注册、开启极光推送
    [self jPushSetting:launchOptions];

    // 6.H5设备公共包
    [HETH5Manager launch];

    return YES;
}

- (void)jPushSetting:(NSDictionary *)launchOptions{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:KHETJPushAppKey
                          channel:KHETJPushchannel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];

    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        OPLog(@"%@",registrationID);
    }];

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 将URL转成字符串
    NSString *urlString = url.scheme;
    // 在ipod ios9.0 设备上大写不会自动转为小写
    urlString = [urlString lowercaseString];
    if ([urlString isEqualToString:@"hetopenplatform"]) {
        NSString *shareCode = [[url.host  componentsSeparatedByString:@"="] lastObject];
        [HETDeviceShareBusiness authShareDeviceWithShareCode:shareCode shareType:HETDeviceShareType_ThirthShare success:^(id responseObject) {
            OPLog(@"responseObject == %@",responseObject);
            [HETCommonHelp showHudAutoHidenWithMessage:GetDeviceControlAuthSuccess];
            [[NSNotificationCenter defaultCenter] postNotificationName:kBindDeviceSuccess object:nil];

        } failure:^(NSError *error) {
            OPLog(@"error == %@",error);
            [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
        }];
        return YES;
    }else{
        BOOL result = [HETOpenSDK application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
        return result;
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [HETOpenSDK handleOpenURL:url];
    return result;
}

#pragma -mark push
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    HETAuthorize  *auth = [[HETAuthorize alloc]init];
    if([auth isAuthenticated]){
        [JPUSHService setTags:nil alias:@"abc" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            OPLog(@"iTags == %@ iAlias === %@",iTags, iAlias);
        }];
    }
    /// Required - 注册 DeviceToken
    dispatch_async(dispatch_get_main_queue(), ^{
        [JPUSHService registerDeviceToken:deviceToken];
    });

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    OPLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);  // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

