//
//  HETWiFiDeviceH5ViewController.h
//  HETPublicSDK_HETH5DeviceControl
//
//  Created by mr.cao on 2018/3/30.
//  Copyright © 2018年 HET. All rights reserved.
//

#import "HETH5ContainBaseViewController.h"
#import "HETDeviceControlBusiness.h"
@interface HETWiFiDeviceH5ViewController : HETH5ContainBaseViewController
/** 小循环控制的key **/
@property(nonatomic, strong) NSString             *deviceKey;

/** 业务控制模型 **/
@property(nonatomic, strong) HETDeviceControlBusiness *wifiBusiness;
@end
