//
//  HETBindAPDeviceVC.h
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/9/20.
//  Copyright © 2017年 het. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HETBindAPDeviceVC : UIViewController
/** 设备信息 **/
@property(nonatomic,strong) HETDevice       *device;
/** 热点ssid **/
@property(nonatomic,copy) NSString          *ssid;
/** 热点密码 **/
@property(nonatomic,copy) NSString          *password;
@end
