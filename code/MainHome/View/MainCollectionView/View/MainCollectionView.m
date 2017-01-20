//
//  MainCollectionView.m
//  ControlTest
//
//  Created by yangjuanping on 16/3/9.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MainCollectionView.h"
#import "MainCollectionViewFlowLayout.h"
#import "MainCollectionCell.h"
#import "CollectionItem.h"

#define STARTTIME_DELAY 2
#define IMAGEVIEW_COUNT 3

@interface MainCollectionView () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
/**
 *  显示表情的collectView控件
 */
@property (nonatomic, weak) UICollectionView *emotionCollectionView;

/**
 *  显示页码的控件
 */


/**
 *  当前选择了哪类gif表情标识
 */
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong)UICollectionView* collection;
@property (nonatomic, assign)CGSize            cellSize;
@property (nonatomic, assign)BOOL              bResize;
@property (nonatomic, assign)UIEdgeInsets      edgeInsets;

@end

@implementation MainCollectionView



-(void)setcellSize:(CGSize)cellSize EdgeInsets:(UIEdgeInsets)edgeInsets ResizeHeight:(BOOL)bResize{
    _cellSize = cellSize;
    _edgeInsets = edgeInsets;
    _bResize = bResize;
    [self setHeight:(CGRectGetHeight(self.collection.frame))];
}

- (void)reloadData {
//    NSInteger numberOfEmotionManagers = [self.dataSource numberOfEmotionManagers];
//    if (!numberOfEmotionManagers) {
//        return ;
//    }
//    
//    self.selectedIndex=0;
    
    MainCollectionManager *emotionManager = [self.dataSource emotionManagerForView];
    NSInteger numberOfEmotions = emotionManager.emotions.count;
    NSInteger perRowNum = kXHEmotionPerRowItemCount;
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfPerRow)]) {
        perRowNum = [self.delegate numberOfPerRow];
    }
    self.emotionPageControl.numberOfPages = (numberOfEmotions / (perRowNum * 2) + (numberOfEmotions % (perRowNum * 2) ? 1 : 0));
    
    
    [self.emotionCollectionView reloadData];
}

-(UICollectionView*)emotionCollectionView{
    if (!_emotionCollectionView) {
        NSInteger perRowNum = kXHEmotionPerRowItemCount;
        if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfPerRow)]) {
            perRowNum = [self.delegate numberOfPerRow];
        }
        
        MainCollectionManager *emotionManager = [self.dataSource emotionManagerForView];
        NSInteger count = emotionManager.emotions.count;
        CGFloat fHeight = CGRectGetHeight(self.bounds) - kXHEmotionPageControlHeight - 3;
        if (count <= perRowNum) {
            fHeight = CGRectGetHeight(self.bounds)/2;
            [self setHeight:fHeight];
            fHeight -= 3;
        }
        
        UICollectionView *emotionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.bounds), fHeight) collectionViewLayout:[[MainCollectionViewFlowLayout alloc] initWithPerRowNum:perRowNum]];
        emotionCollectionView.backgroundColor = self.backgroundColor;
        [emotionCollectionView registerClass:[MainCollectionCell class] forCellWithReuseIdentifier:kXHEmotionCollectionViewCellIdentifier];
        emotionCollectionView.showsHorizontalScrollIndicator = NO;
        emotionCollectionView.showsVerticalScrollIndicator = NO;
        [emotionCollectionView setScrollsToTop:NO];
        emotionCollectionView.pagingEnabled = YES;
        emotionCollectionView.delegate = self;
        emotionCollectionView.dataSource = self;
        [self addSubview:emotionCollectionView];
        _emotionCollectionView = emotionCollectionView;
    }
    return _emotionCollectionView;
}

-(UIPageControl*)emotionPageControl{
    if (!_emotionPageControl) {
        UIPageControl *emotionPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionCollectionView.frame) + 3, CGRectGetWidth(self.bounds), kXHEmotionPageControlHeight)];
        emotionPageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.471 alpha:1.000];
        emotionPageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.678 alpha:1.000];
        emotionPageControl.backgroundColor = [UIColor clearColor];
        emotionPageControl.hidesForSinglePage = YES;
        emotionPageControl.defersCurrentPageDisplay = YES;
        [self addSubview:emotionPageControl];
        _emotionPageControl = emotionPageControl;
    }
    return _emotionPageControl;
}

-(NSInteger)changeIndex:(NSInteger)nRow Count:(NSInteger)count{
    //NSInteger count = emotionManager.emotions.count;
    NSInteger perRowNum = kXHEmotionPerRowItemCount;
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfPerRow)]) {
        perRowNum = [self.delegate numberOfPerRow];
    }
    
    if (count <= perRowNum) {
        return nRow;
    }
    
    NSInteger nPageIndex = nRow%(perRowNum*2);
    NSInteger nIndexShow = ((nPageIndex%2==0)?nPageIndex/2:(nPageIndex/2+4))+nRow/(perRowNum*2)*(perRowNum*2);
    return nIndexShow;
}

#pragma mark - Life cycle

- (void)setup {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
    self.isShowEmotionStoreButton = YES;
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.emotionPageControl = nil;
    self.emotionCollectionView.delegate = nil;
    self.emotionCollectionView.dataSource = nil;
    self.emotionCollectionView = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self reloadData];
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.emotionPageControl setCurrentPage:currentPage];
}

#pragma UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    MainCollectionManager *emotionManager = [self.dataSource emotionManagerForView];
    NSInteger count = emotionManager.emotions.count;
    //return count;
    
    NSInteger perRowNum = kXHEmotionPerRowItemCount;
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfPerRow)]) {
        perRowNum = [self.delegate numberOfPerRow];
    }
    
    if (count<=perRowNum) {
        return count;
    }
    
    // 凑齐每页图标数目的整数倍，不足的用空白cell代替
    if (count%(perRowNum*2)) {
        return (count/(perRowNum*2)+1)*(perRowNum*2);
    }
    else{
        return count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXHEmotionCollectionViewCellIdentifier forIndexPath:indexPath];
    MainCollectionManager *emotionManager = [self.dataSource emotionManagerForView];

    NSInteger count = emotionManager.emotions.count;
    NSInteger nIndexShow = [self changeIndex:indexPath.row Count:count];
    if (nIndexShow<count) {
        cell.type = self.type;
        cell.item = emotionManager.emotions[nIndexShow];
    }
    else{
        cell.item = nil;
    }
    return cell;
}

#pragma mark - UICollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCollectionManager *emotionManager = [self.dataSource emotionManagerForView];
    NSInteger count = emotionManager.emotions.count;
    NSInteger nIndexShow = [self changeIndex:indexPath.row Count:count];
    if (nIndexShow<count) {
        if ([self.delegate respondsToSelector:@selector(didSelecteEmotion:atIndexPath:)]) {
            MainCollectionManager *emotionManager = [self.dataSource emotionManagerForView];
            
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:nIndexShow inSection:indexPath.section];
            [self.delegate didSelecteEmotion:emotionManager.emotions[nIndexShow] atIndexPath:newIndexPath];
        }
    }
}

@end
