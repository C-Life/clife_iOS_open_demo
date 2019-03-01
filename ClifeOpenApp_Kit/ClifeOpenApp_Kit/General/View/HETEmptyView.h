//
//  HETEmptyView.h
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2018/7/31.
//  Copyright © 2018年 het. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ NetWorkError)(void);
typedef NS_ENUM(NSInteger, HETEmptyViewState)
{
    HETEmptyViewStateUnknow = 0,
    HETEmptyViewStateLoading = 1 << 2,
    HETEmptyViewStateNoData = 1 << 3,
    HETEmptyViewStateError = 1 << 4,
};

@interface HETEmptyView : UIView
@property (nonatomic,assign) HETEmptyViewState emptyState;
@property (nonatomic,strong) NetWorkError netWorkErrorBlock;
@end
