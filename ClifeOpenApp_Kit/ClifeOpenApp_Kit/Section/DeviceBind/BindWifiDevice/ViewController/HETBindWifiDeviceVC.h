//
//  HETSearchDeviceVC.h
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/9/2.
//  Copyright © 2017年 het. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HETBindWifiDeviceVC : UIViewController
/** 设备信息 **/
@property(nonatomic,strong) HETDevice       *device;
/** 热点ssid **/
@property(nonatomic,copy) NSString          *ssid;
/** 热点密码 **/
@property(nonatomic,copy) NSString          *password;
@end
