//
//  HETBindGPRSDeviceVC.h
//  ClifeOpenApp_Kit
//
//  Created by miao on 2018/1/16.
//  Copyright © 2018年 het. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HETBindGPRSDeviceVC : UIViewController
/** 设备信息 **/
@property(nonatomic,strong) HETDevice *device;

/** IMEI码 **/
@property (copy,nonatomic) NSString *imei;

/** mac地址 **/
@property (copy,nonatomic) NSString *mac;

/** mac地址 **/
@property (copy,nonatomic) NSString *productId;
@end
