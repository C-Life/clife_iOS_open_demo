//
//  instructionsPageView.h
//  HETPublicSDK_DeviceBind
//
//  Created by hcc on 16/8/30.
//  Copyright © 2016年 HET. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HETInstructionsPageView : UIView
/** 设备信息 **/
@property(nonatomic,strong) HETDevice       *device;
-(void)addwebview;
@end
