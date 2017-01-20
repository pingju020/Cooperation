//
//  MainHomeItemView.m
//  Cooperation
//
//  Created by yangjuanping on 16/11/21.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MainHomeItemView.h"

@implementation MainHomeItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(PJTabBarItem*)getTabBarItem{
//    [self doesNotRecognizeSelector:@selector(getTabBarItem)];
//    //    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"getTabBarItem 方法必须在BaseSubVcForMainTab子类中实现后再使用" userInfo:nil];
//    return nil;
//}

-(CGFloat)getItemHeight{
    [self doesNotRecognizeSelector:@selector(getItemHeight)];
    return 0;
}

// 仅对item注册时排序使用，其他时候直接使用列表的序列
-(NSInteger)getItemIndex{
    [self doesNotRecognizeSelector:@selector(getItemHeight)];
    return 0;
}

@end
