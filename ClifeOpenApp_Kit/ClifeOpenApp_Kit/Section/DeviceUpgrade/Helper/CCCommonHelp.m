//
//  CCCommonHelp.m
//  CCLoginAndRegistCommon
//
//  Created by mr.cao on 15/4/10.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import "CCCommonHelp.h"
#import "HETPublicUIConfig+Fetch.h"
#pragma mark -----HETPublicUIConfig category
@implementation HETPublicUIConfig (het_hud)
/*!
 *  长期存在hud事件block
 */
+(void(^)(NSString *title))getHet_showHudtitle{
    return objc_getAssociatedObject(self, @selector(het_showHudtitle:));
}
/*!
 *  自动隐藏hud事件block
 */
+(void(^)(NSString *title,NSString *msg))getHet_showAutoDissmissHud{
    return objc_getAssociatedObject(self, @selector(het_showAutoDissmissHud:));
}
/*!
 *  隐藏hud事件block
 */
+(void(^)())getHet_hidHud{
    return objc_getAssociatedObject(self, @selector(het_hidHud:));
}
+(void(^)(UIScrollView *scrollView,headRefreshBlock refreshBlock))getHet_headerRefresh{
    return objc_getAssociatedObject(self, @selector(het_headerRefresh:));
}
+(void(^)(UIScrollView *scrollView))getHet_endHeaderRefresh{
    return objc_getAssociatedObject(self, @selector(het_endHeaderRefresh:));
}
+(void(^)(UIScrollView *scrollView,footRefreshBlock refreshBlock))getHet_footerRefresh{
    return objc_getAssociatedObject(self, @selector(het_footerRefresh:));
}
+(void(^)(UIScrollView *scrollView))getHet_endFooterRefresh{
    return objc_getAssociatedObject(self, @selector(het_endFooterRefresh:));
}
+(void(^)(UIScrollView *scrollView))getHet_noMoreData{
    return objc_getAssociatedObject(self, @selector(het_noMoreData:));
}
+(NSString*(^)(NSString *str))getHet_moduleLocalizedTabelName{
    return objc_getAssociatedObject(self,@selector(het_moduleLocalizedTabelName:));
}
@end
#pragma mark ---
@implementation CCCommonHelp

#pragma mark -----loading框方法集
+(MBProgressHUD *)showCustomHudtitle:(NSString *)title {
    if ([HETPublicUIConfig getHet_showHudtitle]) {
        [HETPublicUIConfig getHet_showHudtitle](title);
        return nil;
    }
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow] ;
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.dimBackground = NO;
    [hud setDetailsLabelText:title];
    [hud show:YES];
    return hud;
}

+(void)showAutoDissmissAlertView:(NSString *)title msg:(NSString *)msg
{
    if ([HETPublicUIConfig getHet_showAutoDissmissHud]) {
        [HETPublicUIConfig getHet_showAutoDissmissHud](title,msg);
        return;
    }
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow] ;
    hud.mode=MBProgressHUDModeText;
    hud.dimBackground = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud setDetailsLabelText:msg];
    [hud show:YES];
    [hud hide:YES afterDelay:1.5];
}
+(void)HidHud
{
    if ([HETPublicUIConfig getHet_hidHud]) {
        [HETPublicUIConfig getHet_hidHud]();
        return;
    }
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

+(NSString *)LocalizedTableNameWithModule:(NSString *)moduleName{
    if ([HETPublicUIConfig getHet_moduleLocalizedTabelName]) {
        return [HETPublicUIConfig getHet_moduleLocalizedTabelName](moduleName);
    }
    return nil;
}
@end
