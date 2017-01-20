//
//  JoinClassButton.m
//  anhui
//
//  Created by 葛君语 on 2016/10/20.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "JoinClassButton.h"
#import "FontSizeUtil.h"

@interface JoinClassButton ()
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UIView *sepLine;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *tipLabel;

@end

@implementation JoinClassButton

#pragma mark -赋值
- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    self.icon.image = [UIImage imageNamed:imageName];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setTip:(NSString *)tip
{
    _tip = tip;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tip];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, tip.length)];
    self.tipLabel.attributedText = attributedString;
    [self.tipLabel sizeToFit];
    
    CGSize size = [FontSizeUtil sizeOfString:tip withFont:_tipLabel.font withWidth:_tipLabel.width];
    
    _tipLabel.height = size.height + 10;
    
    _tipLabel.centerY = (self.height - _titleLabel.bottom-15)/2+_titleLabel.bottom;
}

#pragma mark -init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        
    }
    return self;
}

- (UIImageView *)icon
{
    if (!_icon) {
        CGFloat w = 40;
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, (self.height-w)/2, w, w)];
        [self addSubview:_icon];
    }
    return _icon;
}

- (UIView *)sepLine
{
    if (!_sepLine) {
        _sepLine = [[UIView alloc]initWithFrame:CGRectMake(self.icon.right+15, 15, 0.5, self.height-30)];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#E1E0E1"];
        [self addSubview:_sepLine];
    }
    return _sepLine;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.sepLine.right+15, 10, 150, 20)];
        _titleLabel.font = ([UIScreen mainScreen].bounds.size.height >= 736) ? [UIFont systemFontOfSize:16]:[UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom+5, self.width-self.titleLabel.left-8, 20)];
        _tipLabel.font = ([UIScreen mainScreen].bounds.size.height >= 736) ? [UIFont systemFontOfSize:14]:[UIFont systemFontOfSize:12];
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.numberOfLines = 2;
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

@end
