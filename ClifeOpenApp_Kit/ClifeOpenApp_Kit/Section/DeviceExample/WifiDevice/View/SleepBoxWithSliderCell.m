//
//  SleepBoxWithSliderCell.m
//  SmartBed
//
//  Created by Sandy wu on 14-9-1.
//  Copyright (c) 2014年 Het. All rights reserved.
//

#import "SleepBoxWithSliderCell.h"

@implementation SleepBoxWithSliderCell
@synthesize titleLabel,imageView1,imageView2,slider, tipsLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 10, 60, 15)];
        titleLabel.text=@"亮度";
        titleLabel.textColor=[UIColor colorFromHexRGB:@"999999"];
        titleLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:titleLabel];
        
        tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 10, 200, 15)];
        tipsLabel.textColor=[UIColor colorFromHexRGB:@"1abc9c"];
        tipsLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:tipsLabel];
        
        imageView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dlight"]];
        imageView1.frame=CGRectMake(40, 37, imageView1.image.size.width, imageView1.image.size.height);
        [self.contentView addSubview:imageView1];
        
        //slider=[[UISlider alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds)-imageView1.image.size.width*2-60, 20)];
        slider=[[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame)+10, 37, ScreenWidth - (CGRectGetMaxX(imageView1.frame)+10)*2, 20)];
        //slider.center=CGPointMake(CGRectGetWidth(self.bounds)/2.0f+15, CGRectGetMidY(imageView1.frame)+5);
        slider.minimumTrackTintColor=[UIColor colorFromHexRGB:@"ffa92d"];
        slider.maximumTrackTintColor=[UIColor colorFromHexRGB:@"595959"];
        [self.contentView addSubview:slider];
        
        imageView2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_glight"]];
        imageView2.frame=CGRectMake(CGRectGetMaxX(slider.frame)+5, 37, imageView2.image.size.width, imageView2.image.size.height);
        [self.contentView addSubview:imageView2];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
