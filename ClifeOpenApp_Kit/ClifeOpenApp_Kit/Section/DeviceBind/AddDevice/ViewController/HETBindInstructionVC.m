//
//  HETcommonProblemsViewController.m
//  HETPublicSDK_DeviceBind
//
//  Created by hcc on 16/8/24.
//  Copyright © 2016年 HET. All rights reserved.
//

#import "HETBindInstructionVC.h"

@interface HETBindInstructionVC ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation HETBindInstructionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:BindInstructionVCTitle];
    [self createSubView];
    
    NSString *filePath = [self getH5BasePath];
    NSURL *url = [[NSURL alloc] initWithString:filePath];
    NSURLRequest *request =[NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    [self.webView loadRequest:request];
}

- (void)createSubView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView = [[UIWebView alloc]init];
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
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
@end
