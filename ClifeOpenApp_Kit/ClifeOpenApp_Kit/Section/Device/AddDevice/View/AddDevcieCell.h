//
//  AddDevcieCell.h
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/9/1.
//  Copyright © 2017年 het. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDevcieCell : UITableViewCell
+ (instancetype)initWithTableView:(UITableView *)tabbleView;

- (void)refreshData:(NSDictionary *)deviceDict;

- (void)refreshData1:(NSDictionary *)deviceDict;
@end
