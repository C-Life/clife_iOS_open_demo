//
//  UIViewController+BNRAdditions.m
//  CLife
//
//  Created by JiangJun on 15/6/6.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import "UIViewController+BNRAdditions.h"

@implementation UIViewController (BNRAdditions)
- (void)transparentNavigationBar {
    // 设置导航栏透明，但按钮正常可见。
    [self.navigationController.navigationBar setTranslucent: YES];
    [self.navigationController.navigationBar setShadowImage: [UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage: [UIImage new]
                                                  forBarMetrics: UIBarMetricsDefault];
    
    // 导航栏文本属性，颜色，字体等
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName: [UIColor whiteColor],
       NSFontAttributeName: [UIFont systemFontOfSize:18],
       }
     ];

}

- (void)opaqueNavigationBar {
    // 去掉导航栏透明特性
    [self.navigationController.navigationBar setTranslucent: NO];
    [self.navigationController.navigationBar setShadowImage: nil];
    [self.navigationController.navigationBar setBackgroundImage: nil
                                                  forBarMetrics: UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName: [UIColor whiteColor],
       NSFontAttributeName: [UIFont systemFontOfSize:18],
       }
     ];
}

@end
