//
//  HETH5DownloadViewController.m
//  ClifeOpenApp_Kit
//
//  Created by yuan yunlong on 2017/11/6.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETH5ViewController.h"
#import "HETShareDevcieVC.h"
#import "HETScanQrcodeVC.h"

#import <WebKit/WebKit.h>
@interface HETH5ViewController ()<WKNavigationDelegate,HETWKWebViewJavascriptBridgeDelegate>
@property(nonatomic,strong) HETWKWebViewJavascriptBridge* bridge;
@property(nonatomic,strong) NSURL *requestURL;
@property(nonatomic,strong) NSURLCredential *credential;
@property(nonatomic,strong)  HETDeviceControlBusiness *communicationManager;
@property(nonatomic,strong) UIActivityIndicatorView *activityIndicator;

@end



@implementation HETH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.wkWebView.navigationDelegate = self;
    [self.view addSubview:self.wkWebView];

    self.bridge = [HETWKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    self.bridge.delegate=self;
    [self.bridge setNavigationDelegate:self];

    [self initNav];

    WEAKSELF
    _communicationManager=[[HETDeviceControlBusiness alloc]initWithHetDeviceModel:self.deviceModel deviceRunData:^(id responseObject) {
        [weakSelf.bridge webViewRunDataRepaint:responseObject];
        OPLog(@"deviceRunData %@",responseObject);
        [HETCommonHelp showAutoDissmissWithMessage:@"运行数据"];
    } deviceCfgData:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSArray *allKey = [responseObject allKeys];
            if ([allKey containsObject:@"userId"]) {
                [responseObject removeObjectForKey:@"userId"];
            }
            if ([allKey containsObject:@"updateTime"]) {
                [responseObject removeObjectForKey:@"updateTime"];
            }
            [weakSelf.bridge webViewConfigDataRepaint:responseObject];
            [HETCommonHelp showAutoDissmissWithMessage:@"控制数据"];
        }
       
        OPLog(@"webViewConfigDataRepaint %@",responseObject);
    } deviceErrorData:^(id responseObject) {
        [weakSelf.bridge webViewRunDataRepaint:responseObject];
        //        [HETCommonHelp showAutoDissmissWithMessage:@"错误数据"];
        OPLog(@"deviceErrorData %@",responseObject);
    } deviceState:^(HETWiFiDeviceState state) {
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        [infoDic setObject:@(state) forKey:@"onlineStatus"];
        [weakSelf.bridge webViewRunDataRepaint:infoDic];
        OPLog(@"state %ld",state);
        //        [HETCommonHelp showAutoDissmissWithMessage:@"在线数据"];
    } failBlock:^(NSError *error) {
        OPLog(@"失败了:%@",error);
    }];

    [self loadRequest];
}

- (void)initNav
{
    if (self.deviceModel.share.integerValue == 2) {
        // 3.设备详情按钮
        UIBarButtonItem *deviceShare =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_DeviceShare"] style:UIBarButtonItemStylePlain target:self action:@selector(shareDevice)];
        UIBarButtonItem *cloudAtuh = [[UIBarButtonItem alloc] initWithTitle:@"二维码调试" style:UIBarButtonItemStylePlain target:self action:@selector(scanCodeTest)];
        self.navigationItem.rightBarButtonItems = @[deviceShare,cloudAtuh];
    }else{
        self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"二维码调试" style:UIBarButtonItemStylePlain target:self action:@selector(scanCodeTest)];
    }
}

- (void)shareDevice
{
    HETShareDevcieVC *shareDeviceVC = [HETShareDevcieVC new];
    shareDeviceVC.deviceId = self.deviceModel.deviceId;
    [self.navigationController pushViewController:shareDeviceVC animated:YES];
}

- (void)scanCodeTest
{
    HETScanQrcodeVC *scanVC = [HETScanQrcodeVC new];
    WEAKSELF
    scanVC.h5PathBlock = ^(NSString *h5Path) {
        STRONGSELF
        if (h5Path.length > 0){
            strongSelf.h5Path = h5Path;
            [strongSelf loadRequest];
        }
    };
    [self.navigationController  pushViewController:scanVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_communicationManager start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_communicationManager stop];
}


#pragma -mark HETWKWebViewJavascriptBridgeDelegate
/**
 *  js调用的配置接口
 *
 *  @param data
 */
-(void)config:(id)data
{
    NSLog(@"config %@",data);
    [_bridge webViewReady:nil];
    if(self.communicationManager.deviceCfgData)
    {
        [_bridge webViewConfigDataRepaint:self.communicationManager.deviceCfgData];
    }
}


/**
 *  js调用的发送数据接口
 *
 *  @param data 将发送给app的数据，一般是完整的控制数据(json字符串)
 *  @param successCallback  app方数据处理成功时将调用该方法
 *  @param errorCallback    app方数据处理失败时将调用该方法
 */
-(void)send:(id)data successCallback:(id)successCallback errorCallback:(id)errorCallback
{
    //[_bridge updateDataSuccess:nil successCallBlock:successCallback];
    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *olddic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSMutableDictionary *responseObject=[[NSMutableDictionary alloc]initWithDictionary:olddic];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic=responseObject;
    NSError * err;
    NSData * tempjsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    NSString * json = [[NSString alloc] initWithData:tempjsonData encoding:NSUTF8StringEncoding];
    NSLog(@"send %@",data);
    WEAKSELF
    [self.communicationManager deviceControlRequestWithJson:json withSuccessBlock:^(id responseObject) {
        [weakSelf.bridge updateDataSuccess:responseObject successCallBlock:successCallback];
    } withFailBlock:^(NSError *error) {
        [weakSelf.bridge updateDataError:responseObject errorCallBlock:errorCallback];
    }];
}


/**
 *  js调用的设置页面标题接口(该方法用于将标题发送给app，以供app进行标题更新。)
 *
 *  @param data  将设置的标题
 */
-(void)title:(id)data
{
    self.title=data;
}



/**
 *  js调用的系统toast接口(方法用于调用系统toast，以便app方统一toast风格)
 *
 *  @param data 将要弹出的提示信息
 */
-(void)toast:(id)data
{

}

/**
 *  H5调用config接口后需要APP调用此方法，告知js准备好了(注意此方法调用之后，一般需要紧接着调用webViewConfigDataRepaint传配置数据给H5初始化界面)
 *
 *  @param dic
 */
-(void)relProxyHttp:(id)url data:(id)data httpType:(id) type sucCallbackId:(id) sucCallbackId errCallbackId:(id) errCallbackId needSign:(id) needSign
{

}

/**
 *  H5调用config接口后需要APP调用此方法，告知js准备好了(注意此方法调用之后，一般需要紧接着调用webViewConfigDataRepaint传配置数据给H5初始化界面)
 *
 *  @param dic
 */
-(void)absProxyHttp:(id)url data:(id)data httpType:(id) type sucCallbackId:(id) sucCallbackId errCallbackId:(id) errCallbackId
{
    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];

    HETRequestMethod httpMethod=HETRequestMethodGet;
    if([type rangeOfString:@"GET"].location!=NSNotFound)
    {
        httpMethod=HETRequestMethodGet;
    }
    else if([type rangeOfString:@"POST"].location!=NSNotFound)
    {
        httpMethod=HETRequestMethodPost;
    }

    [HETDeviceRequestBusiness startRequestWithHTTPMethod:httpMethod withRequestUrl:url processParams:dic needSign:true BlockWithSuccess:^(id responseObject) {

        NSDictionary *result = responseObject;
        NSInteger code= [[(NSDictionary *)result objectForKey:@"code"] integerValue];
        NSDictionary *data = [result objectForKey:@"data"];

        NSLog(@"%@,%ld",data,code);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_wkWebView) {
                [_wkWebView evaluateJavaScript:[NSString  stringWithFormat:@"webInterface.httpResponseSuccess('%@','%@')",[self DataTOjsonString:data],sucCallbackId] completionHandler:nil];
            }
        });
    } failure:^(NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            if (_wkWebView) {
                [_wkWebView evaluateJavaScript:[NSString  stringWithFormat:@"webInterface.httpResponseError('%@','%@')",[self DataTOjsonString:error],errCallbackId] completionHandler:nil];
            }
        });
    }];
}

/**
 *  加载H5页面失败
 *
 *  @param errCode  错误码
 *  @param errMsg   错误信息
 */
-(void)onLoadH5Failed:(id)errCode errMsg:(id)errMsg
{

}

/**
 *  H5调用config接口后需要APP调用此方法，告知js准备好了(注意此方法调用之后，一般需要紧接着调用webViewConfigDataRepaint传配置数据给H5初始化界面)
 *
 *  @param dic
 */
-(void)h5SendDataToNative:(id) routeUrl data:(id) data successCallbackId:(id)successCallbackId failedCallbackId:(id) failedCallbackId
{
    [_bridge webViewNativeResponse:@{@"h5SendDataToNative":routeUrl} callBackId:successCallbackId];
}

/**
 *  H5调用config接口后需要APP调用此方法，告知js准备好了(注意此方法调用之后，一般需要紧接着调用webViewConfigDataRepaint传配置数据给H5初始化界面)
 *
 *  @param dic
 */
-(void)h5GetDataFromNative:(id)routeUrl successCallbackId:(id)successCallbackId failedCallbackId:(id)failedCallbackId
{
    [_bridge webViewNativeResponse:@{@"h5GetDataFromNative":routeUrl} callBackId:successCallbackId];
}

- (void)loadRequest
{
    if (self.h5Path&&self.h5Path.length>0) {

        if ([self.h5Path hasPrefix:@"http"]) {
            [self showAlertView];
            [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.h5Path]]];

        }else{
            NSRange webRange = [_h5Path rangeOfString:@"web"];
            NSRange locationRange = [_h5Path rangeOfString:@"household"];
            NSString *directory;
            if (webRange.length>0) {
                directory = [_h5Path substringWithRange:NSMakeRange(0, webRange.length+webRange.location+1)];
            }
            if (locationRange.length>0) {
                directory = [_h5Path substringWithRange:NSMakeRange(0, locationRange.length+locationRange.location+1)];
            }

            OPLog(@"webView loadRequest ");
            [self showAlertView];
            if (NSFoundationVersionNumber>NSFoundationVersionNumber_iOS_8_x_Max) {
                @try {
                    [_wkWebView loadFileURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",[self.h5Path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] allowingReadAccessToURL:[NSURL fileURLWithPath:directory]];
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                } @finally {

                }
            }else{

                [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",[self.h5Path  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]]];
            }
        }
    }
}

- (void)reload
{
    [self loadRequest];
}

- (void)updateWebOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        //[_webView stringByEvaluatingJavaScriptFromString:
        // @"document.body.setAttribute('orientation', 90);"];
        [_wkWebView evaluateJavaScript:@"document.body.setAttribute('orientation', 90);" completionHandler:nil];
    } else {
        //[_webView stringByEvaluatingJavaScriptFromString:
        // @"document.body.removeAttribute('orientation');"];
        [_wkWebView evaluateJavaScript:@"document.body.removeAttribute('orientation');" completionHandler:nil];
    }
}

// param data参数 NSDictionary、NSString
-(void)updateDataSuccess:(id)data :(id)successCallBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *messageJSON = @"";
        if ([data isKindOfClass:[NSDictionary class]]) {
            messageJSON=[self DataTOjsonString:data];

        } else if ([data isKindOfClass:[NSString class]]){
            messageJSON = data;
        }
        // [_webView stringByEvaluatingJavaScriptFromString:[NSString  stringWithFormat:@"webInterface.nativeResponse('%@','%@')",messageJSON,successCallBlock]];
        [_wkWebView evaluateJavaScript:[NSString  stringWithFormat:@"webInterface.nativeResponse('%@','%@')",messageJSON,successCallBlock] completionHandler:nil];
    });
}

-(NSString*)DataTOjsonString:(id)object
{
    if([object isKindOfClass:[NSNull class]]||!object)
    {
        return @"";
    }
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];

    return jsonString;
}

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
            if (self.credential) {
                [[challenge sender] useCredential:self.credential forAuthenticationChallenge:challenge];
            } else {
                [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
            }
        } else {
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    }

    [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    OPLog(@"connection didFailWithError");
}
#pragma mark ================= NSURLConnectionDataDelegate <NSURLConnectionDelegate>

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //    self.authed = YES;
    //webview 重新加载请求。
    //    [_webView loadRequest:originRequest];
    [connection cancel];

    OPLog(@"connection didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    OPLog(@"connection didReceiveData");
}

#pragma mark -----WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // 类似 UIWebView 的- webView:didFailLoadWithError:
    // 102 == WebKitErrorFrameLoadInterruptedByPolicyChange
    // -999 == "Operation could not be completed", note -999 occurs when the user clicks away before
    // the page has completely loaded, if we find cases where we want this to result in dialog failure
    // (usually this just means quick-user), then we should add something more robust here to account
    // for differences in application needs
    if (!(([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999) ||
          ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102))) {

    }
    NSLog(@"webView didFailProvisionalNavigation withError %@",error);

    [self hiddenalertView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation { // 类似 UIWebView 的 －webViewDidFinishLoad:
    if(self.communicationManager.deviceCfgData)
    {
        [_bridge webViewConfigDataRepaint:self.communicationManager.deviceCfgData];
    }
    NSLog(@"webView didFinishNavigation ");
    //[self updateWebOrientation];
    [self hiddenalertView];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:

    NSString *requestString =[[navigationAction.request URL]absoluteString];

    NSLog(@"requestString:%@",requestString);
    if([requestString hasPrefix:@"http"]||[requestString hasPrefix:@"file://"])
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyCancel);

    }

}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation { // 类似UIWebView的 -webViewDidStartLoad:
    [_activityIndicator startAnimating];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    completionHandler();
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {

        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];

        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}

- (void)showAlertView
{
    //创建UIActivityIndicatorView背底半透明View
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [_activityIndicator setCenter:self.view.center];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:_activityIndicator];
}

- (void)hiddenalertView
{
    [_activityIndicator stopAnimating];
}

- (void)dealloc
{
    OPLog(@"%@ dealloc！！！",[self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

