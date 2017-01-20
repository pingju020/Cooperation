//
//  MainItemCollectionManager.h
//  Cooperation
//
//  Created by yangjuanping on 16/11/29.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainItemCollectionManager : NSObject
SINGLETON_FOR_HEADER(MainItemCollectionManager)

@property(nonatomic,strong)NSArray* arrMainItemList;

-(void)RegisterMainItem:(Class)mainHomeItemViewController;

-(void)requestMainItemList;

-(NSInteger)numberOfItemsInMainItemCollectionView;
@end
