//
//  HETWaterView.m
//  动画
//
//  Created by hcc on 16/12/6.
//  Copyright © 2016年 hcc. All rights reserved.
//

#import "HETWaterView.h"

@implementation HETWaterView

- (void)drawRect:(CGRect)rect
{
    // 半径
    CGFloat rabius = 95;
    // 开始角
    CGFloat startAngle = 0;
    // 结束角
    CGFloat endAngle = 2*M_PI;
    // 中心点
    CGPoint point = self.centerPoint;  // 中心店我手动写的,你看看怎么弄合适 自己在搞一下
    


    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:rabius startAngle:startAngle endAngle:endAngle clockwise:YES];

    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path.CGPath;       // 添加路径 下面三个同理
    
    layer.strokeColor   = [self.bkcolor colorWithAlphaComponent:0.5].CGColor;
    layer.fillColor     = [self.bkcolor colorWithAlphaComponent:0.5].CGColor;
    
    [self.layer addSublayer:layer];
}

@end
