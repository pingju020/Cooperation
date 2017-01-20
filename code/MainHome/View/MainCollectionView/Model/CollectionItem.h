//
//  CollectionItem.h
//  ControlTest
//
//  Created by yangjuanping on 16/3/9.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kXHEmotionPerRowItemCount 2
#define kXHEmotionImageViewSize 60
#define kxHEmotionTitleHeight 12
#define kXHEmotionMinimumLineSpacing 12

@interface CollectionItem : NSObject

/**
 *  本地图标
 */
@property (nonatomic, copy) NSString *iconName;

/**
 *  远程图标
 */
@property(nonatomic,copy)NSString* iconUrl;

/**
 *  cell title
 */
@property (nonatomic, copy) NSString *itemTitle;

/**
 *  cell id
 */
@property (nonatomic, copy)NSString * iconID;

/**
 *
 **/
@property (nonatomic, assign)BOOL bHasNewMsg;
@end
