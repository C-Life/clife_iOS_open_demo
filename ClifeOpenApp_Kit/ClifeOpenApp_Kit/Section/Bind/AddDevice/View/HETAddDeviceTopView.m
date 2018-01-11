//
//  HETAddDeviceTopView.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/8/31.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETAddDeviceTopView.h"
#define BtnCount 1
#define BtnW 160 *BasicWidth
#define BtnH 114 *BasicHeight

@interface HETAddDeviceTopView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView                   *btnCollectionView;
@end

@implementation HETAddDeviceTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView
{
    UILabel *hotDevciceLabel = [UILabel new];
    hotDevciceLabel = [[UILabel alloc]init];
    hotDevciceLabel.backgroundColor = UIColorFromRGB(0xefeff4);
    hotDevciceLabel.textAlignment = NSTextAlignmentLeft;
    hotDevciceLabel.textColor = [UIColor colorFromHexRGB:@"5e5e5e"];
    hotDevciceLabel.text = DeviceBindWithType;
    hotDevciceLabel.font = [UIFont fontWithName:@"SourceHanSansCH-Regular" size:12];
    [self addSubview:hotDevciceLabel];
    [hotDevciceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16 *BasicWidth);
        make.right.bottom.equalTo(self);
        make.height.mas_equalTo(32 *BasicHeight);
    }];

    UIView *hotDevciceLabel_topLineView = [UIView new];
    hotDevciceLabel_topLineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [self addSubview:hotDevciceLabel_topLineView];
    [hotDevciceLabel_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hotDevciceLabel.mas_left);
        make.right.equalTo(hotDevciceLabel.mas_right);
        make.bottom.equalTo(hotDevciceLabel.mas_top);
        make.height.mas_equalTo(0.5 *BasicHeight);
    }];

    UIView *hotDevciceLabel_bottomLineView = [UIView new];
    hotDevciceLabel_bottomLineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [self addSubview:hotDevciceLabel_bottomLineView];
    [hotDevciceLabel_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(0.5 *BasicHeight);
    }];

    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(hotDevciceLabel_topLineView.mas_top);
    }];

    UIView *contentView_topLine = [[UIView alloc]init];
    [self addSubview:contentView_topLine];
    contentView_topLine.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [self addSubview:contentView_topLine];
    [contentView_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.bottom.equalTo(contentView.mas_top);
        make.height.mas_equalTo(0.5 *BasicHeight);
    }];

    [contentView addSubview:self.btnCollectionView];
    [self.btnCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView).insets(UIEdgeInsetsMake(0,0,0,0));
    }];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//定义展示的UICollectionViewCell的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArr.count;
}

//每个item展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"BTNCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    //先移除可重用cell里面的子元素(否则会出现新旧交叠)
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = YES;

    NSString *imageStr = self.imageArr[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageStr]];
    imageView.contentMode = UIViewContentModeCenter;
    [cell addSubview:imageView];
    imageView.frame = CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height);
    return cell;
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndex) {
        self.selectIndex(indexPath.row);
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat marginW;
    if (self.imageArr.count > 0) {
        marginW= (ScreenWidth- (self.imageArr.count*BtnW))/(self.imageArr.count +1);
    }else{
        marginW = (ScreenWidth- (BtnCount*BtnW))/(BtnCount +1);
    }
    return UIEdgeInsetsMake(0,marginW,0,marginW);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat marginW;
    if (self.imageArr.count > 0) {
        marginW= (ScreenWidth- (self.imageArr.count*BtnW))/(self.imageArr.count +1);
    }else{
        marginW = (ScreenWidth- (BtnCount*BtnW))/(BtnCount +1);
    }
    return marginW;
}

- (UICollectionView *)btnCollectionView
{
    if (!_btnCollectionView)
    {
        // 1.创建流水布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

        // 2.设置每个格子的尺寸
        layout.itemSize = CGSizeMake(BtnW,BtnH);

        // 4.设置滚动反向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _btnCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _btnCollectionView.backgroundColor = [UIColor whiteColor];
        _btnCollectionView.delegate = self;
        _btnCollectionView.dataSource = self;
        //注册Cell，必须要有
        [_btnCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"BTNCell"];
    }
    return _btnCollectionView;
}

- (void)dealloc
{
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
