//
//  HETFeedbackOpinionVC.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/8/31.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETFeedbackVC.h"
#import "CL_PlaceholderTextView.h"
#define IOS8 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

@interface HETFeedbackVC ()<UITextFieldDelegate, UITextViewDelegate>

///主要滚动视图
@property (nonatomic,strong) UIScrollView *backGroundScrollView;
///意见反馈内容
@property (nonatomic,strong) CL_PlaceholderTextView *feedbackTextField;
///提交按钮
@property (nonatomic,strong) UIButton *submitBtn;
///imit限制字数
@property (nonatomic,strong) UIButton *limitLabel;

@end

@implementation HETFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:FeedbackStr];
    
    [self createSubView];
}

- (void)createSubView
{
    self.automaticallyAdjustsScrollViewInsets  = NO;
    
    [self.view addSubview:self.backGroundScrollView];
    [self.backGroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    [self.backGroundScrollView addSubview:self.feedbackTextField];
    
    [self.backGroundScrollView addSubview:self.limitLabel];
    [self.limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedbackTextField.mas_bottom);
        make.left.right.equalTo(self.feedbackTextField);
        make.height.mas_equalTo(29*BasicHeight);
    }];
    
    [self.backGroundScrollView addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.limitLabel.mas_bottom).offset(32.f*BasicHeight);
        make.height.mas_equalTo(44*BasicHeight);
        make.centerX.equalTo(self.backGroundScrollView);
        make.width.mas_equalTo(ScreenWidth - 32*BasicWidth);
    }];
}

#pragma mark - Event response
- (void)tapScrollView:(UITapGestureRecognizer *)sender{
    if ([self.feedbackTextField isFirstResponder]) {
        [self.feedbackTextField resignFirstResponder];
    }
}

- (void)submitUserFeedbackOpinion{
    [self.feedbackTextField resignFirstResponder];
    
    if(self.feedbackTextField.text.length == 0)
    {
        [HETCommonHelp showHudAutoHidenWithMessage:FeedBackAlertContent];
        return;
    }
    
    [HETCommonHelp showMessage:FeedBackAlertIsUpLoading toView:self.view];
    NSDictionary *params = @{@"content":self.feedbackTextField.text,@"contact":@""};
    WEAKSELF
    [HETDeviceRequestBusiness startRequestWithHTTPMethod:HETRequestMethodPost withRequestUrl:FeedbackUrl processParams:params needSign:NO BlockWithSuccess:^(id responseObject) {
        [HETCommonHelp hideHudFromView:weakSelf.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HETCommonHelp showHudAutoHidenWithMessage:@"提交成功，谢谢您的反馈"];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController  popViewControllerAnimated: YES];
        });
    } failure:^(NSError *error) {
        [HETCommonHelp hideHudFromView:weakSelf.view];
        [HETCommonHelp showHudAutoHidenWithMessage:@"提交失败，请检测网络连接"];
    }];
}

#pragma mark - UITextFieldDelegate、UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.backGroundScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 60);
    self.backGroundScrollView.contentOffset = CGPointMake(0, 0);
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.backGroundScrollView.contentSize = CGSizeMake(0, 0);
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum >=300)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:300];
        
        [textView setText:s];
        
        existTextNum = s.length;
    }
    
    //不让显示负数 口口日
    [self.limitLabel setTitle:[NSString stringWithFormat:@"%ld/%d",existTextNum,300] forState:UIControlStateNormal];
}

// 计算剩余可输入字数 超出最大可输入字数，就禁止输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < 300) {
            return YES;
        }else{
            return NO;
        }
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = 300 - comcatstr.length;
    if (caninputlen >= 0){
        return YES;
    }else{
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0, MAX(len, 0)};
        if (rg.length > 0){
            
            self.feedbackTextField.text = [NSString stringWithFormat:@"%d/%d",0,300];
        }
        return NO;
    }
}

#pragma mark - getters and setters
// 此处第三方的CL_PlaceholderTextView必须使用硬编码
- (CL_PlaceholderTextView *)feedbackTextField{
    if (!_feedbackTextField) {
        _feedbackTextField=[[CL_PlaceholderTextView alloc] initWithFrame:CGRectMake(0,16,ScreenWidth,150 - 29 *BasicHeight)];
        _feedbackTextField.layoutMargins = UIEdgeInsetsMake(0,0,16,0);
        _feedbackTextField.textContainerInset = UIEdgeInsetsMake(10,16,16,16);
        _feedbackTextField.placeholder= FeedBackAlertContent;
        _feedbackTextField.delegate = self;
        _feedbackTextField.placeholderFont=[UIFont systemFontOfSize:15];
        _feedbackTextField.font=[UIFont systemFontOfSize:15];
        
        [_feedbackTextField addMaxTextLengthWithMaxLength:300 andEvent:^(CL_PlaceholderTextView *m) {
            
        }];
    }
    return _feedbackTextField;
}

- (UIButton *)limitLabel{
    if (!_limitLabel) {
        _limitLabel = [[UIButton alloc] init];
        [_limitLabel setBackgroundColor:[UIColor whiteColor]];
        _limitLabel.titleLabel.font=[UIFont systemFontOfSize:13];
        [_limitLabel setTitle:@"0/300" forState:UIControlStateNormal];;
        _limitLabel.contentHorizontalAlignment = NSTextAlignmentRight;
        _limitLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 16*BasicHeight, 16*BasicHeight);
        [_limitLabel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    return _limitLabel;
}

- (UIScrollView *)backGroundScrollView{
    if (!_backGroundScrollView) {
        _backGroundScrollView = [[UIScrollView alloc] init];
        _backGroundScrollView.bounces = NO;
        [_backGroundScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(tapScrollView:)]];
    }
    return _backGroundScrollView;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_submitBtn setTitle:FeedBackSubmitBtn forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = NavBarColor;
        _submitBtn.layer.cornerRadius = 5;
        _submitBtn.titleLabel.font = OPFont(14);
        _submitBtn.clipsToBounds = YES;
        [_submitBtn addTarget:self action:@selector(submitUserFeedbackOpinion) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
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
