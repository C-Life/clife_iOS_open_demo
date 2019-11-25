//
//  HETDeviceVersionModel.h
//  HETOpenSDKDemo
//
//  Created by mr.cao on 2017/4/21.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HETDeviceVersionModel : NSObject
@property (nonatomic, copy) NSString *deviceVersionId;

@property (nonatomic, copy) NSString *oldDeviceVersion;

@property (nonatomic, copy,getter=theNewDeviceVersion) NSString *newDeviceVersion;

/*
 * 注：当wifi设备有蓝牙固件升级时，filePath为蓝牙固件升级文件路径，deviceBleFirmId为蓝牙固件版本信息号，其他信息与之前含义一样。
 注：当蓝牙设备有多固件升级时，filePath为蓝牙固件升级文件路径，pcbFilePath为pcb固件升级文件路径。201707111600新增
 */
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *pcbFilePath;
@property (nonatomic, copy) NSString *releaseNote;

/**
 *  蓝牙固件版本信息号
 */
@property (nonatomic, copy) NSString *deviceBleFirmId;

@property (nonatomic, assign) NSInteger status;
@end

@interface HETDeviceVersionModel (NeedUpgrade)
/**
 *  普通的是否需要升级（下面两个主要是因为有联动升级的原因）
 */
-(BOOL)normalNeedUpgrade;


-(BOOL)wifiNeedUpgrade;
-(BOOL)bleNeedUpgrade;
@end
