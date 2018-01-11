//
//  HETH5DownloadViewController.h
//  ClifeOpenApp_Kit
//
//  Created by yuan yunlong on 2017/11/6.
//  Copyright © 2017年 het. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface HETH5ViewController : UIViewController
/** 设备信息 **/
@property (nonatomic,strong)  HETDevice *deviceModel;
/** H5资源路径 **/
@property (nonatomic,copy) NSString *h5Path;
/** 加载H5webView **/
@property (nonatomic,strong) WKWebView *wkWebView;

- (void)reload;
@end
