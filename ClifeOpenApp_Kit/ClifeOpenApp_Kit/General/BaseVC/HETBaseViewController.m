//
//  HETBaseViewController.m
//  ClifeOpenApp_Kit
//
//  Created by yuan yunlong on 2018/5/15.
//  Copyright © 2018年 het. All rights reserved.
//

#import "HETBaseViewController.h"

@interface HETBaseViewController ()

@end

@implementation HETBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = OPColor(@"efeff4");
    [self createNavViews];
}

- (void)createNavViews {
    // 1.添加设备按妞
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    OPLog(@"%@ dealloc！！！",[self class]);
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
