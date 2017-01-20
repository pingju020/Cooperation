//
//  InfoCollectionView.h
//  anhui
//
//  Created by yangjuanping on 16/1/13.
//  Copyright © 2016年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoCollectionManager.h"
#import "InfoCollectionCell.h"

@class InfoCollectionView;
@protocol InfoCollectionViewDelegate <NSObject>

/**
 *  点击了某个item后的操作
 *
 *  @param infoCollectionView   被点击的view
 *  @param item  被点击的item
 *  @param indexPath 被点击的位置
 */
- (void)infoCollectionView:(InfoCollectionView *)infoCollectionView didSelectInfoItem:(InfoItem*)item AtIndexPath:(NSIndexPath *)indexPath;

/**
 *  点击了某个section的右侧按钮后的操作
 *
 *  @param infoCollectionView   被点击的view
 *  @param section 被点击的位置
 */

-(void)infoCollectionView:(InfoCollectionView*)infoCollectionView didSelectSectionRightBtnAtSection:(NSInteger)section;
///**
// *  第三方gif表情被点击的回调事件
// *
// *  @param emotion   被点击的gif表情Model
// *  @param indexPath 被点击的位置
// */
//- (void)didSelecteInfoItem:(InfoItem*)item atIndexPath:(NSIndexPath *)indexPath;
//
//-(void)TouchUpRightBtnofView:(NSInteger)viewTag;
//
//-(void)TouchItem:(NSInteger)nItemIndex ofView:(NSInteger)viewTag;

@end

@protocol InfoCollectionViewDataSource <NSObject>
@optional
/**
 *  通过代理设置Section个数
 *
 *  @return 返回Section个数
 */
- (NSInteger)numberOfSectionsInInfoCollectionView:(InfoCollectionView *)infoCollectionView;

@required
/**
 *  通过代理设置每个section中的item的个数
 *
 *  @return 返回Section个数
 */
-(NSInteger)infoCollectionView:(InfoCollectionView *)infoCollectionView numberOfItemsInSection:(NSInteger)section;

/**
 *  通过代理设置每个section中的InfoCollectionManager
 *
 *  @return 返回InfoCollectionManager
 */
-(InfoCollectionManager*)managerForInfoCollectionView:(InfoCollectionView*)infoCollectionView atSection:(NSInteger)section;

@end

@interface InfoCollectionView : UIView
-(id)initWithFrame:(CGRect)frame withDataSource:(NSArray*)arrItems withTitle:(NSString*)strTitle withBtnName:(NSString*)strBtnName;
-(CGFloat)getInfoCollectionViewHeight;
- (void)reloadData;
@property(nonatomic, assign) id<InfoCollectionViewDelegate> delegate;
@property(nonatomic, assign) id<InfoCollectionViewDataSource> dataSource;
@end
