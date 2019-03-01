//
//  DeviceDetailsVC.h
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2018/5/17.
//  Copyright © 2018年 het. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ScaneDebug) (NSString *h5path);

@interface DeviceDetailsVC : UIViewController
/** 设备信息 **/
@property (nonatomic,strong)  HETDevice *deviceModel;

@property (nonatomic, copy) ScaneDebug scanDebug;
@end
