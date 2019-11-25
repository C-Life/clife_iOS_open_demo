//
//  HETBindBleDeviceVC.h
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/9/18.
//  Copyright © 2017年 het. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HETBindBleDeviceVC : UIViewController
/** 设备信息 **/
@property(nonatomic,strong) HETDevice       *device;

// 下面两个参数是给moduleId = 64的产品用的
/** 热点ssid **/
@property(nonatomic,copy) NSString          *ssid;
/** 热点密码 **/
@property(nonatomic,copy) NSString          *password;
@end
