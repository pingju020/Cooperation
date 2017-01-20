//
//  MainItemCollectionManager.m
//  Cooperation
//
//  Created by yangjuanping on 16/11/29.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MainItemCollectionManager.h"
#import "MainItemBaseViewController.h"

@interface MainItemCollectionManager()
@property(nonatomic,strong)NSMutableDictionary<NSString*,MainCollectionIconItem*>* dicMainItemRegister;
@end

@implementation MainItemCollectionManager
SINGLETON_FOR_CLASS(MainItemCollectionManager)

-(id)init{
    if (self = [super init]) {
        _dicMainItemRegister = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)RegisterMainItem:(Class)mainHomeItemViewController{
    NSParameterAssert(mainHomeItemViewController != nil);
    if ([_dicMainItemRegister objectForKey:NSStringFromClass(mainHomeItemViewController)]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"MainCollectionItem %@ has been regisered!", NSStringFromClass(mainHomeItemViewController)] userInfo:nil];
    }
    
    NSString *key = NSStringFromClass(mainHomeItemViewController);
    
    id mainHomeItemVC = [[mainHomeItemViewController alloc]init];
    if ([mainHomeItemVC isKindOfClass:[MainItemBaseViewController class]]){
        MainItemBaseViewController* vc = mainHomeItemVC;
        [_dicMainItemRegister setObject:[vc getIconItem] forKey:key];
    }
}

-(void)requestMainItemList{
    NSMutableArray* arrItemList = [[NSMutableArray alloc]init];
    //向服务端获取主页图标列表，并对其进行转置（如一行显示4个的话，对于1，2，3，4，5，6，7，8 的序列，需要转成1，5，2，6，7，8，这样显示出来的效果才是第一行为1，2，3，4，第二行为5，6，7，8.）,保存到_arrMainItemList。
    
    //如果服务端没获取到列表，则按照本地配置加载。
    NSArray* arrListKey = (role==E_ROLE_TEACHER)?@[@"发作业",@"发通知",@"发评语",@"家校互动",@"办公短信",@"百度文库",@"课程表"]:@[@"班级空间",@"课程表",@"家校互动"];
    if (_dicMainItemRegister.count > 0) {
        NSArray* arrList = [_dicMainItemRegister allValues];
        for (NSString* key in arrListKey) {
            for (MainCollectionIconItem* item in arrList) {
                if ([item.itemId isEqualToString:key]) {
                    [arrItemList addObject:item];
                }
            }
        }
    }
    
    _arrMainItemList = arrItemList;
}

-(NSInteger)numberOfItemsInMainItemCollectionView{
    if (_arrMainItemList.count<=0) {
        [self requestMainItemList];
    }
    return _arrMainItemList.count;
}
@end
