//
//  YJSelectionView.h
//  YJSelectionView
//
//  Created by Jake on 2017/5/25.
//  Copyright © 2017年 Jake. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^CompleteSelection)(NSInteger index);
typedef  void (^CloseDevicesListViewBlock)();

@interface DeviceSelectionView : UIView
@property (nonatomic,strong) UITableView                             *devicesTableView;
@property (nonatomic,strong) NSArray                                 *subTypeDeviceArr;
@property (nonatomic,copy) CompleteSelection                       completeSelection;
@property (nonatomic,copy) CloseDevicesListViewBlock               closeDevicesListView;
@end
