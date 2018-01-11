//
//  HETDeviceVersionModel.h
//  HETOpenSDKDemo
//
//  Created by mr.cao on 2017/4/21.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HETDeviceVersionModel : NSObject
@property (nonatomic, strong,getter=theNewDeviceVersion) NSString *newDeviceVersion; //新版本号
@property (nonatomic, strong) NSNumber *deviceVersionId;//固件版本Id

@property (nonatomic, strong) NSString *oldDeviceVersion;//旧版本号

@property (nonatomic, strong) NSNumber *deviceBleFirmId;//蓝牙固件id

@property (nonatomic, strong) NSString *filePath; //升级的bin文件路径
@property (nonatomic, strong) NSString *releaseNote;//修改内容



@end
