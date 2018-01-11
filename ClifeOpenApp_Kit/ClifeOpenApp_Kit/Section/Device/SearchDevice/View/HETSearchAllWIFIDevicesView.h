//
//  HETSearchAllWIFIDevicesView.h
//  HETPublicSDK_DeviceBind
//
//  Created by hcc on 16/8/30.
//  Copyright © 2016年 HET. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^bindingSuccessBlock)(void);
typedef void(^bindingFailureBlock)(void);

@interface HETSearchAllWIFIDevicesView : UIView
@property(nonatomic,strong)NSMutableArray   *devicesDataSource;
@property(nonatomic,assign)NSInteger        deviceTypeId;
@property(nonatomic,assign)NSInteger        deviceSubtypeId;
@property(nonatomic,assign)NSInteger        productId;
@property(nonatomic,strong)NSString         *deviceId;
@property(nonatomic,strong)NSString         *deviceIcon;
@property(assign,nonatomic)BOOL             bShowToastView;//是否需要提示语,默认不需要

@property(nonatomic,copy)  NSString         *productName;
@property(strong,nonatomic)UITableView      *scanDeviceTableView;

@property(nonatomic,copy)  bindingSuccessBlock bindSuccess;
@property(nonatomic,copy)  bindingFailureBlock bindFailure;

// 绑定
- (void)startBinding;
@end
