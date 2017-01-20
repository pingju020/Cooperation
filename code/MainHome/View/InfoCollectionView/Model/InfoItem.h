//
//  InfoItem.h
//  anhui
//
//  Created by yangjuanping on 16/3/11.
//  Copyright © 2016年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoItem : NSObject

/**
 *  本地图标
 */
@property (nonatomic, copy) NSString *iconName;

/**
 *  远程图标
 */
@property(nonatomic,copy)NSString *iconUrl;

/**
 *  cell title
 */
@property (nonatomic, copy) NSString *itemTitle;

/**
 *  cell description
 */
@property (nonatomic, copy) NSString *itemDesc;

/**
 *
 */
@property (nonatomic, copy) NSString *itemId;
@end
