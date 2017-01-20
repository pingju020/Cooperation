//
//  MainItemCollectionFlowLayout.m
//  Cooperation
//
//  Created by yangjuanping on 16/11/24.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MainItemCollectionFlowLayout.h"

static CGFloat kxTitleHeight = 12;
@implementation MainItemCollectionFlowLayout

-(id)initWithPerRowNum:(NSInteger)perRowNum{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        // 每个item之间的间隔是item宽度的一半
        CGFloat spacing = [[UIScreen mainScreen] bounds].size.width/(perRowNum*3);
        CGFloat fItemViewSize = 2*spacing;
        self.itemSize = CGSizeMake(fItemViewSize, fItemViewSize+kxTitleHeight);
        self.minimumLineSpacing = spacing;
        self.sectionInset = UIEdgeInsetsMake(10, spacing/2, 0, spacing/2);
        self.collectionView.alwaysBounceVertical = YES;
    }
    return self;
}

@end
