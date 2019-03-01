//
//  UIColor+BNRAdditions.m
//  BNRSDKLib
//
//  Created by JustinYang on 8/24/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import "UIColor+BNRAdditions.h"

@implementation UIColor (BNRAdditions)
+(NSUInteger)getRGBValueWithColor:(UIColor *)color{
    NSUInteger hexColor = 0x00000000;
    CGColorRef colorRef = color.CGColor;
    int number = CGColorGetNumberOfComponents(colorRef);
    if (number > 3) {
        const float *rgba = CGColorGetComponents(colorRef);
        CGFloat r = rgba[0];
        CGFloat g = rgba[1];
        CGFloat b = rgba[2];
        CGFloat a = rgba[3];
        
        hexColor = (((unsigned char)(r*255+0.5))<<24)+
                    (((unsigned char)(g*255+0.5))<<16)+
                    (((unsigned char)(b*255+0.5))<<8)+
                    ((unsigned char)(a*255+0.5));
        
    }
    return hexColor;
    
}

+(NSString *)getHexStrFromUIColor: (UIColor*) color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"FFFFFF"];
    }
    const CGFloat *rgba = CGColorGetComponents(color.CGColor);
    return [NSString stringWithFormat:@"%02X%02X%02X", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;

    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString alpha:(CGFloat)colorAlpha {
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:colorAlpha];
    return result;
}

@end
