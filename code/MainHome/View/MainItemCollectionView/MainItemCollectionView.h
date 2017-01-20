//
//  MainItemCollectionView.h
//  Cooperation
//
//  Created by yangjuanping on 16/11/22.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MainHomeItemView.h"

@class MainItemCollectionView;

@protocol MainItemCollectionViewDataSource <NSObject>

@required
/**
 *  通过数据源获取item数目
 *
 *  @param column 列数
 *
 *  @return 返回统一管理item数目
 */
-(NSInteger)numberOfItemsInMainItemCollectionView:(MainItemCollectionView*)MainItemCollectionView;

/**
 *  通过数据源获取一系列的统一管理表情的Model数组
 *
 *  @return 返回包含统一管理表情Model元素的数组
 */
//- (NSArray *)emotionManagersAtManager;

/**
 *  通过数据源获取总共有多少类gif表情
 *
 *  @return 返回总数
 */
//- (NSInteger)numberOfEmotionManagers;

@end

@interface MainItemCollectionView : MainHomeItemView
@property(nonatomic,assign) id<MainItemCollectionViewDataSource> dataSource;
@end
