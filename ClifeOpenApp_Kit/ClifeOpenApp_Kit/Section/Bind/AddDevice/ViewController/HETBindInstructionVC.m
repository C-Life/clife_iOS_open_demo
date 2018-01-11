//
//  HETcommonProblemsViewController.m
//  HETPublicSDK_DeviceBind
//
//  Created by hcc on 16/8/24.
//  Copyright © 2016年 HET. All rights reserved.
//

#import "HETBindInstructionVC.h"

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

    NSString *filePath = [self getH5BasePath];
    NSURL *url = [[NSURL alloc] initWithString:filePath];
    NSURLRequest *request =[NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    [_webView loadRequest:request];
}

- (void)createNavViews
{
    [self.navigationItem setTitle:BindInstructionVCTitle];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)]; 
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

- (NSString *)getH5BasePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPathName = [paths firstObject];
    docPathName = [docPathName stringByAppendingPathComponent:@"bindHelp"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:docPathName]) {

        NSString *bundlePath =  [[NSBundle mainBundle] pathForResource:@"bindHelp" ofType:@"bundle"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
            NSError *error;
            [[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:docPathName error:&error];
            if (error) {
                return nil;
            }
        }
    }
    return [docPathName stringByAppendingPathComponent:@"/page/bindHelp.html"];
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
