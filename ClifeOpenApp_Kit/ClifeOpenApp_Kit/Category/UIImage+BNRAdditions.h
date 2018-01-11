//
//  UIImage+BNRAdditions.h
//  BNRSDKLib
//
//  Created by JustinYang on 8/12/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BNRAdditions)
/**
 *  get Image according to Color
 *
 *  @param color 
 *
 *  @return
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  得到该点在图片中的颜色值
 *
 *  @param point <#point description#>
 *
 *  @return <#return value description#>
 */
-(UIColor *)colorAtPixel:(CGPoint)point;

//改变图片的颜色
- (UIImage *)changeImageColor:(UIColor *)color;
@end
