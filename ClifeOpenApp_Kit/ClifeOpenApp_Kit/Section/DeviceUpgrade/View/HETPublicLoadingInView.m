//
//  HETPublicLoadingInView.m
//  HETPublicSDK_Core
//
//  Created by tl on 16/5/6.
//  Copyright © 2016年 HET. All rights reserved.
//

#import "HETPublicLoadingInView.h"
#import "HETCoreResource.h"
@interface HETPublicLoadingInView()
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,assign)LoadingState state;
@end
@implementation HETPublicLoadingInView

+(instancetype)inView:(UIView *)superview y:(CGFloat)y{
    HETPublicLoadingInView *view = [self new];
    [superview addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview).offset(y);
        make.centerX.equalTo(superview);
        make.size.mas_equalTo(CGSizeMake(160, 114));
    }];
    [view config];
    return view;
}
-(void)config{
    self.backgroundColor = [UIColor clearColor];
    
    self.imageView = [UIImageView new];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //    self.imageView.image = [UIImage imageNamed:@"Core_Loading_Failure"];
    //    self.imageView.image = [UIImage imageNamed:@"Core_Loading_Success"];
    self.imageView.animationImages =@[
                                      [HETCoreResource imageNamed:@"Core_Loading_1"],
                                      [HETCoreResource imageNamed:@"Core_Loading_2"],
                                      [HETCoreResource imageNamed:@"Core_Loading_3"],
                                      [HETCoreResource imageNamed:@"Core_Loading_4"],
                                      [HETCoreResource imageNamed:@"Core_Loading_5"],
                                      [HETCoreResource imageNamed:@"Core_Loading_6"]];
    self.imageView.animationDuration = 1.f;
    self.imageView.animationRepeatCount = INTMAX_MAX;
    self.imageView.image = [HETCoreResource imageNamed:@"H5Loading_Failure"];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil]  subscribeNext:^(id x) {
        @strongify(self);
        [self setLoadingState:self.state];
    }];
}
-(void)setLoadingState:(LoadingState)state{
    self.state = state;
    SEL selectors[] = {
        @selector(preloading),
        @selector(success),
        @selector(startLoading),
        @selector(failure),
    };
    void(*imp)(id, SEL) = (typeof(imp))[self methodForSelector:selectors[state]];
    imp(self, selectors[state]);
}
-(void)preloading{
    [self stopLoading];
    self.imageView.image = [HETCoreResource imageNamed:@"Core_Loading_1"];
}
-(void)success{
    [self stopLoading];
    self.imageView.image = [HETCoreResource imageNamed:@"Core_Loading_Success"];
}
-(void)failure{
    [self stopLoading];
    self.imageView.image = [HETCoreResource imageNamed:@"Core_Loading_Failure"];
}
-(void)startLoading{
    self.imageView.image = [HETCoreResource imageNamed:@"Core_Loading_3"];
    self.imageView.animationImages =@[
                                      [HETCoreResource imageNamed:@"Core_Loading_1"],
                                      [HETCoreResource imageNamed:@"Core_Loading_2"],
                                      [HETCoreResource imageNamed:@"Core_Loading_3"],
                                      [HETCoreResource imageNamed:@"Core_Loading_4"],
                                      [HETCoreResource imageNamed:@"Core_Loading_5"],
                                      [HETCoreResource imageNamed:@"Core_Loading_6"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageView startAnimating];
    });
}
-(void)stopLoading{
    [self.imageView stopAnimating];
}
-(void)dealloc{
    NSLog(@"%s",__func__);
}
@end
