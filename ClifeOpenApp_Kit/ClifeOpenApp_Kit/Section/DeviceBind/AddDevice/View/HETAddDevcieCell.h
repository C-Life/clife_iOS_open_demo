//
//  AddDevcieCell.h
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/9/1.
//  Copyright © 2017年 het. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HETAddDevcieCell : UITableViewCell
+ (instancetype)initWithTableView:(UITableView *)tabbleView;

- (void)refreshMainType:(NSDictionary *)deviceDict;

- (void)refreshSubType:(NSDictionary *)deviceDict;
@end
