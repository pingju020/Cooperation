//
//  MainCollectionCell.h
//  ControlTest
//
//  Created by yangjuanping on 16/3/9.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionItem.h"

#define kXHEmotionCollectionViewCellIdentifier @"XHEmotionCollectionViewCellIdentifier"

@interface MainCollectionCell : UICollectionViewCell
/**
 *  需要显示和配置的gif表情对象
 */
@property (nonatomic, strong) CollectionItem *item;
/**
 *  标记(0是教师首页，1是合肥一中首页)
 */
@property (nonatomic, copy) NSString * type;
@property (nonatomic, assign)NSInteger nIndex;

@end
