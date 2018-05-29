//
//  HETH5ContainBaseViewController.h
//  HETPublicSDK_HETH5DeviceControl
//
//  Created by mr.cao on 2018/3/12.
//  Copyright © 2018年 HET. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "HETWKWebViewJavascriptBridge.h"
//#import "MBProgressHUD.h"
#import "HETDevice.h"
@protocol HETDeviceControlWKWebviewDelegate;
@interface HETH5ContainBaseViewController : UIViewController<WKNavigationDelegate,HETWKWebViewJavascriptBridgeDelegate>
@property(nonatomic, strong) WKWebView *wkWebView;
@property(nonatomic, strong) HETWKWebViewJavascriptBridge *jsBridge;

@property(nonatomic,weak)id<HETDeviceControlWKWebviewDelegate>hetDeviceControlWKWebviewDelegate;
@property (nonatomic, copy) void(^onClickLeftButton)(NSUInteger index,NSString *title);
@property (nonatomic, copy) void(^onClickRightButton)(NSUInteger index,NSString *title);
/** 设备信息 **/
@property (nonatomic, strong)  HETDevice *deviceModel;
/** H5资源路径 **/
@property(nonatomic,copy) NSString *h5Path;
/** H5的目录，wkwebview需要指定H5目录 **/
@property(nonatomic,copy) NSString *h5fileDirectory;
//@property(nonatomic,copy) NSString *productId;
//@property(nonatomic,copy) NSString *deviceId;
//@property(nonatomic,copy) NSString *macAddress;
//@property(nonatomic,assign)NSUInteger deviceType;
//@property(nonatomic,assign)NSUInteger deviceSubType;
@end

@protocol HETDeviceControlWKWebviewDelegate <NSObject>


@optional

//获取H5 协议字符串，根据字符串APP做不同业务
-(void)updateAPPUIprotolString:(NSString *)protolString;

//获取H5 title
-(void)updateTitleString:(NSString *)title;

//获取H5 tips
-(void)updateTipsString:(NSString *)tips;

//代理H5网络请求的参数转换
-(NSDictionary *)relProxyHttpRequestParams:(NSDictionary *)param;

//小循环发送数据成功的回调
-(void)littleLoopRequestSuccess:(id)dic;


//小循环发送数据失败的回调
-(void)littleLoopRequestFail:(id)dic;




//webview开始加载
- (void)webViewDidStartLoad:(WKWebView *)webView;

//webview加载完成
- (void)webViewDidFinishLoad:(WKWebView *)webView;

//webview加载失败
- (void)webView:(WKWebView *)webView didFailLoadWithError:(NSError *)error;


//webview加载JS失败
- (void)webViewdidFailLoadJSWithErrorCode:(id) errCode   errorMsg:(id )errMsg;

//H5调用native的方法
-(void)h5SendDataToNative:(id) routeUrl  data:(id) data  successCallBackId:(id)successCallBackId failedCallBackId:(id) failedCallBackId;

-(void)h5GetDataToNative:(id) routeUrl   successCallBackId:(id)successCallBackId failedCallBackId:(id) failedCallBackId;
@end
