//
//  MainHomeItemLoadContext.h
//  Cooperation
//
//  Created by yangjuanping on 16/11/21.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MainHomeItemView;

@interface MainHomeItemLoadContext : NSObject

SINGLETON_FOR_HEADER(MainHomeItemLoadContext)

-(void)RegisterMainHomeItem:(Class)mainHomeItemView;

-(NSInteger)getItemsCount;
-(CGFloat)itemHeightAtIndex:(NSInteger)index;
-(UIView*)itemAtIndex:(NSInteger)index;
@end
