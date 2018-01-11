//
//  GradientColorView.h
//  GradientColor_demo
//
//  Created by Jerry on 14-11-1.
//  Copyright (c) 2014年 HeT.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GradientFromUpToDown,           // 从上到下
    GradientFromLeftToRight,        // 从左到右
    GradientFromLeftupToRightdown,  // 从左上到右下
    GradientFromRightupToLeftdown,  // 从右上到左下
}GradientType;

@interface GradientColorView : UIView

/**
 *  初始化
 *
 *  @param frame        frame
 *  @param colorArray   渐变颜色数组
 *  @param gradientType 渐变的类型
 *
 *  @return id
 */
- (id)initWithFrame:(CGRect)frame withGradientColorArray:(NSMutableArray *)colorArray withGradientType:(GradientType)gradientType;

- (void)changeGradientColorArray:(NSMutableArray *)colorArray withGradientType:(GradientType)gradientType;
@end
