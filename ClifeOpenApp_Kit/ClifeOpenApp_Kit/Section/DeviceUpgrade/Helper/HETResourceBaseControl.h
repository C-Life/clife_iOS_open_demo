//
//  HETLocalizedBaseControl.h
//  HETPublicSDK_Core
//
//  Created by tl on 15/11/27.
//  Copyright © 2015年 HET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  所有模块的国际化继承此类，并实现tableName方法
 *  所有资源文件读取也走此类，NSBundle及UIImage
 *
 */
@interface HETResourceBaseControl : NSObject
/**
 *  国际化后的字，可以自定义宏来简化写法，例如：HETLoginLolocalized()
 *
 *  @return 子类 不用重写
 */
+(NSString *)localizedString:(NSString *)string;

/**
 *  自定义表.string的名字
 *
 *  @return 子类需重写
 */
+(NSString *)tableName;

/**
 模块名，当前模块的模块名（Pod叫啥名，就返回啥）
 子类需重写
 */
+(NSString *)moduleName;


+(UIImage *)imageNamed:(NSString *)imageNameStr;

+(NSBundle *)moduleBundle;
@end
