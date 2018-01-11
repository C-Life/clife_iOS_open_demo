//
//  HETcommonProblemsViewController.m
//  HETPublicSDK_DeviceBind
//
//  Created by hcc on 16/8/24.
//  Copyright © 2016年 HET. All rights reserved.
//

#import "HETBindInstructionVC.h"
#import "HETNetWorkRequest.h"

@interface HETBindInstructionVC ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation HETBindInstructionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 1.设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];

    // 2.设置导航栏
    [self createNavViews];

    // 3.初始化界面
    [self createSubView];
    NSString * kHETHostName=nil;

    if ([[HETNetWorkRequest shared].kHETAPIBaseUrl isEqualToString:@"open.api.clife.cn/v1"])
    {
        kHETHostName = @"https://cms.clife.cn";

    }
    else if([[HETNetWorkRequest shared].kHETAPIBaseUrl isEqualToString:@"https://test.open.api.clife.cn/v1"])
    {
        kHETHostName = @"https://test.cms.clife.cn";
    }
    else if([[HETNetWorkRequest shared].kHETAPIBaseUrl isEqualToString:@"https://200.200.200.50/v1/app/open"])
    {
        kHETHostName = @"https://200.200.200.50";
    }

    NSString *url = [NSString stringWithFormat:@"%@/manages/mobile/bindDevice/bindHelp.html",kHETHostName];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:req];
}

- (void)createNavViews
{
    [self.navigationItem setTitle:BindInstructionVCTitle];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];

//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)createSubView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView = [[UIWebView alloc]init];
    _webView.scrollView.scrollEnabled = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    OPLog(@"error =%@",error);
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    OPLog(@"%@ dealloc！！！",[self class]);
}
@end
