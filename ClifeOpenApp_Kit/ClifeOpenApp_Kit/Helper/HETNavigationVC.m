//
//  HETNavigationVC.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/9/13.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETNavigationVC.h"

@interface HETNavigationVC ()<UINavigationControllerDelegate>
@property (nonatomic, weak) id PopDelegate;

@end

@implementation HETNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.PopDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.PopDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
