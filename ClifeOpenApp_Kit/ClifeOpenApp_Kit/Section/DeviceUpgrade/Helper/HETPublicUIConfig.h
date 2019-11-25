//
//  HETPublicUIConfig.h
//  HETPublic
//
//  Created by tl on 15/8/13.
//  Copyright (c) 2015年 HET. All rights reserved.
// 

#import <UIKit/UIKit.h>

@protocol HETPublicVCProtocol <NSObject>

/**
 *  导航栏是否隐藏，默认 NO
 */
@property (nonatomic,assign)BOOL navBarHidden;

@end

typedef void(^viewDidLoad)(UIViewController<HETPublicVCProtocol> *vc);
typedef void(^viewDidAppear)(UIViewController<HETPublicVCProtocol> *vc);
typedef void(^viewWillAppear)(UIViewController<HETPublicVCProtocol> *vc);
typedef void(^viewWillDisappear)(UIViewController<HETPublicVCProtocol> *vc);
typedef void(^viewDidDisappear)(UIViewController<HETPublicVCProtocol> *vc);
typedef void(^viewInteractivePopDisabled)(UIViewController<HETPublicVCProtocol> *vc);

typedef NS_OPTIONS(NSInteger, HETAccountType) {
    /**
     *  app内只有手机
     */
    HETAccountPhone = 1 << 0,
    /**
     *  app内只有邮箱
     */
    HETAccountEmail = 1<< 1,
};
@interface HETPublicUIConfig : NSObject
/**
 *  单例类，其实和下面的类方法一样，想少写一些代码
 */
+(instancetype)shareConfig;

/**
 *  账户体系
 */
@property (assign,nonatomic)HETAccountType accountType;

/**
 *  是否是企业版本,请优先填写
 */
@property (assign,nonatomic)BOOL isEnterprise;

#pragma mark ---****---****---****---****提供公共模块UIViewController 的定制部分以下方法均在原方法调用之后再调用(使其与其他项目中BaseViewController兼容)

+(void)het_viewDidLoad:(viewDidLoad)viewDidLoad;

+(void)het_viewDidAppear:(viewDidAppear)viewDidAppear;

+(void)het_viewWillAppear:(viewWillAppear)viewWillAppear;

+(void)het_viewWillDisappear:(viewWillDisappear)viewWillDisappear;

+(void)het_viewDidDisappear:(viewDidDisappear)viewDidDisappear;

/**
 *  关闭手势右滑删除（提供各个项目自定义的方法，如FDFullscreenPopGesture第三方库中fd_interactivePopDisabled属性，或interactivePopGestureRecognizer）
 */
+(void)het_viewInteractivePopDisabled:(viewInteractivePopDisabled)viewInteractivePopDisabled;

#pragma mark ---****---****---****---****loading遮挡框 hud 展现方式
/*!
 *  展示长久存在的hud
 *  @param title 内容
 */
+(void)het_showHudtitle:(void(^)(NSString *title))show;
/*!
 *  展示自动隐藏的hud
 *
 *  @param title 貌似我都传得nil。。用msg吧
 */
+(void)het_showAutoDissmissHud:(void(^)(NSString *title,NSString *msg))show;
/*!
 *  隐藏hud
 */
+(void)het_hidHud:(void(^)())hidhud;
#pragma mark ---****---****---****---****具体类型的定制
/**
 *  一些大按钮的颜色(就是那种很大的确定，下一步)
 *
 *  @param bigButtonColor 颜色，默认HEX："68B2F6"
 */
+(void)het_bigButtonColor:(UIColor *)bigButtonColor NS_DEPRECATED_IOS(2_0, 2_0, "已无用，大按钮颜色已经在UI颜色上统一配置");

/*!
 *  导航栏返回按钮的图片
 *
 *  @param image 大小，30*30
 */
+(void)het_navBackButtonItemImage:(UIImage*)image;

/**
 *  导航栏按钮完全自定义，若实现将无视上面的方法
 *
 *  @param button  [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton] animated:NO];
 */
+(void)het_navBackCustomButton:(UIButton *(^)())button;

/**
 *  当页面没有数据时，公共模块的图片自定义（替换小C图像）
 */
@property (strong,nonatomic)UIImage *nothingImage;

#pragma mark ---****---****---****---****下拉刷新，上拉加载的样式
typedef void(^headRefreshBlock)(void);
typedef void(^footRefreshBlock)(void);
/*!
 *  开始下拉刷新自定义方法
 *
 *  @param scrollView 需要下拉刷新的view，用于自定义下拉刷新样式
 *  @param refreshBlock 何时去刷新，请在需要刷新的地方调用，例如：在MJRefresh的那个[MJRefreshGifHeader headerWithRefreshingBlock:^{}]中block调用
 */
+(void)het_headerRefresh:(void(^)(UIScrollView *scrollView,headRefreshBlock refreshBlock))headRefresh;
/*!
 *  结束上拉刷新，用于自定义结束上拉刷新样式
 *
 *  @param scrollView ，例如调用MJRefresh中的：[scrollView.header endRefreshing];
 */
+(void)het_endHeaderRefresh:(void(^)(UIScrollView *scrollView))endHeadRefresh;
 
/*!
 *  开始上拉刷新自定义方法
 *
 *  @param scrollView 需要上拉刷新的view，用于自定义上拉刷新样式
 *  @param refreshBlock 何时去刷新，请在需要刷新的地方调用，例如：在MJRefresh的那个[MJRefreshGifHeader footerWithRefreshingBlock:^{}]中block调用
 */
+(void)het_footerRefresh:(void(^)(UIScrollView *scrollView,footRefreshBlock refreshBlock))footRefresh;
/*!
 *  结束上拉刷新，用于自定义结束上拉刷新样式
 *
 *  @param scrollView ，例如调用MJRefresh中的：[scrollView.footer endRefreshing];
 */
+(void)het_endFooterRefresh:(void(^)(UIScrollView *scrollView))endFootRefresh;

/*!
 *  上拉没有更多数据
 *
 *  @param scrollView ，例如调用MJRefresh中的：[scrollView.footer noticeNoMoreData];
 */
+(void)het_noMoreData:(void(^)(UIScrollView *scrollView))noMoreData;

/*!
 *  没有数据时的占位效果，如果调用该方法，将忽略上面的nothingImage属性.
 *
 *  @param bgView 和vc的view尺寸一样大，在上面可以自定义布局
 *  @param tipStr 提示语
 */
+(void)het_noneData:(void(^)(UIView *bgView,NSString *tipStr))noneDataBlock;


/**
 *  统一的头像占位图
 */
@property (nonatomic,strong)UIImage *headPlaceholderImage;


/**
 国际化文案
 1.block中moduleName是每个模块名,例如：`HETPublicSDK_Core`等.
 2.block需返回每个模块中国际化的string文件的文件名.
 3.string文件来源请搜索每个模块下的.string文件，根据已有文案，进行修改或增加语言.
 4.返回nil会默认使用公共模块文案.
 5.HETPublicSDK_RequestCore不在此设置中，见：HETNetworkConfig.
 */
+(void)het_moduleLocalizedTabelName:(NSString *(^)(NSString *moduleName))moduleLocalized;

/**
 *  用户协议和隐私协议那块，使用自己产品名称
 *
 *  @param name 默认：@"C-Life"
 */
+(void)prouductorName:(NSString *)name;

/**
 *  用户协议和隐私协议那块，自定义公司名
 *
 *  @param name 默认：@"深圳和而泰家居在线网络科技有限公司"
 */
+(void)companyName:(NSString *)name;

#pragma mark ---****---****---****---****公共模块颜色自定义
@property (strong,nonatomic)UIColor *color1;
@property (strong,nonatomic)UIColor *color2;
@property (strong,nonatomic)UIColor *color3;
@property (strong,nonatomic)UIColor *color4;
@property (strong,nonatomic)UIColor *color5;
@property (strong,nonatomic)UIColor *color6;
@property (strong,nonatomic)UIColor *color7;
@property (strong,nonatomic)UIColor *color8;
@property (strong,nonatomic)UIColor *color9;
@property (strong,nonatomic)UIColor *color10;
@property (strong,nonatomic)UIColor *color11;
@property (strong,nonatomic)UIColor *color12;
@property (strong,nonatomic)UIColor *color13;
@property (strong,nonatomic)UIColor *color14;
@property (strong,nonatomic)UIColor *color15;
@property (strong,nonatomic)UIColor *color16;
@property (strong,nonatomic)UIColor *color17;
@property (strong,nonatomic)UIColor *color18;
@property (strong,nonatomic)UIColor *color19;

@property (strong,nonatomic)UIColor *color20;
@property (strong,nonatomic)UIColor *color21;
@property (strong,nonatomic)UIColor *color22;
@property (strong,nonatomic)UIColor *color23;
@property (strong,nonatomic)UIColor *color24;
@property (strong,nonatomic)UIColor *color25;
@property (strong,nonatomic)UIColor *color26;
@property (strong,nonatomic)UIColor *color27;
@property (strong,nonatomic)UIColor *color28;
@property (strong,nonatomic)UIColor *color29;

#pragma mark ---****---****---****---****公共模块字体自定义
@property (strong,nonatomic)UIFont *font1;
@property (strong,nonatomic)UIFont *font1_Blod;
@property (strong,nonatomic)UIFont *font2;
@property (strong,nonatomic)UIFont *font2_Blod;
@property (strong,nonatomic)UIFont *font3;
@property (strong,nonatomic)UIFont *font4;
@property (strong,nonatomic)UIFont *font5;
@end



