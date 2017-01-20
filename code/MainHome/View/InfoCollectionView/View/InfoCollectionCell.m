//
//  InfoCollectionCell.m
//  anhui
//
//  Created by yangjuanping on 16/1/13.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "InfoCollectionCell.h"


@interface InfoCollectionCell()
@property (nonatomic, strong) UIImageView *appIcon;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) UILabel *appAddLabel;
@property (nonatomic, assign) CGFloat fIconHeight;
@end

@implementation InfoCollectionCell

-(void)CreateMainCollectionCell:(NSString*)icon Name:(NSString*)name add:(NSString*)add{
//    [self.appIcon setImageForAllSDK:[NSURL URLWithString:icon] withDefaultImage:[UIImage imageNamed:@"app_one.jpg"] WithAdjustType:NO];
    [self.appNameLabel setText:name];
    [self.appAddLabel setText:add];
    [self setHeight:CGRectGetMaxY(self.appAddLabel.frame)];
}

-(void)CreateInfoCollectionCell:(InfoItem*)item{
//    [self.appIcon setImageForAllSDK:[NSURL URLWithString:item.iconUrl] withDefaultImage:[UIImage imageNamed:item.iconName] WithAdjustType:NO];
    [self.appNameLabel setText:item.itemTitle];
    [self.appAddLabel setText:item.itemDesc];
    [self setHeight:CGRectGetMaxY(self.appAddLabel.frame)];
}

-(UIImageView *)appIcon{
    if (_appIcon == nil) {
        CGFloat contentH = CGRectGetHeight(self.contentView.frame);
        CGFloat contentW = CGRectGetWidth(self.contentView.frame);
//        _appIcon = [[EGOImageView alloc]initWithFrame:CGRectMake(0, 0, contentW, contentH-2*LAB_HEIGHT)];
        [self.contentView addSubview:_appIcon];
    }
    return _appIcon;
}

-(UILabel*)appNameLabel{
    if (_appNameLabel == nil) {
        _appNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.appIcon.frame), CGRectGetWidth(self.contentView.frame), LAB_HEIGHT)];
        [_appNameLabel setTextColor:[UIColor darkGrayColor]];
        [_appNameLabel setFont:[UIFont systemFontOfSize:12]];
        [_appNameLabel setTextAlignment:NSTextAlignmentLeft];
        //[_appNameLabel setBackgroundColor:[UIColor whiteColor]];
        //_appNameLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [self.contentView addSubview:_appNameLabel];
    }
    return _appNameLabel;
}

-(UILabel*)appAddLabel{
    if (_appAddLabel == nil) {
        _appAddLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.appNameLabel.frame), CGRectGetWidth(self.contentView.frame), LAB_HEIGHT)];
        [_appAddLabel setTextColor:[UIColor grayColor]];
        [_appAddLabel setFont:[UIFont systemFontOfSize:12]];
        [_appAddLabel setTextAlignment:NSTextAlignmentLeft];
        //[_appAddLabel setBackgroundColor:VcBackgroudColor];
        [self.contentView addSubview:_appAddLabel];
    }
    return _appAddLabel;
}

@end