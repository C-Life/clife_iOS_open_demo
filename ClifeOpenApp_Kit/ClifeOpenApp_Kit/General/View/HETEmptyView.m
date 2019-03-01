//
//  HETEmptyView.m
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2018/7/31.
//  Copyright © 2018年 het. All rights reserved.
//

#import "HETEmptyView.h"
#import "LoadingEmptyView.h"
#import "NetWorkErrorEmptyView.h"
#import "NoDataEmptyView.h"

@implementation HETEmptyView
@synthesize emptyState = _emptyState;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


- (void)setEmptyState:(HETEmptyViewState)emptyState
{
    _emptyState = emptyState;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    UIView *emptyView;
    if (emptyState == HETEmptyViewStateLoading) {
        emptyView = [LoadingEmptyView new];
      
    }else if (emptyState == HETEmptyViewStateNoData){
        emptyView = [NoDataEmptyView new];
    
    }else if (emptyState == HETEmptyViewStateError){
        NetWorkErrorEmptyView *errorView = [NetWorkErrorEmptyView new];
        WEAKSELF
        errorView.btnBlock = ^{
          STRONGSELF
            if (strongSelf.netWorkErrorBlock) {
                strongSelf.netWorkErrorBlock();
            }
        };
        emptyView = errorView;
    }else{
        return;
    }
    [self addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(0, 300);
}
@end
