//
//  MessageTypeCell.m
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/9/30.
//  Copyright © 2017年 het. All rights reserved.
//

#import "MessageTypeCell.h"

@interface MessageTypeCell ()
@property (nonatomic,strong) UIImageView                                       *messageTypeImageView;
@property (nonatomic,strong) UILabel                                           *messageTypeLabel;
@property (nonatomic,strong) UILabel                                           *contentLabel;
@property (nonatomic,strong) UILabel                                           *messageNumLabel;
@end

@implementation MessageTypeCell
+ (instancetype)initWithTableView:(UITableView *)tabbleView
{
    static NSString *ID = @"MessageTypeCell";
    MessageTypeCell *cell = [tabbleView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[MessageTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initSubviews];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self initSubviews];
    }
    return self;
}
- (void)initSubviews
{
    self.messageTypeImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.messageTypeImageView];
    [self.messageTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(56.f, 56.f));
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(12 *BasicWidth);
    }];

    self.messageNumLabel     = [[UILabel  alloc]init];
    [self.contentView addSubview:self.messageNumLabel];
    self.messageNumLabel.backgroundColor = [UIColor colorWithRed:255.f/255.f green:164.f/255.f blue:161.f/255.f alpha:1];
    self.messageNumLabel.layer.cornerRadius = 10.f;
    self.messageNumLabel.clipsToBounds = YES;
    self.messageNumLabel.textColor = [UIColor whiteColor];
    self.messageNumLabel.font = [UIFont systemFontOfSize:12];
    self.messageNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.messageNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.mas_right).offset(-12 *BasicWidth);
        make.centerY.equalTo(self);
    }];

    self.messageTypeLabel  = [[UILabel alloc]init];
    [self.contentView addSubview:self.messageTypeLabel];
    self.messageTypeLabel.textAlignment = NSTextAlignmentLeft;
    self.messageTypeLabel.textColor = [UIColor colorFromHexRGB:@"000000"] ;
    self.messageTypeLabel.font = [UIFont systemFontOfSize:17];

    [self.messageTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageTypeImageView.mas_right).offset(12 *BasicWidth);
        make.right.equalTo(self.messageNumLabel.mas_left).offset(-12 *BasicWidth);
        make.height.mas_equalTo(20.f);
        make.top.equalTo(self).offset(16.f);
    }];

    self.contentLabel     = [[UILabel  alloc]init];
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.textColor = [UIColor colorFromHexRGB:@"919191"];
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageTypeImageView.mas_right).offset(12 *BasicWidth);
        make.right.equalTo(self.messageNumLabel.mas_left).offset(-12 *BasicWidth);
        make.height.mas_equalTo(20.f);
        make.bottom.equalTo(self).offset(-16.f);
    }];
}

- (void)refreshData:(HETMessageTypeModel *)model;
{
    NSString *title =model.title;

    NSString *time =[self distanceWithUTC:model.createTime / 1000.f];
    NSString *labelText = [NSString stringWithFormat:@"%@   %@",title,time];

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labelText attributes:nil];
    [str addAttribute:NSForegroundColorAttributeName value:self.contentLabel.textColor range:[labelText rangeOfString:time]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[labelText rangeOfString:time]];

    self.messageTypeLabel.attributedText = str;
    self.contentLabel.text = model.theDescription;
    [self.messageTypeImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.messageNumLabel.text = [NSString stringWithFormat:@"%@",@(model.unreadCount)];
    self.messageNumLabel.hidden = 0 == model.unreadCount;
}

- (NSString *)distanceWithUTC:(NSTimeInterval)utc{
    NSDate *date = [NSDate date];

    NSTimeZone *zone = [NSTimeZone systemTimeZone];

    NSInteger interval = [zone secondsFromGMTForDate: date];


    NSTimeInterval nowTime = [date timeIntervalSince1970];
    NSTimeInterval intervalInSeconds = nowTime - utc - interval;


    NSTimeInterval intervalInMinutes = round(intervalInSeconds / 60.0f);

    if (intervalInMinutes >= 0 && intervalInMinutes <= 1) {
        return MessageTypeTimeJustNow;

    } else if (intervalInMinutes > 1 && intervalInMinutes < 60) {
        return [NSString stringWithFormat:@"%d%@",(int)intervalInMinutes,MessageTypeTimeMinuteBefore];

    } else if (intervalInMinutes > 60 && intervalInMinutes <= 2*60) {
        return [NSString stringWithFormat:@"1%@",(int)intervalInMinutes,MessageTypeTimeMinuteBefore];;

    } else if (intervalInMinutes > 2*60 && intervalInMinutes <= 24*60) {
        return [NSString stringWithFormat:@"%d%@",(int)(intervalInMinutes/60),MessageTypeTimeMinuteBefore];

    } else {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970: utc];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate: date];
        NSInteger year = [dateComponent year];
        NSInteger month = [dateComponent month];
        NSInteger day = [dateComponent day];

        NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d",(int)year,(int)month,(int)day];

        return dateStr;
    }
}
@end
