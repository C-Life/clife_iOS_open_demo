//
//  DeviceSubTypeCell.h
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/9/13.
//  Copyright © 2017年 het. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HETDeviceSubTypeCell : UITableViewCell
+ (instancetype)initWithTableView:(UITableView *)tabbleView;

- (void)refreshData:(NSDictionary *)deviceDict;
@end
