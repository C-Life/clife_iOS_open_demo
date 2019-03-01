//
//  GradientColorView.m
//  GradientColor_demo
//
//  Created by Jerry on 14-11-1.
//  Copyright (c) 2014年 HeT.com. All rights reserved.
//

#import "GradientColorView.h"

@implementation GradientColorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withGradientColorArray:(NSMutableArray *)colorArray withGradientType:(GradientType)gradientType {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *backImage =[self backgroundImageFromColors:colorArray withGradientType:gradientType];
        [self setBackgroundColor:[UIColor colorWithPatternImage:backImage]];
    }
    return self;
}

- (UIImage *)backgroundImageFromColors:(NSArray *)colors withGradientType:(GradientType)gradientType {
    if (colors.count <= 0) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (UIColor *col in colors) {
        [array addObject:(id)col.CGColor];
    }
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)array, NULL);
    CGPoint startPoint;
    CGPoint endPoint;
    
    switch (gradientType) {
        case 0:
            startPoint = CGPointMake(0.0, 0.0);
            endPoint = CGPointMake(0.0, self.frame.size.height);
            break;
        case 1:
            startPoint = CGPointMake(0.0, 0.0);
            endPoint = CGPointMake(self.frame.size.width, 0.0);
            break;
        default:
            startPoint = CGPointMake(0.0, 0.0);
            endPoint = CGPointMake(0.0, self.frame.size.height);
            break;
    }
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,kCGGradientDrawsAfterEndLocation|kCGGradientDrawsBeforeStartLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
//    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

- (void)changeGradientColorArray:(NSMutableArray *)colorArray withGradientType:(GradientType)gradientType {
    UIImage *backImage =[self backgroundImageFromColors:colorArray withGradientType:gradientType];
    [self setBackgroundColor:[UIColor colorWithPatternImage:backImage]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
