//
//  MainCollectionView.h
//  ControlTest
//
//  Created by yangjuanping on 16/3/9.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCollectionManager.h"
#import "CollectionItem.h"

#define kXHEmotionPageControlHeight 35

@protocol MainCollectionViewDelegate <NSObject>

@optional
/**
 *  通过代理设置每行排布cell的个数
 *
 *  @return 返回每行的cell数
 */
- (NSInteger)numberOfPerRow;

/**
 *  第三方gif表情被点击的回调事件
 *
 *  @param emotion   被点击的gif表情Model
 *  @param indexPath 被点击的位置
 */
- (void)didSelecteEmotion:(CollectionItem *)emotion atIndexPath:(NSIndexPath *)indexPath;

@end


@protocol MainCollectionViewDataSource <NSObject>

@required
/**
 *  通过数据源获取统一管理一类表情的回调方法
 *
 *  @param column 列数
 *
 *  @return 返回统一管理表情的Model对象
 */
- (MainCollectionManager *)emotionManagerForView;

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


@interface MainCollectionView : UIView

@property (nonatomic, weak) id <MainCollectionViewDelegate> delegate;

@property (nonatomic, weak) id <MainCollectionViewDataSource> dataSource;
/**
 *  显示页码的控件
 */
@property (nonatomic, weak) UIPageControl *emotionPageControl;
/**
 *  是否显示表情商店的按钮
 */
@property (nonatomic, assign) BOOL isShowEmotionStoreButton; // default is YES

/**
 *  标记(0是教师首页，1是合肥一中首页)
 */
@property (nonatomic, copy) NSString * type;

/**
 *  根据数据源刷新UI布局和数据
 */
- (void)reloadData;

-(void)setcellSize:(CGSize)cellSize EdgeInsets:(UIEdgeInsets)edgeInsets ResizeHeight:(BOOL)bResize;

@end
