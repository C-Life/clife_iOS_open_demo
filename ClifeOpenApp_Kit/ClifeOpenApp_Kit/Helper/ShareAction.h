//
//  LHShareAction.h
//  fenxiang
//
//  Created by HeT on 15/5/29.
//  Copyright (c) 2015年 HeT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    SHARE_TO_THIRD_UNKNOW          = -1,
    SHARE_TO_THIRD_WECHAT_SESSION  = 0,
    SHARE_TO_THIRD_WECHAT_TIMELINE = 1,
    SHARE_TO_THIRD_QQ              = 2,
    SHARE_TO_THIRD_QZONE           = 3,
    SHARE_TO_THIRD_WEIBO           = 4,
    
} SHARE_TO_THIRD;

@protocol ShareActionDelegate <NSObject>
- (void)shareWithType:(SHARE_TO_THIRD)sharePlatform;
@end

@interface ShareAction : UIWindow
@property (nonatomic, weak) id<ShareActionDelegate> shareActiondelegate;
/** 分享二维码 **/
@property (nonatomic,strong) UIImage                                           *codeImage;

/** 分享html **/
@property (nonatomic,copy) NSString                                            *webpageUrl;
- (instancetype)initWithItems:(NSArray *)shareItems;
- (void)show;
@property (nonatomic, copy) void (^cancelShare)();
@end
