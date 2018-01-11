//
//  instructionsPageView.h
//  HETPublicSDK_DeviceBind
//
//  Created by hcc on 16/8/30.
//  Copyright © 2016年 HET. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HETinstructionsPageView : UIView
@property(nonatomic,strong)NSArray    *deviceTypeArray; //设备大小类类型字典类型的数组
@property(nonatomic,assign)NSInteger  bindType;         //绑定类型（1-WiFi  2-蓝牙）
-(void)addwebview;
@end
