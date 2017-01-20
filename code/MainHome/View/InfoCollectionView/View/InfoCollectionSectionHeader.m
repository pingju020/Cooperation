//
//  InfoCollectionSectionHeader.m
//  anhui
//
//  Created by yangjuanping on 16/3/11.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "InfoCollectionSectionHeader.h"
#import "InfoCollectionCell.h"

@interface InfoCollectionSectionHeader()
@property (nonatomic, strong)UILabel*          labTitle;
@property (nonatomic, strong)UIButton*         btnParam;
@end

@implementation InfoCollectionSectionHeader
-(UILabel*)labTitle{
    if (_labTitle == nil) {
        _labTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, MAIN_WIDTH-100, 20)];
        [_labTitle setTextColor:[UIColor darkGrayColor]];
        [_labTitle setTextAlignment:NSTextAlignmentLeft];
        [_labTitle setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_labTitle];
    }
    return _labTitle;
}

-(UIButton*)btnParam{
    if (_btnParam == nil) {
        _btnParam = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_labTitle.frame)+40, 10, MAIN_WIDTH-CGRectGetMaxX(_labTitle.frame)-46, 20)];
        [_btnParam setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _btnParam.titleLabel.font = [UIFont systemFontOfSize:12];
        [_btnParam.titleLabel setTextAlignment:NSTextAlignmentRight];
        UIImage* image = [UIImage imageNamed:@"cona_right.png"];
        [_btnParam setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
        [_btnParam setImageEdgeInsets:UIEdgeInsetsMake(0, _btnParam.titleLabel.bounds.size.width, 0, -_btnParam.titleLabel.bounds.size.width-3*image.size.width-25)];
        [_btnParam setImage:image forState:UIControlStateNormal];
        [_btnParam addTarget:self action:@selector(TouchRightBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnParam];
    }
    return _btnParam;
}

-(void)TouchRightBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectSectionRightBtnAtSection:)]) {
        [self.delegate didSelectSectionRightBtnAtSection:self.tag];
    }
}

-(void)setTitle:(NSString*)strTitle Param:(NSString*)strParam{
    [self.labTitle setText:strTitle];
    [self.btnParam setTitle:strParam forState:UIControlStateNormal];
}

@end
