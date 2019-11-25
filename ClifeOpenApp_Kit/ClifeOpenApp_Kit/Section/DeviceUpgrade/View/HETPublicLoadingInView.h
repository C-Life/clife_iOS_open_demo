//
//  HETPublicLoadingInView.h
//  HETPublicSDK_Core
//
//  Created by tl on 16/5/6.
//  Copyright © 2016年 HET. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,LoadingState){
    LoadingStatePreLoading,
    LoadingStateSuccess,
    LoadingStateLoading,
    LoadingStateFailure,
};

@interface HETPublicLoadingInView : UIView

/**
 *  vc内loading动画
 *
 *  @param superview 在哪个视图显示，用于页面布局，我已经帮你addsubview了~！！！
 *  @param y         距离superview顶部距离
 */
+(instancetype)inView:(UIView *)superview y:(CGFloat)y;

/**
 *  设置状态
 */
-(void)setLoadingState:(LoadingState)state;
@end
