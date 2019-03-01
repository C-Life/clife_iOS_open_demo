//
//  HETAPPIntrodutionVC.m
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2018/7/25.
//  Copyright © 2018年 het. All rights reserved.
//

#import "HETAPPIntrodutionVC.h"
#define kSafeAreaTop            ((ScreenHeight>736)?88:64)
@interface HETAPPIntrodutionVC ()

@property (nonatomic,strong) UITextView *textView;

@end

@implementation HETAPPIntrodutionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"功能介绍";
    [self createSubView];
}

- (void)createSubView
{
    [self.view addSubview:self.textView];
    NSString *string = @"\tC-Life开放平台（以下简称开放平台）设备接入的SDK封装了C-Life对外开放的服务接口，以及手机与智能硬件通讯接口。包括用户模块，设备绑定模块，设备控制模块和其他的开放平台接口。开发者不需要关注这些模块的具体内部逻辑，只需要根据自己的业务需求编写界面和调用SDK接口就可以完成APP的快速开发。\n\t地址：[ 公司总部 ]深圳市南山区科技南十路6号深圳航天科技创新研究院10楼。\n\t电话：0755-26727188\n\t QQ：    2596642389";
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 7;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName:[paragraph copy],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    self.textView.attributedText = attributedString;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0,64, ScreenWidth, ScreenHeight- kSafeAreaTop)];
        _textView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
        _textView.editable = NO;
        _textView.selectable = NO;
        _textView.showsHorizontalScrollIndicator = NO;
    }
    return _textView;
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
