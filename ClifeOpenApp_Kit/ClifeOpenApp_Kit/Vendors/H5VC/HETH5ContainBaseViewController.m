//
//  HETH5ContainBaseViewController.m
//  HETPublicSDK_HETH5DeviceControl
//
//  Created by mr.cao on 2018/3/12.
//  Copyright © 2018年 HET. All rights reserved.
//

#import "HETH5ContainBaseViewController.h"
//#import "NSString+SAMAdditions.h"
//#import <HETSDK.h>
//#import "HETUserDefaultsPreference.h"
#import "HETXMLReader.h"
//#import "HETH5Request.h"
//#import "HETH5RelRequest.h"
#import "HETOpenSDK.h"
#import "HETReachability.h"
#import "HETH5CustomNavigationBar.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#pragma mark wek str 宏

#ifndef weakify
#if __has_feature(objc_arc)

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef strongify
#if __has_feature(objc_arc)

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif
#endif

@interface HETH5ContainBaseViewController ()<WKUIDelegate>
@property(nonatomic, strong) NSURL *requestURL;
@property(nonatomic, strong) NSURLCredential *credential;
@property(nonatomic,strong) HETReachability *ablity;
@property(nonatomic,strong) HETH5CustomNavigationBar *h5CustomNavigationBar;
@property(nonatomic, strong) UIProgressView *progressView;//设置加载进度条
@end

@implementation HETH5ContainBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 修复 Push到下一级右上角可恶的黑条
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.h5CustomNavigationBar];
    //self.h5CustomNavigationBar.frame=CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 44);
    self.h5CustomNavigationBar.barBackgroundColor=self.navigationController.navigationBar.barTintColor;// [UIColor whiteColor];
    [self.h5CustomNavigationBar wr_setLeftButtonWithNormal:[UIImage imageNamed:@"nav_back_white"] highlighted:nil title:nil titleColor:[UIColor whiteColor] backBroundColor:nil];
      [self.h5CustomNavigationBar wr_setRightButtonWithNormal:nil highlighted:nil title:@"设备详情" titleColor:[UIColor whiteColor] backBroundColor:nil];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.h5CustomNavigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-self.h5CustomNavigationBar.frame.size.height)];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.navigationDelegate = self;
    webView.UIDelegate=self;
    [self.view addSubview:webView];
    //webView.UIDelegate=self;
    webView.navigationDelegate=self;
  
    _wkWebView=webView;
    [_wkWebView addObserver:self
              forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                 options:0
                 context:nil];
    _jsBridge = [HETWKWebViewJavascriptBridge bridgeForWebView:webView];
    _jsBridge.delegate=self;
    [_jsBridge setNavigationDelegate:self];
    [self loadRequest];
     @weakify(self);
    self.h5CustomNavigationBar.onClickLeftButton = ^(NSUInteger index, NSString *title) {
       @strongify(self);
        if([self.wkWebView canGoBack])
        {
            [self.wkWebView goBack];
            return;
        }
        !self.onClickLeftButton?:self.onClickLeftButton(index,title);
    };
    self.h5CustomNavigationBar.onClickRightButton = ^(NSUInteger index, NSString *title) {
        @strongify(self);
        !self.onClickRightButton?:self.onClickRightButton(index,title);
    };
    [self.view addSubview:self.progressView];
    self.progressView.frame=CGRectMake(0, self.h5CustomNavigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width,5);
//    [HETDeviceRequestBusiness fetchDeviceInfoWithDeviceId:self.deviceModel.deviceId success:^(id responseObject) {
//        NSLog(@"获取设备基本信息:%@",responseObject);
//      
//    } failure:^(NSError *error) {
//        NSLog(@"获取设备基本信息失败:%@",error);
//        NSString *errorMsg=error.userInfo[@"msg"];
//        
//     
//    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //self.navigationController.navigationBar.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
     //self.navigationController.navigationBar.hidden=NO;
     [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadRequest
{
    //清除webView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    if (self.h5Path&&self.h5Path.length>0) {
        
        if ([self.h5Path hasPrefix:@"http"]) {
            
            [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.h5Path]]];
        }else{
            NSRange webRange = [_h5Path rangeOfString:@"web"];
            NSRange locationRange = [_h5Path rangeOfString:@"household"];
            NSString *directory=self.h5fileDirectory;
            if (webRange.length>0) {
                directory = [_h5Path substringWithRange:NSMakeRange(0, webRange.length+webRange.location+1)];
            }
            if (locationRange.length>0) {
                directory = [_h5Path substringWithRange:NSMakeRange(0, locationRange.length+locationRange.location+1)];
            }
            
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

//kvo 监听进度
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    //NSLog(@"父类KVO:%@,%@,%@,%@----%f",keyPath,object,change,context,_wkWebView.estimatedProgress);
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _wkWebView) {
        _progressView.progressTintColor =self.h5CustomNavigationBar.barBackgroundColor;
        [self.progressView setAlpha:1.0f];
        BOOL animated = _wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:_wkWebView.estimatedProgress
                              animated:animated];
        
        if (_wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.progressView setAlpha:0.0f];
                             }
                             completion:^(BOOL finished) {
                                 [self.progressView setProgress:0.0f animated:NO];
                             }];
        }
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

#pragma -mark HETWKWebViewJavascriptBridgeDelegate
/**
 *  js调用的配置接口
 *
 *  @param data 配置数据
 */
-(void)config:(id)data
{
    [_jsBridge webViewReady:nil];
}



/**
 *  js调用的设置页面标题接口(该方法用于将标题发送给app，以供app进行标题更新。)
 *
 *  @param data  将设置的标题
 */
-(void)title:(id)data
{
    if(self.hetDeviceControlWKWebviewDelegate &&[self.hetDeviceControlWKWebviewDelegate respondsToSelector:@selector(updateTitleString:)])
    {
        [self.hetDeviceControlWKWebviewDelegate updateTitleString:data];
    }
}

- (void)tips:(id)data
{
    if(self.hetDeviceControlWKWebviewDelegate &&[self.hetDeviceControlWKWebviewDelegate respondsToSelector:@selector(updateTipsString:)])
    {
        [self.hetDeviceControlWKWebviewDelegate updateTipsString:data];
    }
}

///**
// *  js调用的系统toast接口(方法用于调用系统toast，以便app方统一toast风格)
// *
// *  @param data 将要弹出的提示信息
// */
//-(void)toast:(id)data
//{
//
//}

/**
 *  相对网络请求
 *
 *  @param url    请求地址。如用相对地址，必须“/” 开头（如：/v1/app/get）
 *  @param data   发送数据。形式为：{"name": "张三", "age": 21, ...}
 *  @param type   HTTP请求类型，如Get,Post请求
 *  @param sucCallbackId   接口调用成功的回调函数
 *  @param errCallbackId    接口调用失败的回调函数
 *  @param needSign        接口是否需要签名（相对地址时有效),1代表需要签名，0代表不需要签名|
 */
-(void)relProxyHttp:(id)url data:(id)data httpType:(id) type sucCallbackId:(id) sucCallbackId errCallbackId:(id) errCallbackId needSign:(id) needSign
{
   /* NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSMutableDictionary *newdic =[[NSMutableDictionary alloc]initWithDictionary:dic];
    [newdic setValue:[HETUserInfo userInfo].accessToken forKey:@"accessToken"];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    
    NSString * _timestamp = [NSString stringWithFormat: @"%lld", (long long)(time * 1000)];
    [newdic setValue:_timestamp forKey:@"timestamp"];
    NSDictionary *networkConfigDic=[[[HETNetworkConfig sharedInstance].urlFilters firstObject]filterWithRequest:nil];
    [newdic setValue:networkConfigDic[@"appId"] forKey:@"appId"];
    
    if(self.hetDeviceControlWKWebviewDelegate &&[self.hetDeviceControlWKWebviewDelegate respondsToSelector:@selector(relProxyHttpRequestParams:)])
    {
        NSDictionary *transFromDic= [self.hetDeviceControlWKWebviewDelegate relProxyHttpRequestParams:newdic];
        newdic=[[NSMutableDictionary alloc]initWithDictionary: transFromDic];
    }
    
    YTKRequestMethod httpMethod=YTKRequestMethodGet;
    if([type rangeOfString:@"GET"].location!=NSNotFound)
    {
        httpMethod=YTKRequestMethodGet;
    }
    if([type rangeOfString:@"POST"].location!=NSNotFound)
    {
        httpMethod=YTKRequestMethodPost;
    }
   
    HETNetworkConfig *config = [HETNetworkConfig sharedInstance];
    
    NSString *absUrl=[NSString stringWithFormat:@"%@%@",config.baseUrl,url];

    HETH5RelRequest *request=[[HETH5RelRequest alloc]initWithUrl:absUrl json:newdic httpRequestType:httpMethod needSign:bneedSign];
    [request  startWithSuccess:^(id response) {
        NSLog(@"url:%@,response:%@,%@",url,response,request.responseJSONObject);
        [_jsBridge webViewHttpResponseSuccessResponse:request.responseJSONObject successCallBlock:sucCallbackId];
     
    } failure:^(NSError *error, NSInteger statusCode) {
          NSLog(@"responsefailure:%@",error);
          NSString *errorMsg=error.userInfo[@"msg"];
        
        [_jsBridge webViewHttpResponseErrorResponse:@{@"code":@(statusCode),@"msg":errorMsg.length? errorMsg:error.description} errorCallBlock:errCallbackId];
        
  
        
    }];//
    */
    BOOL bneedSign=NO;
    if([needSign rangeOfString:@"1"].location!=NSNotFound)
    {
        bneedSign=YES;
    }
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
    [HETDeviceRequestBusiness startRequestWithHTTPMethod:httpMethod withRequestUrl:url processParams:dic needSign:bneedSign BlockWithSuccess:^(id responseObject) {
        
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
 *  绝对网络请求
 *
 *  @param url    请求地址。如用绝对地址（如：https://baidu.com/v1/app/get）
 *  @param data   发送数据。形式为：{"name": "张三", "age": 21, ...}
 *  @param type   HTTP请求类型，如Get,Post请求
 *  @param sucCallbackId   接口调用成功的回调函数
 *  @param errCallbackId    接口调用失败的回调函数
 */
-(void)absProxyHttp:(id)url data:(id)data httpType:(id) type sucCallbackId:(id) sucCallbackId errCallbackId:(id) errCallbackId
{
    /*NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    //NSMutableDictionary *newDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    // [newDic setValue: [HETUserInfo userInfo].accessToken forKey:@"accessToken"];
     YTKRequestMethod httpMethod=YTKRequestMethodGet;
    if([type rangeOfString:@"GET"].location!=NSNotFound)
    {
        httpMethod=YTKRequestMethodGet;
    }
    else if([type rangeOfString:@"POST"].location!=NSNotFound)
    {
        httpMethod=YTKRequestMethodPost;
    }
    
    HETH5Request *request=[[HETH5Request alloc]initWithUrl:url json:dic httpRequestType:httpMethod needSign:NO];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        NSLog(@"HETH5Requestresponse:%@,%ld",request.responseJSONObject,(long)request.responseStatusCode);
      [_jsBridge webViewHttpResponseSuccessResponse:request.responseJSONObject successCallBlock:sucCallbackId];
        
    } failure:^(YTKBaseRequest *request) {
      NSLog(@"HETH5Requestresponsefail:%@,%ld",request.responseJSONObject,(long)request.responseStatusCode);
        [_jsBridge webViewHttpResponseErrorResponse:@{@"code":@(request.responseStatusCode),@"msg":request.responseJSONObject} errorCallBlock:errCallbackId];
        
    }];*/
    
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
    
    [HETDeviceRequestBusiness startRequestWithHTTPMethod:httpMethod withRequestUrl:url processParams:dic needSign:NO BlockWithSuccess:^(id responseObject) {
        
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
 *|errCode    |errMsg|
 |---------|:------:|
 |10100  |公共包资源加载失败|
 |10101  |SDK版本不匹配|
 |10102  |资源加载失败|
 |10103 | 代码运行错误|
 |10104  |页面渲染异常|
 |10105 | 页面无响应|
 
 *  @param errCode  错误码
 *  @param errMsg   错误信息
 */
-(void)onLoadH5Failed:(id)errCode errMsg:(id)errMsg
{
    if(self.hetDeviceControlWKWebviewDelegate &&[self.hetDeviceControlWKWebviewDelegate respondsToSelector:@selector(webViewdidFailLoadJSWithErrorCode:errorMsg:)])
    {
        [self.hetDeviceControlWKWebviewDelegate webViewdidFailLoadJSWithErrorCode:errCode errorMsg:errMsg];
    }
}

/**
 *  h5传数据给native指h5传递相关数据给native端，比如设置页面标题，当前版本信息等
 *
 *  @param routeUrl   路由方法名
 *  @param data   数据内容
 *  @param successCallbackId   接口调用成功的回调函数
 *  @param failedCallbackId    接口调用失败的回调函数
 
 */
-(void)h5SendDataToNative:(id) routeUrl data:(id) data successCallbackId:(id)successCallbackId failedCallbackId:(id) failedCallbackId
{
    if(self.hetDeviceControlWKWebviewDelegate &&[self.hetDeviceControlWKWebviewDelegate respondsToSelector:@selector(h5SendDataToNative:data:successCallBackId:failedCallBackId:)])
    {
        [self.hetDeviceControlWKWebviewDelegate h5SendDataToNative:routeUrl data:data successCallBackId:successCallbackId failedCallBackId:failedCallbackId];
    }
}

/**
 *  h5从native端获取数据，比如定位信息，蓝牙是否开启等
 *
 *  @param routeUrl   路由方法名
 *  @param successCallbackId   接口调用成功的回调函数
 *  @param failedCallbackId    接口调用失败的回调函数
 
 */
-(void)h5GetDataFromNative:(id)routeUrl successCallbackId:(id)successCallbackId failedCallbackId:(id)failedCallbackId
{
    if(self.hetDeviceControlWKWebviewDelegate &&[self.hetDeviceControlWKWebviewDelegate respondsToSelector:@selector(h5GetDataToNative:successCallBackId:failedCallBackId:)])
    {
        [self.hetDeviceControlWKWebviewDelegate h5GetDataToNative:routeUrl successCallBackId:successCallbackId failedCallBackId:failedCallbackId];
    }
}


/**
 *  h5从native端获取JSBridege版本号
 *
 */
-(void)h5GetAPPJSBridgeVersion
{
    [_jsBridge  webViewJSBridgeVersionResponse:@"2.0.0"];
}


/**
 *  h5从native端获取APP语言（国际化）
 *
 */
-(void)h5GetAPPLanguage
{
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"currentlanguage = %@",currentLanguage);
    NSString *appLanguage=@"zh_CN";
    if ([currentLanguage containsString:@"zh-Hans"]) {//简体
        NSLog(@"zh-Hans");
    }
    else if ([currentLanguage containsString:@"zh-Hant"]||[currentLanguage containsString:@"zh-HK"]||[currentLanguage containsString:@"zh-TW"]) {
        NSLog(@"zh-Hant");
        appLanguage=@"zh_TW";
    }
    else
    {
        appLanguage=@"en";
    }
    [_jsBridge webViewAPPLanguageResponse:appLanguage];
}


/**
 *  显示消息提示框
 *
 *  @param title    提示的内容
 *  @param icon     图标，有效值 "success", "loading"
 *  @param image    自定义图标的路径，image 的优先级高于 icon
 *  @param duration 提示的延迟时间，单位毫秒，默认：1500
 *  @param mask     是否显示透明蒙层，防止触摸穿透，默认：0
 *  @param successCallbackId  接口调用成功的回调函数
 *  @param failCallbackId    接口调用失败的回调函数
 *  @param completeCallbackId   接口调用结束的回调函数（调用成功、失败都会执行）
 
 */
-(void)showToastWithTitle:(id)title icon:(id)icon image:(id)image duration:(id)duration mask:(id)mask  successCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId  completeCallbackId:(id) completeCallbackId
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *imagetemp= [UIImage imageWithContentsOfFile:image];
    imagetemp = [imagetemp imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:imagetemp];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    //hud.dimBackground = NO;
    NSString *dimBackground=mask;
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    if([dimBackground isEqualToString:@"1"])
    {
      hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    }
    else
    {
        hud.backgroundView.color = [UIColor clearColor];
    }
    // Optional label text.
    hud.label.text =title;// NSLocalizedString(@"Done", @"HUD done title");
    NSString *delay=duration;
    [hud hideAnimated:YES afterDelay:delay.intValue/1000];
}

/**
 *  隐藏消息提示框
 *
 */
-(void)hideToast
{
    
}

/**
 *  显示提示框
 *
 *  @param title                 提示的标题
 *  @param content               提示的内容
 *  @param showCancel            是否显示取消按钮，默认为 true
 *  @param cancelText            取消按钮的文字，默认为"取消"，最多 4 个字符
 *  @param cancelColor           取消按钮的文字颜色，默认为"#000000",16进制字符串表示
 *  @param confirmText           确定按钮的文字，默认为"确定"，最多 4 个字符
 *  @param confirmColor          确定按钮的文字颜色，默认为"#3CC51F"
 *  @param successCallbackId     接口调用成功的回调函数
 *  @param failCallbackId        接口调用失败的回调函数
 *  @param completeCallbackId    接口调用结束的回调函数（调用成功、失败)
 
 */
-(void)showAlertViewWithTitle:(id)title content:(id)content showCancel:(id)showCancel cancelText:(id)cancelText cancelColor:(id)cancelColor confirmText:(id)confirmText confirmColor:(id)confirmColor successCallbackId:(id) successCallbackId failCallbackId:(id)failCallbackId completeCallbackId:(id) completeCallbackId
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    // [alertController.view setNeedsLayout]; // 去掉这行log上会打印错误
    
    
    UIAlertAction *okAction,*cancelAction;
    okAction= [UIAlertAction actionWithTitle:confirmText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //        UITextField *login = alertController.textFields.firstObject;
        [_jsBridge webViewShowAlertViewResponse:@{@"data":@{@"confirm":@"1"}} callBackId:completeCallbackId];
    }];
      [okAction setValue:[self colorWithHexString:confirmColor] forKey:@"_titleTextColor"];
    
  if(cancelText)
  {
    cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
         [_jsBridge webViewShowAlertViewResponse:@{@"data":@{@"cancel":@"1"}} callBackId:completeCallbackId];
    }];
      /*取消按钮的颜色*/
      [cancelAction setValue:[self colorWithHexString:cancelColor] forKey:@"_titleTextColor"];
      
  }
    if(cancelAction)
    {
         [alertController addAction:cancelAction];
    }
     [alertController addAction:okAction];
//    /*title*/
//    NSMutableAttributedString *alertTitleStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
//    [alertTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 2)];
//    [alertTitleStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
//    [alertController setValue:alertTitleStr forKey:@"attributedTitle"];
//
//    /*message*/
//    NSMutableAttributedString *alertMessageStr = [[NSMutableAttributedString alloc] initWithString:@"请修改输入内容"];
//    [alertMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 7)];
//    [alertMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, 3)];
//    [alertMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(3, 2)];
//    [alertMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, 2)];
//    [alertController setValue:alertMessageStr forKey:@"attributedMessage"];
    

   
   
    // [alertController addAction:okAction1];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


/**
 *  显示操作菜单
 *
 *  @param title    提示的标题
 *  @param itemList   按钮的文字数组，数组长度最大为6个
 *  @param itemColor    按钮的文字颜色，默认为"#000000"
 *  @param successCallbackId    接口调用成功的回调函数，详见返回参数说明
 *  @param failCallbackId    接口调用失败的回调函数
 *  @param completeCallbackId   接口调用结束的回调函数（调用成功、失败都会执行）
 
 */
-(void)showActionSheetWithTitle:(id)title itemList:(id)itemList itemColor:(id) itemColor successCallbackId:(id) successCallbackId failCallbackId:(id) failCallbackId completeCallbackId:(id) completeCallbackId
{
    NSString *titleStr=title;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:!titleStr.length?nil:titleStr message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // [alertController.view setNeedsLayout]; // 去掉这行log上会打印错误
    
    NSError *error;
    NSData *jsonData = [itemList dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if([object isKindOfClass:[NSArray class]])
    {
        [object enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *itemAction = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //        UITextField *login = alertController.textFields.firstObject;
                [_jsBridge webViewShowActionSheetResponse:@{@"data":@{@"index":@(idx)}} callBackId:completeCallbackId];
            }];
           // [itemAction setValue:[self colorWithHexString:itemColor] forKey:@"_titleTextColor"];
              [alertController addAction:itemAction];
        }];
  
      
   
    }
   UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    
    }];
    /*取消按钮的颜色*/
    //[cancelAction setValue:[self colorWithHexString:itemColor] forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
 
    [self presentViewController:alertController animated:YES completion:nil];
}


/**
 *  设置导航栏标题与颜色
 *
 *  @param title              页面标题
 *  @param frontColor         前景颜色值，包括按钮、标题、状态栏的颜色,有效值为十六进制颜色
 *  @param backgroundColor    背景颜色值，有效值为十六进制颜色
 *  @param image              图片路径
 *  @param successCallbackId  接口调用成功的回调函数
 *  @param failCallbackId     接口调用失败的回调函数
 *  @param completeCallbackId 接口调用结束的回调函数（调用成功、失败都会执行）
 
 */
-(void) setNavigationBarTitle:(id )title  frontColor:(id) frontColor  backgroundColor:(id) backgroundColor  image:(id) image  successCallbackId:(id) successCallbackId  failCallbackId:(id) failCallbackId  completeCallbackId:(id) completeCallbackId
{
    self.h5CustomNavigationBar.title=title;
    self.h5CustomNavigationBar.titleLabelColor=[self colorWithHexString:frontColor];
    self.h5CustomNavigationBar.barBackgroundColor=[self colorWithHexString:backgroundColor];
    if(image)
    {
      self.h5CustomNavigationBar.barBackgroundImage=[UIImage imageWithContentsOfFile:image];
    }
   
}


/**
 *  设置导航栏左边按钮
 *
 *  @param itemList           按钮集合对象数组，最多两个按钮（按钮顺序是从左到右）,按钮元素参数{title: '按钮标题',image:'按钮图片路径',tintColor:'按钮字体颜色HexColor',backgroundColor:'按钮背景颜色HexColor'}
 *  @param successCallbackId  接口调用成功的回调函数
 *  @param failCallbackId     接口调用失败的回调函数
 
 */
-(void)setNavigationBarLeftBarButtonItems:(id)itemList  successCallbackId:(id) successCallbackId  failCallbackId:(id)failCallbackId
{
    NSError *error;
    NSData *jsonData = [itemList dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if([object isKindOfClass:[NSArray class]])
    {
        NSDictionary *dic=object[0];
        UIColor *tintColor=[self colorWithHexString:dic[@"tintColor"]];
        UIColor *backBroundColor=[self colorWithHexString:dic[@"backgroundColor"]];
        [self.h5CustomNavigationBar wr_setLeftButtonWithNormal:[UIImage imageWithContentsOfFile:dic[@"image"]] highlighted:[UIImage imageWithContentsOfFile:dic[@"image"]] title:dic[@"title"] titleColor:tintColor backBroundColor:backBroundColor];
     
    }
}


/**
 *  设置导航栏右边按钮
 *
 *  @param itemList           按钮集合对象数组，最多两个按钮（按钮顺序是从左到右）,按钮元素参数{title: '按钮标题',image:'按钮图片路径',tintColor:'按钮字体颜色HexColor',backgroundColor:'按钮背景颜色HexColor'}
 *  @param successCallbackId  接口调用成功的回调函数
 *  @param failCallbackId     接口调用失败的回调函数
 
 */
-(void)setNavigationBarRightBarButtonItems:(id)itemList  successCallbackId:(id) successCallbackId  failCallbackId:(id)failCallbackId
{
    NSError *error;
    NSData *jsonData = [itemList dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if([object isKindOfClass:[NSArray class]])
    {
        NSDictionary *dic=object[0];
        UIColor *tintColor=[self colorWithHexString:dic[@"tintColor"]];
        UIColor *backBroundColor=[self colorWithHexString:dic[@"backgroundColor"]];
        [self.h5CustomNavigationBar wr_setRightButtonWithNormal:[UIImage imageWithContentsOfFile:dic[@"image"]] highlighted:[UIImage imageWithContentsOfFile:dic[@"image"]] title:dic[@"title"] titleColor:tintColor backBroundColor:backBroundColor];
        
    }
}



/**
 *  设置导航栏菜单
 *
 *  @param itemList              按钮集合对象数组，（按钮顺序是从上到下）,按钮元素参数{title: '标题',image:'图片路径',tintColor:'字体颜色HexColor',backgroundColor:'背景颜色HexColor'}|
 *  @param backgroundColor       菜单的背景颜色，默认为"#000000"
 *  @param successCallbackId     接口调用成功的回调函数，详见返回参数说明
 *  @param failCallbackId        接口调用失败的回调函数
 *  @param completeCallbackId    接口调用结束的回调函数（调用成功、失败都会执行）
 
 */
-(void)setNavigationBarMenuItem:(id)itemList  backgroundColor:(id)backgroundColor  successCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId  completeCallbackId:(id)completeCallbackId
{
    
}

/**
 *  获取网络类型
 *
 *  @param successCallbackId    接口调用成功的回调函数
 *  @param failCallbackId       接口调用失败的回调函数
 
 */
-(void)getNetworkTypeWithSuccessCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId
{
    NSString *netconnType=[self getNetconnType];
    NSString *isConnected=@"0";
    if(![netconnType isEqualToString:@"none"])
    {
        isConnected=@"1";
    }
    NSDictionary *dic=@{@"data":@{@"isConnected":isConnected,@"networkType":netconnType}};
    [_jsBridge webViewCurrentNetworkTypeResponse:dic callBackId:successCallbackId];
        
}
- (NSString *)getNetconnType{
    
    NSString *netconnType = @"none";
    
    HETReachability *reach = [HETReachability reachabilityForInternetConnection];//[HETReachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:// 没有网络
        {
            
            netconnType = @"none";
        }
            break;
            
        case ReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;
            
        case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            
            NSString *currentStatus = info.currentRadioAccessTechnology;
            
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                 netconnType = @"2G";
                //netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                 netconnType = @"3G";
                //netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                 netconnType = @"3G";
                //netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                netconnType = @"3G";
                //netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                
                netconnType = @"4G";
            }
        }
            break;
            
        default:
            break;
    }
    
    return netconnType;
}

/**
 *  监听网络状态变化
 *
 *  @param successCallbackId    接口调用成功的回调函数
 *  @param failCallbackId       接口调用失败的回调函数
 
 */
-(void)onNetworkStatusChangeWithSuccessCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId
{
   
    if(!self.ablity)
    {
      self.ablity = [HETReachability reachabilityForInternetConnection];//[HETReachability reachabilityWithHostName:@"www.apple.com"];
    }
    [self.ablity startNotifier];
    __weak typeof(self) weakSelf = self;
    self.ablity.unreachableBlock = ^(HETReachability *reachability) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
         NSString *netconnType =[strongSelf getNetconnType];
        NSDictionary *dic=@{@"data":@{@"isConnected":@"0",@"networkType":netconnType}};
        [strongSelf.jsBridge webViewOnNetworkStatusChangeResponse:dic callBackId:successCallbackId];
    };
    self.ablity.reachableBlock = ^(HETReachability *reachability) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *netconnType =[strongSelf getNetconnType];
        NSDictionary *dic=@{@"data":@{@"isConnected":@"1",@"networkType":netconnType}};
        [strongSelf.jsBridge webViewOnNetworkStatusChangeResponse:dic callBackId:successCallbackId];
    };
}




/**
 *  获取设备信息
 *
 *  @param successCallbackId    接口调用成功的回调函数
 *  @param failCallbackId       接口调用失败的回调函数
 
 */
-(void)getDeviceInfoWithSuccessCallbackId:(id)successCallbackId failCallbackId:(id)failCallbackId
{
    [HETDeviceRequestBusiness fetchDeviceInfoWithDeviceId:self.deviceModel.deviceId success:^(id responseObject) {
        NSLog(@"获取设备基本信息:%@",responseObject);
        [_jsBridge webViewGetDeviceInfoResponse:responseObject[@"data"] callBackId:successCallbackId];
    } failure:^(NSError *error) {
        NSLog(@"获取设备基本信息失败:%@",error);
        NSString *errorMsg=error.userInfo[@"msg"];
        
        
        [_jsBridge webViewGetDeviceInfoResponse:@{@"code":@(error.code),@"msg":errorMsg.length? errorMsg:error.description} callBackId:successCallbackId];
    }];
    /*HETDeviceGetDeviceInfoRequest * configGet = [[HETDeviceGetDeviceInfoRequest alloc] initWithAppType:2 accessToken:[HETUserInfo userInfo].accessToken andDeviceId:self.deviceId];
    [configGet startWithSuccess:^(NSDictionary *dictValue) {
        if ([dictValue isKindOfClass:[NSNull class]]) {
            return ;
        }
        NSLog(@"获取设备基本信息:%@",dictValue);
        [_jsBridge webViewGetDeviceInfoResponse:dictValue callBackId:successCallbackId];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"获取设备基本信息失败:%@",error);
        NSString *errorMsg=error.userInfo[@"msg"];

        
        [_jsBridge webViewGetDeviceInfoResponse:@{@"code":@(statusCode),@"msg":errorMsg.length? errorMsg:error.description} callBackId:successCallbackId];
    }];*/
}


/**
 *  H5主动获取设备MCU升级
 *
 *  @param successCallbackId    接口调用成功的回调函数
 *  @param failCallbackId       接口调用失败的回调函数
 *  @param progressCallbackId   进度的回调函数
 
 */
-(void)getDeviceMcuUpgradeWithSuccessCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId progressCallbackId:(id)progressCallbackId
{
    
}


/**
 *  H5分享接口
 *
 *  @param title    提示的标题
 *  @param content    提示的内容
 *  @param images   分享的图片数组
 *  @param url    分享的链接url
 *  @param successCallbackId   接口调用成功的回调函数
 *  @param failCallbackId    接口调用失败的回调函数
 *  @param completeCallbackId    接口调用结束的回调函数（调用成功、失败)
 
 */
-(void)showShareActionSheetWithTitle:(id )title content:(id) content images:(id) images  url:(id)url  successCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId  completeCallbackId:(id) completeCallbackId
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark-==========WKNavigationDelegate================


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    //开始加载的时候，让进度条显示
    self.progressView.hidden = NO;
    if(self.hetDeviceControlWKWebviewDelegate && [self.hetDeviceControlWKWebviewDelegate respondsToSelector:@selector(webViewDidStartLoad:)])
    {
        [self.hetDeviceControlWKWebviewDelegate webViewDidStartLoad:webView];
    }
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    
//    self.needStart=YES;
//    if (self.communicationManager.deviceDefaultCfgData)
//    {
//        [self webViewRepaint:self.communicationManager.deviceDefaultCfgData];
//    }
//    [self start];
    if(self.hetDeviceControlWKWebviewDelegate && [self.hetDeviceControlWKWebviewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)])
    {
        [self.hetDeviceControlWKWebviewDelegate webViewDidFinishLoad:webView];
    }
    
    
    
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    
    /* 停止加载页面*/
    [webView stopLoading];
    
    if ([error code] == NSURLErrorCancelled) {
        
//        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.h5Path]]];
//        // [self loadRequestWithURL:[NSURL URLWithString:_h5path]];
    }
    else  if(self.hetDeviceControlWKWebviewDelegate && [self.hetDeviceControlWKWebviewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)])
    {
        [self.hetDeviceControlWKWebviewDelegate webView:webView didFailLoadWithError:error];
    }
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
    NSString *requestString =[[navigationAction.request URL]absoluteString];
    //NSLog(@"requestString:%@",requestString);
    if([requestString hasPrefix:@"http"]||[requestString hasPrefix:@"file://"])
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else
    {
        /*不做跳转 需要弹出ui的时候执行代理*/
        decisionHandler(WKNavigationActionPolicyCancel);
        if(self.hetDeviceControlWKWebviewDelegate && [self.hetDeviceControlWKWebviewDelegate respondsToSelector:@selector(updateAPPUIprotolString:)])
        {
            [self.hetDeviceControlWKWebviewDelegate updateAPPUIprotolString:requestString];
        }
        
    }
    
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
- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

- (HETH5CustomNavigationBar *)h5CustomNavigationBar{
    if (!_h5CustomNavigationBar) {
        _h5CustomNavigationBar = [HETH5CustomNavigationBar CustomNavigationBar];
    }
    return _h5CustomNavigationBar;
}
-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc]
                                           initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.backgroundColor = [UIColor redColor];
        _progressView.frame             = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5);
        
        [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255
                                                         green:240.0/255
                                                          blue:240.0/255
                                                         alpha:1.0]];
        _progressView.progressTintColor =self.h5CustomNavigationBar.barBackgroundColor;// [UIColor greenColor];
        
        
    }
    return _progressView;
}
-(void)dealloc
{
    
    [self.ablity stopNotifier];
    self.ablity=nil;
    [_wkWebView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}
@end
