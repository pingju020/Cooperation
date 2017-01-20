//
//  UITableView+HeightCache.h
//  Cooperation
//
//  Created by yangjuanping on 2016/12/28.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (HeightCacheCell)
@property (assign ,nonatomic)BOOL JustForCal;//计算用的cell标识符（将计算用的cell与正常显示的cell进行区分，避免不必要的ui响应）
@property (assign ,nonatomic)BOOL NoAutoSizing;//不适用autoSizing标识符（不依靠约束计算，只进行自适应）
@end

@interface HeightCache : NSObject
@property (strong ,nonatomic)NSMutableDictionary * dicHeightCacheV;//竖直行高缓存字典
@property (strong ,nonatomic)NSMutableDictionary * dicHeightCacheH;//水平行高缓存字典
@property (strong ,nonatomic)NSMutableDictionary * dicHeightCurrent;//当前状态行高缓存字典（中间量）

///制作key
-(NSString *)makeKeyWithIdentifier:(NSString *)identifier
                         indexPath:(NSIndexPath *)indexPath;
///高度是否存在
-(BOOL)existInCacheByKey:(NSString *)key;
///取出缓存的高度
-(CGFloat)heightFromCacheWithKey:(NSString *)key;
///高度缓存
-(void)cacheHeight:(CGFloat)height
             byKey:(NSString *)key;
///根据key删除缓存
-(void)removeHeightByIdentifier:(NSString *)identifier
                      indexPath:(NSIndexPath *)indexPath
                   numberOfRows:(NSInteger)rows;
///删除所有缓存
-(void)removeAllHeight;
///插入cell是插入value
-(void)insertCellToIndexPath:(NSIndexPath *)indexPath
            withNumberOfRows:(NSInteger)rows
                heightNumber:(NSNumber *)height
                  identifier:(NSString *)identifier
        toDictionaryForCache:(NSMutableDictionary *)dic;
-(void)insertCellToIndexPath:(NSIndexPath *)indexPath withIdentifier:(NSString *)identifier numberOfRows:(NSInteger)rows toDictionaryForCache:(NSMutableDictionary *)dic;
///移动cell时交换value
-(void)moveCellFromIndexPath:(NSIndexPath *)sourceIndexPath
   sourceSectionNumberOfRows:(NSInteger)sourceRows
                 toIndexPath:(NSIndexPath *)destinationIndexPath
destinationSectionNumberOfRows:(NSInteger)destinationRows
              withIdentifier:(NSString *)identifier;
@end

@interface UITableView (HeightCache)
@property (strong ,nonatomic)HeightCache * cache;
@end
