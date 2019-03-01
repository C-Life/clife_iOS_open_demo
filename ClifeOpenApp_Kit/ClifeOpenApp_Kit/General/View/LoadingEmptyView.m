//
//  LoadingEmptyView.m
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2018/7/31.
//  Copyright © 2018年 het. All rights reserved.
//

#import "LoadingEmptyView.h"

@interface LoadingEmptyView ();

@end

@implementation LoadingEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView
{
    LOTAnimationView *lotView = [LOTAnimationView animationNamed:@"Lottie_LoadingHUD"];
    lotView.loopAnimation = YES;
    lotView.animationSpeed = 2.0;
    lotView.contentMode = UIViewContentModeScaleAspectFit;
    [lotView play];
    [self addSubview:lotView];
    [lotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
//        make.top.equalTo(self.mas_top).mas_offset(50);
        make.centerY.equalTo(self.mas_centerY).offset(-64);
        make.width.equalTo(@(100*BasicWidth));
        make.height.equalTo(@(90*BasicHeight));
    }];
}
@end
