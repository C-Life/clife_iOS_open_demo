//
//  UIButton+EnlargeEdge.h
//  CBeauty
//  扩大点击范围的类别
//  Created by qygxwy on 16/9/20.
//  Copyright © 2016年 wff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeEdge)

- (void)setEnlargeEdge:(CGFloat)size;///< 设置按钮扩大响应区域的范围

/**
 * @brief 详细设置按钮扩大响应区域的范围
 *
 * @param top         按钮上方扩展的范围
 * @param right       按钮右方扩展的范围
 * @param bottom      按钮下方扩展的范围
 * @param left        按钮左方扩展的范围
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top
                        right:(CGFloat)right
                       bottom:(CGFloat)bottom
                         left:(CGFloat)left;
@end
