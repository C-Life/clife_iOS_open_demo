//
//  HETPublicUIConfig.m
//  HETPublic
//
//  Created by tl on 15/8/13.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import "HETPublicUIConfig.h"
#import <objc/runtime.h>

@implementation HETPublicUIConfig
+(instancetype)shareConfig{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HETPublicUIConfig alloc] init];
    });
    return sharedInstance;
}
-(HETAccountType)accountType{
    return _accountType?_accountType:(HETAccountEmail|HETAccountPhone);
}
#pragma mark -----提供公共模块UIViewController 的定制部分
+(void)het_viewDidLoad:(viewDidLoad)viewDidLoad{
    objc_setAssociatedObject(self, @selector(het_viewDidLoad:), viewDidLoad, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+(void)het_viewWillAppear:(viewWillAppear)viewWillAppear{
    objc_setAssociatedObject(self, @selector(het_viewWillAppear:), viewWillAppear, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+(void)het_viewDidAppear:(viewDidAppear)viewDidAppear{
    objc_setAssociatedObject(self, @selector(het_viewDidAppear:), viewDidAppear, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+(void)het_viewWillDisappear:(viewWillDisappear)viewWillDisappear{
    objc_setAssociatedObject(self, @selector(het_viewWillDisappear:), viewWillDisappear, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+(void)het_viewDidDisappear:(viewDidDisappear)viewDidDisappear{
    objc_setAssociatedObject(self, @selector(het_viewDidDisappear:), viewDidDisappear, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+(void)het_viewInteractivePopDisabled:(viewInteractivePopDisabled)viewInteractivePopDisabled{
    objc_setAssociatedObject(self, @selector(het_viewInteractivePopDisabled:), viewInteractivePopDisabled, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark ---- loading遮挡框 hud 展现方式
/*!
 *  展示长久存在的hud
 *  @param title 内容
 */
+(void)het_showHudtitle:(void(^)(NSString *title))show{
    objc_setAssociatedObject(self, @selector(het_showHudtitle:), show, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
/*!
 *  展示自动隐藏的hud
 *
 *  @param title 貌似我都传得nil。。用msg吧
 */
+(void)het_showAutoDissmissHud:(void(^)(NSString *title,NSString *msg))show{
    objc_setAssociatedObject(self, @selector(het_showAutoDissmissHud:), show, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
/*!
 *  隐藏hud
 */
+(void)het_hidHud:(void(^)())hidhud{
    objc_setAssociatedObject(self, @selector(het_hidHud:), hidhud, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark ------具体类型的定制
/**
 *  一些大按钮的颜色(就是那种很大的确定，下一步)
 */
+(void)het_bigButtonColor:(UIColor *)bigButtonColor{
    objc_setAssociatedObject(self, @selector(het_bigButtonColor:), bigButtonColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/*! 
 *  导航栏返回按钮的图片 
 *
 *  @param image 大小，30*30
 */
+(void)het_navBackButtonItemImage:(UIImage*)image{
    objc_setAssociatedObject(self, @selector(het_navBackButtonItemImage:), image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+(void)het_navBackCustomButton:(UIButton *(^)())button{
    objc_setAssociatedObject(self, @selector(het_navBackCustomButton:), button, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark------- 下拉刷新，上拉加载的样式
+(void)het_headerRefresh:(void(^)(UIScrollView *scrollView,headRefreshBlock refreshBlock))headRefresh{
    objc_setAssociatedObject(self, @selector(het_headerRefresh:), headRefresh, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+(void)het_endHeaderRefresh:(void(^)(UIScrollView *scrollView))endHeadRefresh{
    objc_setAssociatedObject(self, @selector(het_endHeaderRefresh:), endHeadRefresh, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+(void)het_footerRefresh:(void(^)(UIScrollView *scrollView,footRefreshBlock refreshBlock))footRefresh{
    objc_setAssociatedObject(self, @selector(het_footerRefresh:), footRefresh, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+(void)het_endFooterRefresh:(void(^)(UIScrollView *scrollView))endFootRefresh{
    objc_setAssociatedObject(self, @selector(het_endFooterRefresh:), endFootRefresh, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+(void)het_noMoreData:(void(^)(UIScrollView *scrollView))noMoreData{
    objc_setAssociatedObject(self, @selector(het_noMoreData:), noMoreData, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+(void)het_noneData:(void(^)(UIView *bgView,NSString *tipStr))noneDataBlock{
    objc_setAssociatedObject(self, @selector(het_noneData:), noneDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+(void)het_moduleLocalizedTabelName:(NSString *(^)(NSString *moduleName))moduleLocalized{
    objc_setAssociatedObject(self, @selector(het_moduleLocalizedTabelName:), moduleLocalized, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
