//
//  PJTabBarItem.h
//  Cooperation
//
//  Created by yangjuanping on 16/10/25.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseSubVcForMainTab;

typedef NS_ENUM(NSInteger, UnreadNumType){
    ENUM_UNREAD_TOTAL  =0,    // 显示未读条数
    ENUM_UNREAD_SPOT,         // 显示小红点
    ENUM_UNREAD_NONE,         // 不显示
};

@interface PJTabBarItem : NSObject
@property(nonatomic, assign)UnreadNumType       unreadType;
@property(nonatomic, strong)NSString            *strTitle;
@property(nonatomic, strong)NSString            *strNormalImg;
@property(nonatomic, strong)NSString            *strSelectImg;
@property(nonatomic, assign)NSInteger           tabIndex;
@property(nonatomic, retain)__kindof BaseSubVcForMainTab  *viewController;
@end
