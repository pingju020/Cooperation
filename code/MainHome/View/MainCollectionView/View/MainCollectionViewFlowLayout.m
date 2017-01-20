//
//  MainCollectionViewFlowLayout.m
//  ControlTest
//
//  Created by yangjuanping on 16/3/9.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MainCollectionViewFlowLayout.h"

@implementation MainCollectionViewFlowLayout
- (id)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = CGSizeMake(kXHEmotionImageViewSize, kXHEmotionImageViewSize+kxHEmotionTitleHeight);
        int count = kXHEmotionPerRowItemCount;
        CGFloat spacing = [[UIScreen mainScreen] bounds].size.width/count - kXHEmotionImageViewSize;
        self.minimumLineSpacing = spacing;
        self.sectionInset = UIEdgeInsetsMake(10, spacing/2, 0, spacing/2);
        self.collectionView.alwaysBounceVertical = YES;
    }
    return self;
}

-(id)initWithPerRowNum:(NSInteger)perRowNum{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = CGSizeMake(kXHEmotionImageViewSize, kXHEmotionImageViewSize+kxHEmotionTitleHeight);
        CGFloat spacing = [[UIScreen mainScreen] bounds].size.width/perRowNum - kXHEmotionImageViewSize;
        self.minimumLineSpacing = spacing;
        self.sectionInset = UIEdgeInsetsMake(10, spacing/2, 0, spacing/2);
        self.collectionView.alwaysBounceVertical = YES;
    }
    return self;
}

//-(CGSize)collectionViewContentSize
//{
//    CGFloat height=  ceil([[self collectionView]  numberOfItemsInSection:0]/5)*CGRectGetWidth([[UIScreen mainScreen] bounds])/2;
//    return  CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]), height);
//    
//}//返回contentsize的总大小
//
////自定义布局必须YES
//-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//
//{
//    return YES;
//}
//
//
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewLayoutAttributes *attributes =
//    
//    [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    
//    return attributes;
//}//返回每个cell的布局属性
//
//
//
//-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
//
//{
//    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//    
//    NSMutableArray* attributes = [NSMutableArray array];
//    
//    for (NSInteger i=0 ; i < [array count]; i++) {
//        
//        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        
//        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
//        
//    }
//    
//    return attributes;
//}//返回所有cell的布局属性
@end
