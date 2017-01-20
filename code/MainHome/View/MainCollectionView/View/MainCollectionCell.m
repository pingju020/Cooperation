//
//  MainCollectionCell.m
//  ControlTest
//
//  Created by yangjuanping on 16/3/9.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MainCollectionCell.h"

@interface MainCollectionCell ()

/**
 *  显示表情封面的控件
 */
@property (nonatomic, weak) UIImageView *emotionImageView;



/**
 *  显示名称的控件
 */
@property (nonatomic, weak) UILabel *labTitle;

/**
 * 显示新消息提醒的小红点
 **/
@property (nonatomic, weak) UIView *viewRedDot;

/**
 *  配置默认控件和参数
 */
- (void)setup;
@end

@implementation MainCollectionCell

#pragma setter method

- (void)setItem:(CollectionItem *)item {
    _item = item;
    if (item) {
        if (item.bHasNewMsg) {
            self.viewRedDot.hidden = NO;
        }
        else{
            self.viewRedDot.hidden = YES;
        }
        
        if ([self.type isEqualToString:@"0"]) {
            self.emotionImageView.image = [UIImage imageNamed:item.iconName];
        } else {
            // 接口逻辑
            NSString * filePath = [[NSBundle mainBundle]pathForResource:@"hfyzSettings" ofType:@"plist"];
            NSMutableDictionary * data = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
            NSArray * keyArray = data.allKeys;
            for (NSUInteger i = 0; i < keyArray.count; i++) {
                NSString * temp = [keyArray objectAtIndex:i];
                if (!IsStrEmpty(item.iconName)) {
                    if ([item.iconName isEqualToString:temp]) {
                        self.emotionImageView.image = [UIImage imageNamed:[data objectForKey:item.iconName]];
                    } else {
                        continue;
                    }
                } else {
                    continue;
                }
            }
            //            //假数据
            //        self.emotionImageView.image = [UIImage imageNamed:item.iconName];
        }
        self.labTitle.text = item.itemTitle;
    }
    else{
        self.emotionImageView.image = nil;
        self.labTitle.text = nil;
    }
}

#pragma mark - Life cycle

- (void)setup {
    if (!_emotionImageView) {
        UIImageView *emotionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -3, kXHEmotionImageViewSize, kXHEmotionImageViewSize)];
        //emotionImageView.backgroundColor = [UIColor colorWithRed:0.000 green:0.251 blue:0.502 alpha:1.000];
        [self.contentView addSubview:emotionImageView];
        self.emotionImageView = emotionImageView;
    }
    
    if (!_labTitle) {
        UILabel *labTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, kXHEmotionImageViewSize, kXHEmotionImageViewSize, kxHEmotionTitleHeight)];
        [labTitle setNumberOfLines:1];
        [labTitle setTextColor:[UIColor darkGrayColor]];
        [labTitle setFont:[UIFont systemFontOfSize:12]];
        [labTitle setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:labTitle];
        self.labTitle = labTitle;
    }
    
    // 新消息提醒的小红点
    if (!_viewRedDot) {
        UIView *viewRedDot = [[UIView alloc]initWithFrame:CGRectMake(kXHEmotionImageViewSize-6, 0, 6, 6)];
        viewRedDot.layer.cornerRadius = 3;
        viewRedDot.layer.masksToBounds = YES;
        viewRedDot.backgroundColor = [UIColor redColor];
        [self.emotionImageView addSubview:viewRedDot];
        viewRedDot.hidden = YES;
        self.viewRedDot = viewRedDot;
    }
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.item = nil;
}

@end
