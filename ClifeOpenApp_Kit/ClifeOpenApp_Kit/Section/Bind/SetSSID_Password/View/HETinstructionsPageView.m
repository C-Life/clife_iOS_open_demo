//
//  instructionsPageView.m
//  HETPublicSDK_DeviceBind
//
//  Created by hcc on 16/8/30.
//  Copyright © 2016年 HET. All rights reserved.
//

#import "HETinstructionsPageView.h"
#import <AVFoundation/AVFoundation.h>
@interface HETinstructionsPageView ()
{
    UIWebView *_webView;
}

@property (nonatomic, strong) NSURL* requestURL;
@property(nonatomic,assign)BOOL authed;
@property (nonatomic, strong) NSURLCredential *credential;

@end

@implementation HETinstructionsPageView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

-(void)backAction
{
    if([_webView canGoBack])
    {
        [_webView goBack];
    }
}

-(void)addwebview
{
    if(!_webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.scrollEnabled = NO;
        _webView.scalesPageToFit = YES;
        [self addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }

    [self loadRequestWithURL:[NSURL URLWithString:self.device.guideUrl]];
}

- (void)loadRequestWithURL:(NSURL *)url
{

    self.requestURL=url;
    NSURLRequest *request =[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [_webView loadRequest:request];
}

-(void)reload
{
    [_webView removeFromSuperview];
    _webView=nil;
    [self addwebview];
}
@end
