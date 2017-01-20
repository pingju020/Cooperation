//
//  MainItemCollectionView.m
//  Cooperation
//
//  Created by yangjuanping on 16/11/22.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MainItemCollectionView.h"
#import "MainItemCollectionFlowLayout.h"
#import "MainItemCollectionCell.h"
#import "MainItemCollectionManager.h"
#import <UIKit/UIKit.h>

static NSInteger kNumPerRow;
static NSString* kCollectionViewCellIdentifier = @"MainItemCollectionViewCell";

static CGFloat kTitleHeight = 30;
static CGFloat kItemVSpace = 10;
static CGFloat kPageHeight = 10;

@interface MainItemCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, weak) UICollectionView *collection;
/**
 *  显示页码的控件
 */
@property (nonatomic, weak) UIPageControl *pageControl;
@end


@implementation MainItemCollectionView

AH_MAINHOME_ITEMVIEW
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)init{
    if (self = [super init]) {
        if (deviceType >= iPhone6Plus) {
            kNumPerRow = 5;
        }
        else{
            kNumPerRow = 4;
        }
        
        
        if (role == E_ROLE_PARENT) {
            ;
        }
       [self addSubview:self.collection];
//        [self.collection setBackgroundColor:[UIColor blueColor]];
//        [self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}

-(CGFloat)getItemHeight{
    NSInteger num = [[MainItemCollectionManager sharedInstance]numberOfItemsInMainItemCollectionView];
    MainItemCollectionFlowLayout* mainFlowLayout = [[MainItemCollectionFlowLayout alloc] initWithPerRowNum:kNumPerRow];
    CGFloat fHeight = mainFlowLayout.itemSize.height;
    
    // 计算collection的高度，如果是家长，要显示标题
    if (role == E_ROLE_PARENT) {
        fHeight += kTitleHeight;
    }
    
    // 如果item数目大于kNumPerRow*2，要显示翻页空间
    if (num > kNumPerRow*2) {
        fHeight += mainFlowLayout.itemSize.height + kItemVSpace + kPageHeight;
    }
    
    // 如果如果item数目小于kNumPerRow*2但是大于kNumPerRow，要空出item的的纵向间隔
    else if (num > kNumPerRow){
        fHeight += mainFlowLayout.itemSize.height + kItemVSpace;
    }
    
    return fHeight;
}
-(NSInteger)getItemIndex{
    return 1;
}

-(UICollectionView*)collection{
    if (!_collection) {
        NSInteger num = [[MainItemCollectionManager sharedInstance]numberOfItemsInMainItemCollectionView];
        MainItemCollectionFlowLayout* mainFlowLayout = [[MainItemCollectionFlowLayout alloc] initWithPerRowNum:kNumPerRow];
        CGFloat fHeight = mainFlowLayout.itemSize.height;
        CGFloat fTop = 0;
        
        // 计算collection的高度，如果是家长，要显示标题
        if (role == E_ROLE_PARENT) {
            fHeight += kTitleHeight;
            fTop+=kTitleHeight;
        }
        
        // 如果item数目大于kNumPerRow*2，要显示翻页空间
        if (num > kNumPerRow*2) {
            fHeight += mainFlowLayout.itemSize.height + kItemVSpace + kPageHeight;
        }
        
        // 如果如果item数目小于kNumPerRow*2但是大于kNumPerRow，要空出item的的纵向间隔
        else if (num > kNumPerRow){
            fHeight += mainFlowLayout.itemSize.height + kItemVSpace;
        }
        // 其他情况属于只有一行图标的高度
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,fTop, CGRectGetWidth(self.bounds), fHeight) collectionViewLayout:mainFlowLayout];
        collection.backgroundColor = self.backgroundColor;
        [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
        collection.showsHorizontalScrollIndicator = NO;
        collection.showsVerticalScrollIndicator = NO;
        [collection setScrollsToTop:NO];
        collection.pagingEnabled = YES;
        collection.delegate = self;
        collection.dataSource = self;
        //[self addSubview:collection];
        _collection = collection;
    }
    return _collection;
}

-(NSInteger)changeIndex:(NSInteger)nRow Count:(NSInteger)count{
    NSInteger perRowNum = kNumPerRow;
    if (count <= perRowNum) {
        return nRow;
    }
    
    NSInteger nRowNum = 2;
    NSInteger nPageIndex = nRow%(perRowNum*nRowNum);
    NSInteger nIndexShow = ((nPageIndex%nRowNum==0)?nPageIndex/nRowNum:(nPageIndex/nRowNum+perRowNum))+nRow/(perRowNum*nRowNum)*(perRowNum*nRowNum);
    return nIndexShow;
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.pageControl setCurrentPage:currentPage];
}

#pragma UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [[MainItemCollectionManager sharedInstance]numberOfItemsInMainItemCollectionView];
    //return count;
    
    if (count<=kNumPerRow) {
        return count;
    }
    
    // 凑齐每页图标数目的整数倍，不足的用空白cell代替
    if (count%(kNumPerRow*2)) {
        return (count/(kNumPerRow*2)+1)*(kNumPerRow*2);
    }
    else{
        return count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MainItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSInteger count = [[MainItemCollectionManager sharedInstance]numberOfItemsInMainItemCollectionView];
//    NSInteger count = emotionManager.emotions.count;
    NSInteger nIndexShow = [self changeIndex:indexPath.row Count:count];
    if (nIndexShow<count) {
        cell.item = [MainItemCollectionManager sharedInstance].arrMainItemList[nIndexShow];
    }
    else{
        cell.item = nil;
    }
    return cell;
}

#pragma mark - UICollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = [[MainItemCollectionManager sharedInstance]numberOfItemsInMainItemCollectionView];
    NSInteger nIndexShow = [self changeIndex:indexPath.row Count:count];
    if (nIndexShow<count) {
        MainCollectionIconItem* item = [MainItemCollectionManager sharedInstance].arrMainItemList[nIndexShow];
        
        UIViewController* parentVC = ((UINavigationController *)[[UIApplication sharedApplication] delegate].window.rootViewController).visibleViewController;
        
        [item.viewController ShowMainItemViewController:parentVC];
    }
}


@end
