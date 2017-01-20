//
//  InfoCollectionManager.m
//  anhui
//
//  Created by yangjuanping on 16/3/11.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "InfoCollectionManager.h"

@implementation InfoCollectionManager

-(id)init{
    if (self = [super init]) {
        self.infoItems = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)dealloc {
    [self.infoItems removeAllObjects];
    self.infoItems = nil;
    self.infoSectionTitle = nil;
    self.infoSectionRightBtnName = nil;
}

@end
