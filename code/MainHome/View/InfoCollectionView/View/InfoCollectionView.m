//
//  InfoCollectionView.m
//  anhui
//
//  Created by yangjuanping on 16/1/13.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "InfoCollectionView.h"
#import "InfoCollectionCell.h"
#import "InfoCollectionSectionHeader.h"

#define ICON_HEIGHT_SCAL 0.66
#define CELL_SPACING     10

@interface InfoCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource,InfoCollectionSectionHeaderDelegate>
//@property (nonatomic, strong)UILabel*          labTitle;
//@property (nonatomic, strong)UIButton*         btnParam;
@property (nonatomic, strong)UICollectionView* collection;
//@property (nonatomic, strong)NSArray*          arrItems;
@property (nonatomic, assign)CGSize            cellSize;
@property (nonatomic, assign)CGFloat           fViewHeight;
@end

@implementation InfoCollectionView

- (void)reloadData {
    
    CGFloat cellWidth = (MAIN_WIDTH-CELL_SPACING*3)/2;
    _cellSize = CGSizeMake(cellWidth, cellWidth*ICON_HEIGHT_SCAL);
    
    NSInteger nSections = 1;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInInfoCollectionView:)]) {
        nSections = [self.dataSource numberOfSectionsInInfoCollectionView:self];
    }
    for (NSInteger nIndex = 0; nIndex < nSections; nIndex++) {
        NSInteger nNum = [self.dataSource infoCollectionView:self numberOfItemsInSection:nIndex];
        _fViewHeight = (nNum/2+nNum%2)*(_cellSize.height+LAB_HEIGHT*2);
    }
    
    [self.collection setHeight:_fViewHeight];
    [self setHeight:_fViewHeight+10];
    NSLog(@"_fViewHeight = %f", _fViewHeight);
    [self.collection reloadData];
}

-(id)initWithFrame:(CGRect)frame withDataSource:(NSArray*)arrItems withTitle:(NSString*)strTitle withBtnName:(NSString*)strBtnName{
    if (self == [super initWithFrame:frame]) {
//        _arrItems = arrItems;
        [self setBackgroundColor:[UIColor whiteColor]];
        //[self setHeight:(CGRectGetHeight(self.collection.frame))];
    }
    return self;
}
-(CGFloat)getInfoCollectionViewHeight{
    return _fViewHeight+10;
}

-(UICollectionView*)collection{
    if (_collection == nil) {
        
        //_collection每行排布2个cell，每个cell之间以及第一个cell左侧，最后一个cell右侧空出来的区域为20
//        CGFloat cellWidth = (MAIN_WIDTH-CELL_SPACING*3)/2;
//        _cellSize = CGSizeMake(cellWidth, cellWidth*ICON_HEIGHT_SCAL);
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.headerReferenceSize = CGSizeMake(MAIN_WIDTH, SECTION_HEIGHT);
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, _fViewHeight) collectionViewLayout:flowLayout];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.bounces = NO;
        _collection.pagingEnabled = YES;
        _collection.showsHorizontalScrollIndicator = NO;
        _collection.showsVerticalScrollIndicator = NO;
        _collection.delaysContentTouches = NO;
        _collection.canCancelContentTouches = YES;
        _collection.scrollEnabled = NO;
        [_collection registerClass:[InfoCollectionCell class] forCellWithReuseIdentifier:@"InfoCollectionCell"];
        [_collection registerClass:[InfoCollectionSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [self addSubview:_collection];
    }
    return _collection;
}

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInInfoCollectionView:)]) {
        return [self.dataSource numberOfSectionsInInfoCollectionView:self];
    }
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSource infoCollectionView:self numberOfItemsInSection:section];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return _cellSize;
}

/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(CELL_SPACING, CELL_SPACING, CELL_SPACING, CELL_SPACING);//上 左 下 右
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCellID = @"InfoCollectionCell";
    InfoCollectionCell *cell = (InfoCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    InfoCollectionManager* manager = [self.dataSource managerForInfoCollectionView:self atSection:indexPath.section];
    [cell CreateInfoCollectionCell:[manager.infoItems objectAtIndex:indexPath.row]];
    return cell;
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath = %@",indexPath);
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(infoCollectionView:didSelectInfoItem:AtIndexPath:)])
    {
        [self.delegate infoCollectionView:self didSelectInfoItem:nil AtIndexPath:indexPath];
    }
}
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        InfoCollectionSectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        InfoCollectionManager* manager = [self.dataSource managerForInfoCollectionView:self atSection:indexPath.section];
        [headerView setTitle:manager.infoSectionTitle Param:manager.infoSectionRightBtnName];
        headerView.tag = indexPath.section;
        headerView.delegate = self;
        reusableview = headerView;
    }
    return reusableview;
}

#pragma mark -- InfoCollectionSectionHeaderDelegate
-(void)didSelectSectionRightBtnAtSection:(NSInteger)section{
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoCollectionView: didSelectSectionRightBtnAtSection:)]) {
        [self.delegate infoCollectionView:self didSelectSectionRightBtnAtSection:section];
    }
}
@end