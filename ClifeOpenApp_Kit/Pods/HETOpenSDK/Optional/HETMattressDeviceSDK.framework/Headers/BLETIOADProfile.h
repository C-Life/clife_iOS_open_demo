/*
 BLETIOADProfile.h
 TIOADExample

 Created by Ole Andreas Torvmark on 11/22/12.
 Copyright (c) 2013 Texas Instruments. All rights reserved.

 */

#import "CLBLEDataSource.h"
#import <UIKit/UIKit.h>
#import "CLBLEManager.h"

#define HI_UINT16(a) (((a) >> 8) & 0xff)
#define LO_UINT16(a) ((a) & 0xff)
/**
 *  TIOAD空中升级代理方法，升级进度和升级失败代理
 */
@protocol OADUpgradeHandleDelegate<NSObject>
/**
 *  升级进度
 *
 *  @param progress 升级进度
 */
-(void)OADUpgradeHandleProgress:(float)progress;

/**
 *  升级失败
 */
-(void)OADUpgradeHandleFail;
@end
@interface BLETIOADProfile : NSObject <UIActionSheetDelegate,UIAlertViewDelegate>

@property (weak  ,nonatomic)id<OADUpgradeHandleDelegate>delegate;

@property (strong,nonatomic) NSData *imageFile;

@property (strong,nonatomic) UIView *view;
@property (weak,nonatomic) NSObject<CLBLEDataSource>* child;
@property int nBlocks;
@property int nBytes;
@property int iBlocks;
@property int iBytes;
@property BOOL canceled;
@property BOOL inProgramming;
@property BOOL start;
@property (nonatomic,retain) NSTimer *imageDetectTimer;
@property uint16_t imgVersion;
@property UINavigationController *navCtrl;
@property (nonatomic,copy) NSString* BLEBroadName;



/**
 *  OAD 空中升级
 *
 *  @param binData 需要升级的BIN文件
 */
- (void)initUpgradeData:(NSData *)binData;

@end
