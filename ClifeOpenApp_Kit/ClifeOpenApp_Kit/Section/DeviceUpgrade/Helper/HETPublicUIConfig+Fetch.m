//
//  HETPublicUIConfig+Fetch.m
//  HETPublic
//
//  Created by tl on 15/8/15.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import "HETPublicUIConfig+Fetch.h"
#import "SAMCategories.h"

@implementation HETPublicUIConfig (Fetch)
+(UIColor *)getBigButtonColor{
    UIColor *color =objc_getAssociatedObject(self, @selector(het_bigButtonColor:));
    if (!color) {
        color = [UIColor sam_colorWithHex:@"68B2F6"];
    }
    return color;
}

+(viewInteractivePopDisabled)start_het_viewInteractivePopDisabled{
    return objc_getAssociatedObject(self, @selector(het_viewInteractivePopDisabled:));
}
@end
