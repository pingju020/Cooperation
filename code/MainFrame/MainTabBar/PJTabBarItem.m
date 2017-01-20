//
//  PJTabBarItem.m
//  Cooperation
//
//  Created by yangjuanping on 16/10/25.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "PJTabBarItem.h"

@implementation PJTabBarItem
-(id)init{
    if ([super init]) {
        _unreadType = ENUM_UNREAD_NONE;
        _strTitle = @"";
        _strNormalImg = @"";
        _strSelectImg = @"";
        _viewController = nil;
    }
    return self;
}
@end
