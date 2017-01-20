//
//  MainHomeItemLoadContext.m
//  Cooperation
//
//  Created by yangjuanping on 16/11/21.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MainHomeItemLoadContext.h"
#import "MainHomeItemView.h"


@interface MainHomeItemLoadContext()
@property(nonatomic,strong)NSMutableArray<MainHomeItemView*>* arrItems;
@property(nonatomic,strong)NSMutableArray<NSString*>* arrClassName;
@end

@implementation MainHomeItemLoadContext

SINGLETON_FOR_CLASS(MainHomeItemLoadContext)

-(id)init{
    if (self = [super init]) {
        _arrClassName = [[NSMutableArray alloc]init];
        _arrItems = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)RegisterMainHomeItem:(Class)mainHomeItemView{
    NSParameterAssert(mainHomeItemView != nil);
    for (NSString* className in _arrClassName) {
        if ([className isEqualToString:NSStringFromClass(mainHomeItemView)] ) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ item已经注册过", NSStringFromClass(mainHomeItemView)] userInfo:nil];
        }
    }
    
    NSString *key = NSStringFromClass(mainHomeItemView);
    [_arrClassName addObject:key];
    
    id item = [[mainHomeItemView alloc]init];
    if ([item isKindOfClass:[MainHomeItemView class]]) {
        MainHomeItemView *itemView = item;
        NSInteger index = [itemView getItemIndex];
        if (index > _arrItems.count) {
            [_arrItems addObject:item];
        }
        else{
            [_arrItems insertObject:item atIndex:index-1];
        }
    }
}

-(NSInteger)getItemsCount{
    return _arrItems.count;
}

-(CGFloat)itemHeightAtIndex:(NSInteger)index{
    CGFloat fHeight = 0.0;
    if (index < _arrItems.count) {
        MainHomeItemView* item = _arrItems[index];
        fHeight = [item getItemHeight];
    }
    else{
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"mainHomeItem index 越界,当前值为%zi, item 总数为%zi", index,  _arrItems.count] userInfo:nil];
    }
    
    return fHeight;
}

-(UIView*)itemAtIndex:(NSInteger)index{
    MainHomeItemView* item = nil;
    if (index < _arrItems.count) {
        item = _arrItems[index];
    }
    else{
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"mainHomeItem index 越界,当前值为%zi, item 总数为%zi", index,  _arrItems.count] userInfo:nil];
    }
    return item;
}
@end
