//
//  MainItemCollectionCell.m
//  Cooperation
//
//  Created by yangjuanping on 16/11/28.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MainItemCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface MainItemCollectionCell()
@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel*     title;
@property(nonatomic,strong)UIView *viewRedDot;
@property(nonatomic,strong)MainCollectionIconItem* item;
@end

@implementation MainItemCollectionCell
#pragma setter method

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        [self.contentView addSubview:_icon];
        
        _viewRedDot = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-6, 0, 6, 6)];
        _viewRedDot.layer.cornerRadius = 3;
        _viewRedDot.layer.masksToBounds = YES;
        _viewRedDot.backgroundColor = [UIColor redColor];
        [_icon addSubview:_viewRedDot];
        _viewRedDot.hidden = YES;
        
        _title = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.width, frame.size.width, frame.size.height-frame.size.width)];
        [_title setNumberOfLines:1];
        [_title setTextColor:[UIColor darkGrayColor]];
        [_title setFont:[UIFont systemFontOfSize:12]];
        [_title setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_title];
    }
    return self;
}

- (void)setItem:(MainCollectionIconItem *)item {
    _item = item;
    if (item) {
        if (IsStrEmpty(item.iconUrl)) {
            [self.icon setImage:[UIImage imageNamed:item.icon]];
        }
        else{
            [self.icon sd_setImageWithURL:[NSURL URLWithString:item.iconUrl] placeholderImage:[UIImage imageNamed:item.icon]];
        }
        [self.title setText:item.title];
    }
    else{
        self.icon.image = nil;
        self.title.text = nil;
    }
//    if (item) {
//        if (item.bHasNewMsg) {
//            self.viewRedDot.hidden = NO;
//        }
//        else{
//            self.viewRedDot.hidden = YES;
//        }
//        
//        if ([self.type isEqualToString:@"0"]) {
//            self.emotionImageView.image = [UIImage imageNamed:item.iconName];
//        } else {
//            // 接口逻辑
//            NSString * filePath = [[NSBundle mainBundle]pathForResource:@"hfyzSettings" ofType:@"plist"];
//            NSMutableDictionary * data = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
//            NSArray * keyArray = data.allKeys;
//            for (NSUInteger i = 0; i < keyArray.count; i++) {
//                NSString * temp = [keyArray objectAtIndex:i];
//                if (!IsStrEmpty(item.iconName)) {
//                    if ([item.iconName isEqualToString:temp]) {
//                        self.emotionImageView.image = [UIImage imageNamed:[data objectForKey:item.iconName]];
//                    } else {
//                        continue;
//                    }
//                } else {
//                    continue;
//                }
//            }
//            //            //假数据
//            //        self.emotionImageView.image = [UIImage imageNamed:item.iconName];
//        }
//        self.labTitle.text = item.itemTitle;
//    }
//    else{
//        self.emotionImageView.image = nil;
//        self.labTitle.text = nil;
//    }
}

#pragma mark - Life cycle
- (void)dealloc {
    //self.item = nil;
}
@end
