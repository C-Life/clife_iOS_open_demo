//
//  HETCommonIssuseVC.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/8/31.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETFAQVC.h"

@interface HETFAQVC ()<UIWebViewDelegate, NSURLConnectionDelegate>

@property (nonatomic,strong) NSURLRequest *originRequest;
@property (nonatomic,strong) UIWebView *issuseWebView;
@property (nonatomic,assign,getter=isAuthed) BOOL authed;
@property (nonatomic,strong) NSURLCredential *credential;
@end

@implementation HETFAQVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle: FrequentlyAskedQuestions];
    [self createSubView];
    
    NSURL *url = [NSURL URLWithString:self.issuseURL.length>0?self.issuseURL:@""];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.issuseWebView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.issuseWebView.delegate = nil;
}

- (void)createSubView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.issuseWebView = [[UIWebView alloc]init];
    self.issuseWebView.scrollView.scrollEnabled = YES;
    self.issuseWebView.delegate = self;
    [self.view addSubview:self.issuseWebView];
    [self.issuseWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

#pragma mark - UIWebViewDelegate,NSURLConnectionDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* scheme = [[request URL] scheme];
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!self.authed) {
            _originRequest = request;
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [webView stopLoading];
            return NO;
        }
    }
    return YES;
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    
    return YES;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSURL *url = [NSURL URLWithString:self.issuseURL.length>0?self.issuseURL:@""];
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge.protectionSpace.host isEqualToString:url.host]) {
            //OPLog(@"trusting connection to host %@", challenge.protectionSpace.host);
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        } else
        {
            //OPLog(@"Not trusting connection to host %@", challenge.protectionSpace.host);
        }
    }
    else {
        if ([challenge previousFailureCount] == 0) {
            
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
            
        } else {
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    }
    
    [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

#pragma mark - NSURLConnectionDataDelegate <NSURLConnectionDelegate>
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.authed = YES;
    //webview 重新加载请求。
    [self.issuseWebView loadRequest:_originRequest];
    //[self reload];
    [connection cancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
