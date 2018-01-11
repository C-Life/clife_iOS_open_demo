//
//  instructionsPageView.m
//  HETPublicSDK_DeviceBind
//
//  Created by hcc on 16/8/30.
//  Copyright © 2016年 HET. All rights reserved.
//

#import "HETinstructionsPageView.h"
#import "bindJavaScript.h"
#import "EasyJSWebView.h"

#import <AVFoundation/AVFoundation.h>
#define kBindTimeOut 40



@interface HETinstructionsPageView ()<UIWebViewDelegate,bindJavaScriptDelegate,NSURLConnectionDelegate>
{
    EasyJSWebView *_webView;
    
    NSURLRequest* originRequest;
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
        _webView = [[EasyJSWebView alloc] initWithFrame:CGRectZero];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.scrollEnabled = NO;
        _webView.delegate=self;
        [self addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }

    NSString * kHETHostName=nil;
//    HETNetworkConfig *config = [HETNetworkConfig sharedInstance];
//    if ([config.baseUrl isEqualToString:@"https://api.clife.cn"]) {
//        kHETHostName = @"https://cms.clife.cn";
//    else{
        kHETHostName = @"https://200.200.200.50";
//    }

    NSLog(@"url:%@",[NSString stringWithFormat:@"%@/manages/mobile/bindDevice/addDevice.html?bindType=%ld&productId=%ld",kHETHostName,self.bindType,3502]);
    
    [self loadRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/manages/mobile/bindDevice/addDevice.html?bindType=%ld&productId=%ld",kHETHostName,self.bindType,63]]];

    
    bindJavaScript* bindDevice = [[bindJavaScript alloc]init];
    bindDevice.bindJavaScriptdelegate=self;
    [_webView addJavascriptInterfaces:bindDevice WithName:@"bindJavaScript"];
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
#pragma mark ================= NSURLConnectionDelegate <NSObject>


- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    
    return YES;
}
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge.protectionSpace.host isEqualToString:self.requestURL.host]) {
            //NSLog(@"trusting connection to host %@", challenge.protectionSpace.host);
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        } else
        {
            //NSLog(@"Not trusting connection to host %@", challenge.protectionSpace.host);
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
#pragma mark ================= NSURLConnectionDataDelegate <NSURLConnectionDelegate>


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.authed = YES;
    //webview 重新加载请求。
    [_webView loadRequest:originRequest];
    //[self reload];
    [connection cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}


// UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* scheme = [[request URL] scheme];
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!self.authed) {
            originRequest = request;
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [webView stopLoading];
            return NO;
        }
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Disable user selection
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (!(([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999) ||
          ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)))
    {

    }
}
@end
