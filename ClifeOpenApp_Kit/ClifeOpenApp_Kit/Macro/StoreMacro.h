//
//  StoreMacro.h
//  HETOpenPlatformSDKDemo
//
//  Created by miao 2017/8/25.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#ifndef StoreMacro_h
#define StoreMacro_h

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark - 设备尺寸相关
//屏幕尺寸
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//屏幕适配
#define  BasicHeight  (1/iPhone6Height*(IS_IPHONE_4?iPhone6Height:ScreenHeight))
#define  BasicWidth  (1/iPhone6Width*ScreenWidth)

//判断是否为iPad
#define ISPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断高度是否为480的iphone
#define IS_IPHONE_4 (IS_IPHONE && ScreenHeight == 480.0)
//判断高度是否为568的iphone
#define IS_IPHONE_5 (IS_IPHONE && ScreenHeight == 568.0)
//判断高度是否为667的iphone
#define IS_IPHONE_6 (IS_IPHONE && ScreenHeight == 667.0)
//判断高度是否为736的iphone
#define IS_IPHONE_6P (IS_IPHONE && ScreenHeight == 736.0)

//苹果6的宽高
#define  iPhone6PWidth 414.0
#define  iPhone6PHeight 736.0
#define  iPhone6Width 375.0
#define  iPhone6Height 667.0

//以iPhone5做设计稿时，各个宽度长度信息可以乘以这个系数
#define SizeScaleWidth  ((ScreenHeight>480)?ScreenWidth/320:1.0)
#define SizeScaleHeight ((ScreenHeight>480)?ScreenHeight/568:1.0)

//以iphone6 做设计稿时，各个宽度长度信息可以乘以这个系数， 高度并未把固定的64的导航栏计算在其中
#define ScaleWidth (ScreenWidth/375)
#define ScaleHeight (ScreenHeight/667)

//常用高度-leoo
#define IPX_STATUSBAROFFSETHEIGHT   ((kDevice_Is_iPhoneX) ? 24.0 : 0.0)
#define IPX_HOMEINDICATORHEIGHT     ((kDevice_Is_iPhoneX) ? 34.0 : 0.0)

#define IPX_HOMEINDICATOR_BOTTOMBAROFFSESTHEIGHT     ((kDevice_Is_iPhoneX) ? 12.0 : 0.0)
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//导航栏背景颜色
#define NavBarColor [UIColor colorFromHexRGB:@"3285ff"]
//#define NavBarColor [UIColor colorFromHexRGB:@"f4f4f4"]
//控制器的背景颜色
#define VCBgColor [UIColor colorFromHexRGB:@"efeff4"]

//导航栏字体颜色
#define NavTitleColor [UIColor colorFromHexRGB:@"ffffff"]
//#define NavTitleColor [UIColor colorFromHexRGB:@"333333"]

//字体大小
#define OPFont(fontSize) [UIFont systemFontOfSize:(fontSize)]

//颜色十六进制转换RGB
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark - weakself strongself 字典数据安全处理，
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

#define SAFE_STRING(str) (![str isKindOfClass: [NSString class]] ? @"" : str)

#define SAFE_STRING2(str) (![str isKindOfClass: [NSString class]] ? @"--" : str)

#define SAFE_NUMBER(value) (![value isKindOfClass: [NSNumber class]] ? @(-1) : value)

#ifdef DEBUG //... 可变参数
#define  OPLog(...) NSLog(@"%s %d \n %@ \n\n",__func__,__LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#else
#define  OPLog(...)
#endif




/*
 *  极光推送
 */
//NSString *const KHETJPushAppKey = @"9ea4168ff668fb5cd79f3788";


#endif
