//
//  UIColor+BNRAdditions.h
//  BNRSDKLib
//
//  Created by JustinYang on 8/24/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BNRAdditions)
/**
 *
 *
 *  @param color 0x xx|xx|xx|xx 对应RGB 和透明度
 *
 *  @return <#return value description#>
 */
+(NSUInteger)getRGBValueWithColor:(UIColor *)color;

+(NSString *)getHexStrFromUIColor: (UIColor*) color;

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;

+(UIColor *) colorFromHexRGB:(NSString *) inColorString alpha:(CGFloat)colorAlpha ;
@end
