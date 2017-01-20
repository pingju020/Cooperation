//
//  CollectionItem.m
//  ControlTest
//
//  Created by yangjuanping on 16/3/9.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "CollectionItem.h"

@implementation CollectionItem

-(id)init{
    if (self = [super init]) {
        self.iconID = @"";
        self.iconName = @"";
        self.iconUrl = @"";
        self.itemTitle = @"";
        self.bHasNewMsg = NO;
    }
    return self;
}

- (void)dealloc {
    self.iconID = nil;
    self.iconName = nil;
    self.iconUrl = nil;
    self.itemTitle = nil;
}
@end
