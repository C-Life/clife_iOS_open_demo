//
//  HETCommonHelp.m
//  HETPublic
//
//  Created by mr.cao on 15/4/10.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import "HETCommonHelp.h"
#import "AppDelegate.h"

#pragma mark ---
@implementation HETCommonHelp

#pragma mark -----loading框方法集
+(MBProgressHUD *)showCustomHudtitle:(NSString *)title {

    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].windows.lastObject] ;
    [[UIApplication sharedApplication].windows.lastObject addSubview:hud];
    hud.dimBackground = NO;
    [hud setDetailsLabelText:title];
    [hud show:YES];
    return hud;
}

+(void)showAutoDissmissWithMessage:(NSString *)message
{
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].windows.lastObject] ;
    hud.mode=MBProgressHUDModeText;
    hud.dimBackground = NO;
    [[UIApplication sharedApplication].windows.lastObject addSubview:hud];
    [hud setDetailsLabelText:message];
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

+ (void)showMessage:(NSString *)message toView: (UIView *)view
{
    if ([message isEqualToString:@"loginRepeat"]) {
        return;
    }else{
        AppDelegate *appDeelgate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        MBProgressHUD *hud;
        if (view) {
            hud = [[MBProgressHUD alloc] initWithView:view];
        }else{
            hud = [[MBProgressHUD alloc] initWithWindow:appDeelgate.window] ;
        }
        hud.removeFromSuperViewOnHide = YES;
        hud.mode= MBProgressHUDModeText;
        hud.detailsLabelText = message;
        [hud show:YES];
        if (view) {
            [view addSubview: hud];
        }
        else{
            [appDeelgate.window addSubview:hud];
        }
    }
}

+ (void)showHudAutoHidenWithMessage:(NSString *)message toView: (UIView *)view
{
    if ([message isEqualToString:@"loginRepeat"]) {
        return;
    }else{
        AppDelegate *appDeelgate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        MBProgressHUD *hud;
        if (view) {
            hud = [[MBProgressHUD alloc] initWithView:view];
        }else{
            hud = [[MBProgressHUD alloc] initWithWindow:appDeelgate.window] ;
        }
        hud.removeFromSuperViewOnHide = YES;
        hud.mode= MBProgressHUDModeText;
        hud.dimBackground = NO;
        hud.labelText = message;
        hud.labelFont = [UIFont systemFontOfSize:15];
        [hud show:YES];
        if (view) {
            [view addSubview: hud];
        }
        else{
            [appDeelgate.window addSubview:hud];
        }
        [hud hide:YES afterDelay: 1.0];
    }
    
}

+ (void)showHudAutoHidenWithMessage: (NSString *)message{
    if ([message isEqualToString:@"loginRepeat"]) {
        return;
    }else{
        [self showHudWithMessage: message hiddenAfterDelay: 1.0];
    }
}

+ (void)showHudWithMessage: (NSString *)message hiddenAfterDelay: (float)seconds{

    if ([message isEqualToString:@"loginRepeat"]) {
        return;
    }else{

        AppDelegate *appDeelgate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:appDeelgate.window] ;
        hud.removeFromSuperViewOnHide = YES;
        hud.mode=MBProgressHUDModeText;
        [appDeelgate.window addSubview:hud];
        hud.detailsLabelText = message;
        [hud show:YES];
        [hud hide:YES afterDelay: seconds];
    }
}

+(void)HidHud
{
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].windows.lastObject animated:YES];
}

+ (void)hideHudFromView:(UIView *)view
{
    AppDelegate *appDeelgate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [MBProgressHUD hideAllHUDsForView:appDeelgate.window animated:YES];
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

@end
