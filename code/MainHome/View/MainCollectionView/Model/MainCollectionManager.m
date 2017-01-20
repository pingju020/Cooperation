//
//  MainCollectionManager.m
//  ControlTest
//
//  Created by yangjuanping on 16/3/9.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MainCollectionManager.h"

@implementation MainCollectionManager

- (void)dealloc {
    [self.emotions removeAllObjects];
    self.emotions = nil;
}

@end
