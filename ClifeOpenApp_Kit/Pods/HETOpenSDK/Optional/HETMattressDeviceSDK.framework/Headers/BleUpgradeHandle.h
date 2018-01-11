//
//  BleUpgradeHandle.h
//  CSleep
//
//  Created by Jerry on 15-5-5.
//  Copyright (c) 2015年 HeT.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLBLEManager.h"
#import <UIKit/UIKit.h>
#import "CLBLEDataSource.h"
/**
 *  普通蓝牙空中升级代理方法，升级进度和升级失败代理
 */
@protocol BleUpgradeHandleDelegate<NSObject>

/**
 *  升级进度
 *
 *  @param progress 升级进度
 */
-(void)BleUpgradeHandleProgress:(float)progress;


/**
 *  升级失败
 */
-(void)BleUpgradeHandleFail;


@end

@interface BleUpgradeHandle : NSObject
@property (nonatomic,weak)id<BleUpgradeHandleDelegate>delegate;
@property (nonatomic,weak) NSObject<CLBLEDataSource>* child;
@property (nonatomic,copy) NSString* BLEBroadName;

/**
 * 普通蓝牙空中升级
 *
 *  @param binData 需要升级的BIN文件
 */
- (void)initUpgradeData:(NSData *)binData;


@end
