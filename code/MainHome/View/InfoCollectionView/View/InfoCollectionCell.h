//
//  InfoCollectionCell.h
//  anhui
//
//  Created by yangjuanping on 16/1/13.
//  Copyright © 2016年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoItem.h"

// 标题标签的高度
#define LAB_HEIGHT 20
#define SECTION_HEIGHT 30

#define IMG  @"topic_img"
#define NAME @"topic_title"
#define DESC @"time"
#define TEACHER @"teacher"
#define URL @"topic_id"
#define LIST @"LIST"
#define TITLE @"TITLE"
#define PARAM @"PARAM"
#define SUBCLASS @"SUBCLASS"
#define ICON @"ICON"

@interface InfoCollectionCell : UICollectionViewCell
-(void)CreateMainCollectionCell:(NSString*)icon Name:(NSString*)name add:(NSString*)add;
-(void)CreateInfoCollectionCell:(InfoItem*)item;
@end
