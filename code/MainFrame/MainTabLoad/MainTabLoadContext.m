//
//  MainTabLoadContext.m
//  Cooperation
//
//  Created by yangjuanping on 16/10/25.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MainTabLoadContext.h"
#import "BaseSubVcForMainTab.h"
#import "PJTabBarItem.h"

@interface MainTabLoadContext()
@property(nonatomic,strong)NSMutableDictionary<NSString *, Class>   *moduleClassesByName;
//@property(nonatomic,strong)NSArray* moduleData;
@end

@implementation MainTabLoadContext

SINGLETON_FOR_CLASS(MainTabLoadContext)


-(id)init{
    if (self = [super init]) {
        _moduleClassesByName = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)RegisterSubViewController:(Class)subViewControllerClass{
    NSParameterAssert(subViewControllerClass != nil);
    if ([_moduleClassesByName objectForKey:NSStringFromClass(subViewControllerClass)]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ tab页已经注册过", NSStringFromClass(subViewControllerClass)] userInfo:nil];
    }
    
    NSString *key = NSStringFromClass(subViewControllerClass);
    [_moduleClassesByName setObject:subViewControllerClass forKey:key];
}

-(NSArray*)getMainTabModuleData{
    NSMutableArray* arrItems = [[NSMutableArray alloc]init];
    for (Class cls in [_moduleClassesByName allValues]) {
        id subTabview = [[cls alloc]init];
        if ([subTabview isKindOfClass:[BaseSubVcForMainTab class]]) {
            BaseSubVcForMainTab *baseSubVcForMainTab = subTabview;
            PJTabBarItem* item = [baseSubVcForMainTab getTabBarItem];
            if (item.tabIndex > arrItems.count) {
                [arrItems addObject:item];
            }
            else{
                [arrItems insertObject:item atIndex:item.tabIndex-1];
            }
        }
    }
    return arrItems;
}
@end
