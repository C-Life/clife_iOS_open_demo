//
//  HETSearchDeviceVC.h
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/9/2.
//  Copyright © 2017年 het. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HETSearchDeviceVC : UIViewController
/** 绑定类型 (1-WiFi  2-蓝牙) **/
@property(assign,nonatomic)NSInteger  bindType;
/** 产品ID **/
@property(nonatomic,copy) NSString *productId;
/** 热点ssid **/
@property(nonatomic,copy) NSString *ssid;
/** 热点密码 **/
@property(nonatomic,copy) NSString *password;
@end
