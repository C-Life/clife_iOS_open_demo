//
//  CBComRefreshFooter.m
//  CBeauty
//
//  Created by leoo on 2018/3/5.
//  Copyright © 2018年 wff. All rights reserved.
//

#import "HETComRefreshFooter.h"

@interface HETComRefreshFooter()
@property (nonatomic, strong) LOTAnimationView *laAnimation;
@end

@implementation HETComRefreshFooter

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 46;
    
    // 添加 lottie
    LOTAnimationView *lotView = [LOTAnimationView animationNamed:@"Lottie_RefreshHeader"];
    lotView.loopAnimation = YES;
    lotView.animationSpeed = 2.0;
    lotView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:lotView];
    self.laAnimation = lotView;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.laAnimation.frame = CGRectMake(0, 0, self.bounds.size.width, 15.0);
    self.laAnimation.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5 - 5.0);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            
            [self.laAnimation stop];
            break;
        case MJRefreshStatePulling:
            
            [self.laAnimation stop];
            break;
        case MJRefreshStateRefreshing:
            
            if (! self.laAnimation.isAnimationPlaying) {
                [self.laAnimation play];
            }
            break;
        case MJRefreshStateNoMoreData:
            
            [self.laAnimation stop];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    if (0.6 <= pullingPercent) {
        if (! self.laAnimation.isAnimationPlaying) {
            [self.laAnimation play];
        }
    } else if (0.3 > pullingPercent) {
        [self.laAnimation stop];
    }
}
@end
