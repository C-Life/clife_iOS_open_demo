//
//  HETAddDeviceTopView.h
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/8/31.
//  Copyright © 2017年 het. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TopViewBlock)(NSInteger index);
@interface HETAddDeviceTopView : UIView
@property (nonatomic,strong) NSMutableArray                     *imageArr;
@property (nonatomic,copy) TopViewBlock                         selectIndex;
@end
