//
//  HETLocalizedBaseControl.m
//  HETPublicSDK_Core
//
//  Created by tl on 15/11/27.
//  Copyright © 2015年 HET. All rights reserved.
//

#import "HETResourceBaseControl.h"
#import "CCCommonHelp.h"
@implementation HETResourceBaseControl
+(NSString *)localizedString:(NSString *)string{
    NSString *resourceStr =[[NSUserDefaults standardUserDefaults] objectForKey:@"userLanguage"];
    if (resourceStr.length == 0) {
        resourceStr = @"zh-Hans";
    }
    NSBundle *bundle = [self moduleBundle];
    NSString *tableName = [self tableName];
    //1.模块名已经填写 2.业务线中有自定义table
    NSString *customTableName = [CCCommonHelp LocalizedTableNameWithModule:[self moduleName]];
    if ([self moduleName].length > 0 && customTableName.length > 0) {
        bundle = [NSBundle mainBundle];
        tableName = customTableName;
    }
    NSString *s = [[NSBundle bundleWithPath:[bundle pathForResource:[NSString stringWithFormat:@"%@",resourceStr] ofType:@"lproj"]] localizedStringForKey:(string) value:@"" table:tableName];
    return s.length > 0?s:string;
}
+(NSString *)tableName{
    return nil;
}
+(NSString *)moduleName{
    return nil;
}
+(UIImage *)imageNamed:(NSString *)imageNameStr{
    return [UIImage imageNamed:imageNameStr inBundle:[self moduleBundle] compatibleWithTraitCollection:nil];
}
+(NSBundle *)moduleBundle{
    NSBundle *b = [NSBundle bundleWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/Frameworks/%@.framework",[self moduleName]]]];
    if (!b) {
        b = [NSBundle bundleForClass:self];
    }
    return b;
}
@end
