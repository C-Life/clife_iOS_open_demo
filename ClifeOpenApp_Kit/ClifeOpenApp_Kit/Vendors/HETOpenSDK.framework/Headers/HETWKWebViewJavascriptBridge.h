//
//  HETWKWebViewJavascriptBridge.h
//  HETOpenSDK
//
//  Created by mr.cao on 2017/10/19.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@protocol HETWKWebViewJavascriptBridgeDelegate<NSObject>

@optional
/**
 *  js调用的配置接口
 *
 *  @param data js配置数据
 */
-(void)config:(id)data;


/**
 *  js调用的发送数据接口
 *
 *  @param data 将发送给app的数据，一般是完整的控制数据(json字符串)
 *  @param successCallback  app方数据处理成功时将调用该方法
 *  @param errorCallback    app方数据处理失败时将调用该方法
 */
-(void)send:(id)data successCallback:(id)successCallback errorCallback:(id)errorCallback;


/**
 *  js调用的设置页面标题接口(该方法用于将标题发送给app，以供app进行标题更新 旧版本接口)
 *
 *  @param data  将设置的标题
 */
-(void)title:(id)data;


/**
 *  js调用的提示弹窗接口（旧版本接口)
 *
 *  @param data  弹窗内容
 */
-(void)tips:(id)data;


///**
// *  js调用的系统toast接口(方法用于调用系统toast，以便app方统一toast风格)
// *
// *  @param data 将要弹出的提示信息
// */
//-(void)toast:(id)data;

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
-(void)relProxyHttp:(id)url data:(id)data httpType:(id) type sucCallbackId:(id) sucCallbackId errCallbackId:(id) errCallbackId needSign:(id) needSign;

/**
 *  绝对网络请求
 *
 *  @param url    请求地址。如用绝对地址（如：https://baidu.com/v1/app/get）
 *  @param data   发送数据。形式为：{"name": "张三", "age": 21, ...}
 *  @param type   HTTP请求类型，如Get,Post请求
 *  @param sucCallbackId   接口调用成功的回调函数
 *  @param errCallbackId    接口调用失败的回调函数
 */
-(void)absProxyHttp:(id)url data:(id)data httpType:(id) type sucCallbackId:(id) sucCallbackId errCallbackId:(id) errCallbackId;

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
-(void)onLoadH5Failed:(id)errCode errMsg:(id)errMsg;

/**
 *  h5传数据给native指h5传递相关数据给native端，比如设置页面标题，当前版本信息等
 *
 *  @param routeUrl   路由方法名
 *  @param data   数据内容
 *  @param successCallbackId   接口调用成功的回调函数
 *  @param failedCallbackId    接口调用失败的回调函数

 */
-(void)h5SendDataToNative:(id) routeUrl data:(id) data successCallbackId:(id)successCallbackId failedCallbackId:(id) failedCallbackId;

/**
 *  h5从native端获取数据，比如定位信息，蓝牙是否开启等
 *
 *  @param routeUrl   路由方法名
 *  @param successCallbackId   接口调用成功的回调函数
 *  @param failedCallbackId    接口调用失败的回调函数
 
 */
-(void)h5GetDataFromNative:(id)routeUrl successCallbackId:(id)successCallbackId failedCallbackId:(id)failedCallbackId;


/**
 *  h5从native端获取JSBridege版本号
 *
 */
-(void)h5GetAPPJSBridgeVersion;


/**
 *  h5从native端获取APP语言（国际化）
 *
 */
-(void)h5GetAPPLanguage;


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
-(void)showToastWithTitle:(id)title icon:(id)icon image:(id)image duration:(id)duration mask:(id)mask  successCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId  completeCallbackId:(id) completeCallbackId;

/**
 *  隐藏消息提示框
 *
 */
-(void)hideToast;

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
-(void)showAlertViewWithTitle:(id)title content:(id)content showCancel:(id)showCancel cancelText:(id)cancelText cancelColor:(id)cancelColor confirmText:(id)confirmText confirmColor:(id)confirmColor successCallbackId:(id) successCallbackId failCallbackId:(id)failCallbackId completeCallbackId:(id) completeCallbackId;//显示提示框


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
-(void)showActionSheetWithTitle:(id)title itemList:(id)itemList itemColor:(id) itemColor successCallbackId:(id) successCallbackId failCallbackId:(id) failCallbackId completeCallbackId:(id) completeCallbackId;


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
-(void) setNavigationBarTitle:(id )title  frontColor:(id) frontColor  backgroundColor:(id) backgroundColor  image:(id) image  successCallbackId:(id) successCallbackId  failCallbackId:(id) failCallbackId  completeCallbackId:(id) completeCallbackId;

/**
 *  H5设置APP导航栏左右按钮的样式颜色，右边按钮的隐藏
 
 *  @param colorStyle 设置导航栏左右按钮的样式颜色，APP默认支持黑白两套图片，0代表白色样式，1代表黑色样式
 *  @param rightButtonHide 导航栏右边按钮是否隐藏，0代表不隐藏，1代表隐藏
 *  @param successCallbackId  接口调用成功的回调函数
 *  @param failCallbackId     接口调用失败的回调函数
 *  @param completeCallbackId 接口调用结束的回调函数（调用成功、失败都会执行）
 */
-(void)setNavigationBarButtonWithColorStyle:(id)colorStyle rightButtonHide:(id)rightButtonHide successCallbackId:(id)successCallbackId failCallbackId:(id)failCallbackId completeCallbackId:(id)completeCallbackId;

/**
 *  设置导航栏左边按钮
 *
 *  @param itemList           按钮集合对象数组，最多两个按钮（按钮顺序是从左到右）,按钮元素参数{title: '按钮标题',image:'按钮图片路径',tintColor:'按钮字体颜色HexColor',backgroundColor:'按钮背景颜色HexColor'}
 *  @param successCallbackId  接口调用成功的回调函数
 *  @param failCallbackId     接口调用失败的回调函数
 
 */
-(void)setNavigationBarLeftBarButtonItems:(id)itemList  successCallbackId:(id) successCallbackId  failCallbackId:(id)failCallbackId;


/**
 *  设置导航栏右边按钮
 *
 *  @param itemList           按钮集合对象数组，最多两个按钮（按钮顺序是从左到右）,按钮元素参数{title: '按钮标题',image:'按钮图片路径',tintColor:'按钮字体颜色HexColor',backgroundColor:'按钮背景颜色HexColor'}
 *  @param successCallbackId  接口调用成功的回调函数
 *  @param failCallbackId     接口调用失败的回调函数
 
 */
-(void)setNavigationBarRightBarButtonItems:(id)itemList  successCallbackId:(id) successCallbackId  failCallbackId:(id)failCallbackId;



/**
 *  设置导航栏菜单
 *
 *  @param itemList              按钮集合对象数组，（按钮顺序是从上到下）,按钮元素参数{title: '标题',image:'图片路径',tintColor:'字体颜色HexColor',backgroundColor:'背景颜色HexColor'}|
 *  @param backgroundColor       菜单的背景颜色，默认为"#000000"
 *  @param successCallbackId     接口调用成功的回调函数，详见返回参数说明
 *  @param failCallbackId        接口调用失败的回调函数
 *  @param completeCallbackId    接口调用结束的回调函数（调用成功、失败都会执行）
 
 */
-(void)setNavigationBarMenuItem:(id)itemList  backgroundColor:(id)backgroundColor  successCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId  completeCallbackId:(id)completeCallbackId;

/**
 *  获取网络类型
 *
 *  @param successCallbackId    接口调用成功的回调函数
 *  @param failCallbackId       接口调用失败的回调函数
 
 */
-(void)getNetworkTypeWithSuccessCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId;


/**
 *  监听网络状态变化
 *
 *  @param successCallbackId    接口调用成功的回调函数
 *  @param failCallbackId       接口调用失败的回调函数
 
 */
-(void)onNetworkStatusChangeWithSuccessCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId;


/**
 *  获取蓝牙设备的实时数据
 *
 *  @param successCallbackId    接口调用成功的回调函数
 *  @param failCallbackId       接口调用失败的回调函数
 
 */
-(void)getBLERealTimeDataWithSuccessCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId;


/**
 *  获取蓝牙设备的时间
 *
 *  @param successCallbackId    接口调用成功的回调函数
 *  @param failCallbackId       接口调用失败的回调函数
 
 */
-(void)getBLETimeDataWithSuccessCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId;


/**
 *  设置蓝牙设备的时间
 *
 *  @param successCallbackId    接口调用成功的回调函数
 *  @param failCallbackId       接口调用失败的回调函数
 
 */
-(void)setBLETimeDataWithSuccessCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId;

/**
 *  获取蓝牙设备历史数据
 *
 *  @param successCallbackId    接口调用成功的回调函数
 *  @param failCallbackId       接口调用失败的回调函数
 *  @param progressCallbackId   进度的回调函数
 
 */
-(void)getBLEHistoryDataWithSuccessCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId progressCallbackId:(id)progressCallbackId;

/**
 *  监听蓝牙适配器状态变化事件
 *
 *  @param successCallbackId    接口调用成功的回调函数
 *  @param failCallbackId       接口调用失败的回调函数
 *  @param completeCallbackId   接口调用结束的回调函数（调用成功、失败都会执行）
 
 */
-(void)onBluetoothAdapterStateChangeWithSuccessCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId completeCallbackId:(id)completeCallbackId;


/**
 *  获取当前蓝牙适配器状态
 *
 *  @param successCallbackId    接口调用成功的回调函数
 *  @param failCallbackId       接口调用失败的回调函数
 *  @param completeCallbackId   接口调用结束的回调函数（调用成功、失败都会执行）
 
 */
-(void)getBluetoothAdapterStateWithSuccessCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId completeCallbackId:(id)completeCallbackId;

/**
 *  获取设备信息
 *
 *  @param successCallbackId    接口调用成功的回调函数
 *  @param failCallbackId       接口调用失败的回调函数
 
 */
-(void)getDeviceInfoWithSuccessCallbackId:(id)successCallbackId failCallbackId:(id)failCallbackId;


/**
 *  H5主动获取设备MCU升级
 *
 *  @param successCallbackId    接口调用成功的回调函数
 *  @param failCallbackId       接口调用失败的回调函数
 *  @param progressCallbackId   进度的回调函数
 
 */
-(void)getDeviceMcuUpgradeWithSuccessCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId progressCallbackId:(id)progressCallbackId;


/**
 *  H5分享接口
 *
 *  @param title    提示的标题
 *  @param content    提示的内容
 *  @param images   分享的图片数组
 *  @param url    分享的链接url
 *  @param successCallbackId   接口调用成功的回调函数
 *  @param failCallbackId    接口调用失败的回调函数|
 *  @param completeCallbackId    接口调用结束的回调函数（调用成功、失败)
 
 */
-(void)showShareActionSheetWithTitle:(id )title content:(id) content images:(id) images  url:(id)url  successCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId  completeCallbackId:(id) completeCallbackId;

/**
 *  H5获取APP当前的地理位置信息接口
 *
 *  @param type    默认为 wgs84 返回 GPS 坐标；gcj02 返回国测局坐标
 *  @param altitude    传入 true 会返回高度信息，由于获取高度需要较高精确度，会减慢接口返回速度
 *  @param successCallbackId   接口调用成功的回调函数
 *  @param failCallbackId    接口调用失败的回调函数
 *  @param completeCallbackId    接口调用结束的回调函数（调用成功、失败)
 
 */
-(void)userLocationWithType:(id)type altitude:(id)altitude successCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId  completeCallbackId:(id) completeCallbackId;

/**
 *  JS调用app端HTTP功能（带het业务）
 *
 *  @param host    http请求地址
 *  @param path    http接口的path
 *  @param paramJson   配置http参数，以及http请求参数
 *  @param successCallbackId   接口调用成功的回调函数
 *  @param failCallbackId    接口调用失败的回调函数
 
 */
-(void)proxyHttpWithHet:(id)host path:(id)path paramJson:(id)paramJson successCallbackId:(id)successCallbackId  failCallbackId:(id)failCallbackId;

@end


@interface HETWKWebViewJavascriptBridge : NSObject

@property (nonatomic,weak) id<HETWKWebViewJavascriptBridgeDelegate>delegate;

+ (instancetype)bridgeForWebView:(WKWebView*)webView;

- (void)setNavigationDelegate:(id<WKNavigationDelegate>)navigationDelegate;


/**
 *  H5调用config接口后需要APP调用此方法，告知js准备好了(注意此方法调用之后，一般需要紧接着调用webViewConfigDataRepaint传配置数据给H5初始化界面)
 *
 *  @param dic 数据
 */
-(void)webViewReady:(NSDictionary *)dic;


/**
 *  传配置数据给js
 *
 *  @param dic 控制数据
 */
-(void)webViewConfigDataRepaint:(NSDictionary *)dic;

/**
 *  传运行数据给js
 *
 *  @param dic 运行数据
 */
-(void)webViewRunDataRepaint:(NSDictionary *)dic;

/**
 *  设备控制的时候下发成功，将事件告知js
 *
 *  @param dic             需要传递的参数，可填nil
 *  @param successCallBlock 成功的回调，这个回调是从webview那边获取的
 */
- (void)updateDataSuccess:(NSDictionary *)dic successCallBlock:(id)successCallBlock;


/**
 *  设备控制的时候下发失败，将事件告知js
 *
 *  @param dic            需要传递的参数，可填nil
 *  @param errorCallBlock  失败的回调，这个回调是从webview那边获取的
 */
- (void)updateDataError:(NSDictionary *)dic errorCallBlock:(id)errorCallBlock;



/**
 *  APP将网络请求的成功结果回传给js
 *
 *  @param dic              请求的结果
 *  @param successCallBlock 成功的回调
 */

-(void)webViewHttpResponseSuccessResponse:(NSDictionary *)dic  successCallBlock:(id)successCallBlock;

/**
 *  APP将网络请求的失败结果回传给js
 *
 *  @param dic              请求的结果
 *  @param errorCallBlock   失败的回调
 */

-(void)webViewHttpResponseErrorResponse:(NSDictionary *)dic  errorCallBlock:(id)errorCallBlock;




/**
 *  APP将通用接口请求的结果回传给js
 *
 *  @param dic              请求的结果
 *  @param callBackId  需与h5SendDataToNative接口返回的callBackId保持一致
 */

-(void)webViewNativeResponse:(NSDictionary *)dic  callBackId:(id)callBackId;

/**
 *  APP将JSBridege版本号的结果回传给js
 *
 *  @param version      JSBridege版本号
 */

-(void)webViewJSBridgeVersionResponse:(NSString*)version;


/**
 *  APP将国际化语言回传给js
 *
 *  @param language      国际化语言,简体中文:zh_CN,繁体中文:zh_TW，英文:en ,默认为zh_CN
 */

-(void)webViewAPPLanguageResponse:(NSString*)language;




/**
 *  APP将回传消息提示框的结果回传给js
 *
 *  @param dic             提示框相关信息
 *  @param callBackId  需与showToast接口返回的callBackId保持一致
 */

-(void)webViewShowToastResponse:(NSDictionary *)dic  callBackId:(id)callBackId;



/**
 *  APP将回传消息提示框的结果回传给js
 *
 *  @param dic             data:{
 confirm:1, //string 用户点击确认的标识
 cancel:1, //string 用户点击取消的标识
 error:xxx, //string 发生错误的信息
 }
 
 *  @param callBackId  需与showAlertView接口返回的callBackId保持一致
 */

-(void)webViewShowAlertViewResponse:(NSDictionary *)dic  callBackId:(id)callBackId;

/**
 *  APP将操作菜单的结果回传给js
 *
 *  @param dic              data:{
 index:0, //string 用户点击菜单选项的标识,0代表上面第一个（按钮顺序是从上到下）
 
 error:xxx, //string 发生错误的信息
 }
 
 *  @param callBackId  需与showActionSheet接口返回的callBackId保持一致
 */

-(void)webViewShowActionSheetResponse:(NSDictionary *)dic  callBackId:(id)callBackId;



/**
 *  APP将分享的结果回传给js
 *
 *  @param dic       分享的结果信息      dic示例
 data:{
 sharePlatformType:0, //string 0代表新浪分享的平台
 error:xxx, //string 发生错误的信息
 }
 sharePlatformType 有效值:
 
 |值    |说明|
 |-----|:----:|
 |SocialPlatformType_Sina               = 0 |新浪|
 |SocialPlatformType_WechatSession      = 1|微信聊天|
 |SocialPlatformType_WechatTimeLine     = 2|微信朋友圈|
 |SocialPlatformType_WechatFavorite     = 3|微信收藏|
 |SocialPlatformType_QQ                 = 4|QQ聊天页面|
 |SocialPlatformType_Qzone              = 5|qq空间|
 |SocialPlatformType_TencentWb          = 6|腾讯微博|
 |SocialPlatformType_AlipaySession      = 7|支付宝聊天页面|
 |SocialPlatformType_YixinSession       = 8|易信聊天页面|
 |SocialPlatformType_YixinTimeLine      = 9|易信朋友圈|
 |SocialPlatformType_YixinFavorite      = 10|易信收藏|
 |SocialPlatformType_LaiWangSession     = 11|点点虫（原来往）聊天页面|
 |SocialPlatformType_LaiWangTimeLine    = 12|点点虫动态|
 |SocialPlatformType_Sms                = 13|短信|
 |SocialPlatformType_Email              = 14|邮件|
 |SocialPlatformType_Renren             = 15|人人|
 |SocialPlatformType_Facebook           = 16|Facebook|
 |SocialPlatformType_Twitter            = 17|Twitter|
 |SocialPlatformType_Douban             = 18|豆瓣|
 |SocialPlatformType_KakaoTalk          = 19|KakaoTalk|
 |SocialPlatformType_Pinterest          = 20|Pinteres|
 |SocialPlatformType_Line               = 21|Line|
 |SocialPlatformType_Linkedin           = 22|领英|
 |SocialPlatformType_Flickr             = 23|Flickr|
 |SocialPlatformType_Tblr               = 24|Tblr|
 |SocialPlatformType_Instagram          = 25|Instagram|
 |SocialPlatformType_Whatsapp           = 26|Whatsapp|
 |SocialPlatformType_DingDing           = 27|钉钉|
 |SocialPlatformType_YouDaoNote         = 28|有道云笔记|
 |SocialPlatformType_EverNote           = 29|印象笔记|
 |SocialPlatformType_GooglePlus         = 30|Google+|
 |SocialPlatformType_Pocket             = 31|Pocket|
 |SocialPlatformType_DropBox            = 32|dropbox|
 |SocialPlatformType_VKontakte          = 33|vkontakte|
 |SocialPlatformType_FaceBookMessenger  = 34|FaceBookMessenger|
 |SocialPlatformType_Tim                = 35| Tencent TIM|
 
 
 *  @param callBackId  需与showShareActionSheet接口返回的callBackId保持一致
 */

-(void)webViewShowShareActionSheetResponse:(NSDictionary*)dic  callBackId:(id)callBackId;

/**
 *  APP将设置导航栏标题与颜色的结果回传给js
 *
 *  @param dic              请求的结果
 *  @param callBackId  需与setNavigationBarTitle接口返回的callBackId保持一致
 */

-(void)webViewSetNavigationBarTitleResponse:(NSDictionary *)dic  callBackId:(id)callBackId;




/**
 *  APP将设置导航栏左边按钮的结果回传给js
 *
 *  @param dic             data:{
 index:0, // 用户点击按钮选项的标识
 error:xxx, //string 发生错误的信息
 }
 
 *  @param callBackId  需与setNavigationBarLeftBarButtonItems接口返回的callBackId保持一致
 */

-(void)webViewSetNavigationBarLeftBarButtonItemsResponse:(NSDictionary *)dic  callBackId:(id)callBackId;



/**
 *  APP将设置导航栏右边按钮的结果回传给js
 *
 *  @param dic             data:{
 index:0, // 用户点击按钮选项的标识
 error:xxx, //string 发生错误的信息
 }
 
 *  @param callBackId  需与setNavigationBarRightBarButtonItems接口返回的callBackId保持一致
 */

-(void)webViewSetNavigationBarRightBarButtonItemsResponse:(NSDictionary *)dic  callBackId:(id)callBackId;


/**
 *  APP将设置导航栏菜单的结果回传给js
 *
 *  @param dic              data:{
 index:0, // 用户点击菜单选项的标识，0代表上面第一个（按钮顺序是从上到下）
 error:xxx, //string 发生错误的信息
 }
 *  @param callBackId  需与setNavigationBarMenuItem接口返回的callBackId保持一致
 */

-(void)webViewSetNavigationBarMenuItemResponse:(NSDictionary *)dic  callBackId:(id)callBackId;


/**
 *  APP将获取当前的网络类型的结果回传给js
 *
 *  @param dic          网络状态相关信息     data:{
 isConnected:0, // 网络状态
 networkType:wifi, //string 网络类型
 error:xxx, //string 发生错误的信息
 }
 isConnected 有效值:
 
 |值    |说明|
 |-----|:----:|
 |0    | 无网络|
 |1    | 有网络|
 
 networkType 有效值：
 
 
 |值    |说明|
 |-----|:----:|
 |wifi    |wifi 网络|
 |2g    |2g 网络|
 |3g    |3g 网络|
 |4g    |4g 网络|
 |none|    无网络|
 |unknown    |Android下不常见的网络类型|
 *  @param callBackId  需与getNetworkType接口返回的callBackId保持一致
 */

-(void)webViewCurrentNetworkTypeResponse:(NSDictionary *)dic  callBackId:(id)callBackId;

/**
 *  APP将网络状态变化的结果回传给js
 *
 *  @param dic              dic示例
 
 data:{
 isConnected:0, // 网络状态
 networkType:wifi, //string 网络类型
 error:xxx, //string 发生错误的信息
 }
 
 isConnected 有效值:
 
 |值    |说明|
 |-----|:----:|
 |0    | 无网络|
 |1    | 有网络|
 
 networkType 有效值：
 
 
 |值    |说明|
 |-----|:----:|
 |wifi    |wifi 网络|
 |2g    |2g 网络|
 |3g    |3g 网络|
 |4g    |4g 网络|
 |none|    无网络|
 |unknown    |Android下不常见的网络类型|
 
 *  @param callBackId  需与onNetworkStatusChange接口返回的callBackId保持一致
 */

-(void)webViewOnNetworkStatusChangeResponse:(NSDictionary *)dic  callBackId:(id)callBackId;

/**
 *  APP将蓝牙状态上传给js
 *
 *  @param bleStateType              请求的结果
 bleStateType 有效值：
 
 
 |值    |说明|
 |-----|:----:|
 |0    |未连接|
 |1    |连接中|
 |2    |连接上|
 |3    |连接失败|
 |4    |设备端主动断开了连接|
 |5|    设备重连中|
 |6|连接上并且认证成功|
 
 */

-(void)webViewSendBLEStateType:(NSString *)bleStateType;



/**
 *  APP将电池电量上传给js
 *
 *  @param power   蓝牙设备的电量,例如power为60，则电池电量60%
 
 */

-(void)webViewSendBLEPower:(NSString *)power;



/**
 *  APP将蓝牙实时数据上传给js
 *
 *  @param data   实时数据
 
 *  @param callBackId  需与getBLERealTimeData接口返回的callBackId保持一致
 */

-(void)webViewGetBLERealTimeDataResponse:(NSDictionary *)data  callBackId:(id)callBackId;

/**
 *  APP将蓝牙状态数据上传给js
 *
 *  @param dic   实时数据解析后的字典
 */

-(void)webViewSendBLEStatusData:(NSDictionary *)dic;



/**
 *  APP将蓝牙设备时间数据上传给js
 *
 *
 *  @param time        蓝牙设备的时间,十六制字符串
 *  @param callBackId  需与getBLERealTimeData接口返回的callBackId保持一致
 */

-(void)webViewGetBLETimeDataResponse:(NSString *)time  callBackId:(id)callBackId;


/**
 *  APP将设置蓝牙设备时间的结果回调上传给js
 *
 *
 *  @param timeType  0代表格林治时间，1代表本地时间(如北京时间)
 *  @param callBackId  需与getBLERealTimeData接口返回的callBackId保持一致
 */

-(void)webViewSetBLETimeDataResponse:(NSString *)timeType  callBackId:(id)callBackId;


/**
 *  APP将蓝牙设备历史数据上传给js
 *
 *
 *  @param data        蓝牙设备的历史数据的进度数据，data: {
 progress:10, // 升级的进度，代表升级到10%
 error:xxx, //string 发生错误的信息
 }
 *  @param callBackId  需与getBLEHistoryData接口返回的callBackId保持一致
 */

-(void)webViewGetBLEHistoryDataResponse:(NSDictionary *)data  callBackId:(id)callBackId;

/**
 *  APP传递蓝牙适配器状态给H5
 *
 *
 *  @param adapterState  adapterState 蓝牙开关状态，0是关闭，1是打开状态
 *  @param callBackId  对应onBluetoothAdapterStateChange函数参数的callbackId,如successCallbackId,failCallbackId,completeCallbackId
 */

-(void)webViewOnBluetoothAdapterStateChangeResponse:(NSString *)adapterState  callBackId:(id)callBackId;


/**
 *  APP传递蓝牙适配器状态给H5
 *
 *
 *  @param adapterState  adapterState 蓝牙开关状态，0是关闭，1是打开状态
 *  @param callBackId  对应getBluetoothAdapterState函数参数的callbackId,如successCallbackId,failCallbackId,completeCallbackId
 */

-(void)webViewGetBluetoothAdapterStateResponse:(NSString *)adapterState  callBackId:(id)callBackId;


/**
 *  APP将WiFi设备的控制数据上传给js
 *
 *  @param dic  控制数据
 
 */

-(void)webViewUpdataControlData:(NSDictionary *)dic;


/**
 *  APP将WiFi设备的运行数据上传给js
 *
 *  @param dic  运行数据
 
 */

-(void)webViewUpdataRunData:(NSDictionary *)dic;


/**
 *  APP将WiFi设备的故障数据上传给js
 *
 *  @param dic  故障数据
 
 */

-(void)webViewUpdataErrorData:(NSDictionary *)dic;


/**
 *  APP将WiFi设备的配置数据上传给js
 *
 *  @param dic  配置数据
 
 */

-(void)webViewUpdataConfigurationData:(NSDictionary *)dic;


/**
 *  APP将WiFi设备的在线离线状态上传给js
 *
 *  @param status  在线离线状态   0代表设备不在线,1代表设备在线
 
 */

-(void)webViewUpdataOnOffState:(NSString *)status;


/**
 *  APP将设备信息上传给js
 *
 *  @param dic        dic示例 data:{
 "deviceId": "501D275D6CD840F39FF862CC9AE3ABBA",
 "macAddress": "5c313e08fc09",
 "deviceBrandId": 1,
 "deviceBrandName": "和而泰",
 "deviceTypeId": 1,
 "deviceTypeName": "冰箱",
 "deviceSubtypeId": 1,
 "deviceSubtypeName": "冰箱",
 "deviceName": "CC13653",
 "roomId": 2,
 "roomName": "客厅",
 "bindTime": "2015-06-11 06:00:03",
 "onlineStatus":1,
 "share":1,
 "controlType":1,
 "userKey": "E4A6ECF07CC44D08D473FA42A580B78E",
 "authUserId":"501D275D6CD840F39FF862CC9AE3ABBA",
 "productId": 114,
 "productIcon": "http://200.200.200.50/v1/device/icon",
 "productName": "威力洗衣机",
 "productCode": "CC-1004",
 "moduleId": 3,
 "moduleName": "汉枫V7",
 "moduleType": 1,
 "radiocastName":null,
 "deviceCode": "0000C3AA00010105",
 "guideUrl"："http://200.200.200.50/XXX"
 }
 
 *  @param callBackId  需与getDeviceInfo接口返回的callBackId保持一致
 
 */

-(void)webViewGetDeviceInfoResponse:(NSDictionary *)dic  callBackId:(id)callBackId;



/**
 *  APP将设备MCU升级的结果上传给js
 *
 *
 *  @param dic       dic示例 data: {
 progress:10, // 升级的进度，代表升级到10%
 error:xxx, //string 发生错误的信息
 }
 *  @param callBackId  需与getDeviceMcuUpgrade接口返回的callBackId保持一致
 */
-(void)webViewGetDeviceMcuUpgradeResponse:(NSDictionary *)dic  callBackId:(id)callBackId;


/**
 *  APP将当前地理位置上传给js
 *
 *
 *  @param dic       dic示例 data:{
 latitude:0, //string 纬度，浮点数，范围为-90~90，负数表示南纬
 longitude:0, //string 经度，浮点数，范围为-180~180，负数表示西经
 speed:0, //string 速度，浮点数，单位m/s
 accuracy:0, //string 位置的精确度
 altitude:0, //string 高度，单位 m
 verticalAccuracy:0, //string 垂直精度，单位 m（Android 无法获取，返回 0）
 horizontalAccuracy:0, //string 水平精度，单位 m
 address:'中国广东省深圳市南山区科技南十路',//详细地址
 name:'科技南十路'//位置名称
 cityName:'深圳市‘//城市名
 }
 *  @param callBackId  需与userLocation接口返回的callBackId保持一致
 */
-(void)webViewUserLocationResponse:(NSDictionary *)dic  callBackId:(id)callBackId;

/**
 *  APP将视图展现在屏幕上了的事件通知给js
 *
 */

-(void)viewAppear;

/**
 *  APP将视图从屏幕上移除，用户看不到这个视图了的事件通知给js
 *
 *
 */
-(void)viewDisAppear;


/**
 *  APP将导航栏高度，电池栏高度通知给js
 *
 *
 */
-(void)sendNavigationBarHeight:(NSString *)navbarHeight StatusBarHeight:(NSString *)statusBarHeight;

@end
