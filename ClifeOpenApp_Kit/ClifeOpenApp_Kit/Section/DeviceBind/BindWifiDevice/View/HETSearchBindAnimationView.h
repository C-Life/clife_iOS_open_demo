//
//  searchBindAnimationView.h
//  圆圈辐射动画
//
//  Created by hcc on 2016/11/7.
//  Copyright © 2016年 Hancc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HETSearchBindAnimationView : UIView
// 产品名称
@property(nonatomic,copy)   NSString *productName;
// 产品型号
@property(nonatomic,copy)   NSString *productCode;
// 进度
@property(nonatomic,copy)   NSString *progressStr;

// 搜索
-(void)startSearchProgressing;

// 暂停收缩
- (void)stopSearchProgressing;

// 绑定中
-(void)startBinding;
// 绑定成功
-(void)startBindsuccess;
// 隐藏
- (void)hiddeView;
@end
