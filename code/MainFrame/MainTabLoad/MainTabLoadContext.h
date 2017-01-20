//
//  MainTabLoadContext.h
//  Cooperation
//
//  Created by yangjuanping on 16/10/25.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainTabLoadContext : NSObject
SINGLETON_FOR_HEADER(MainTabLoadContext)

// 注册每个tab页对应的viewController
-(void)RegisterSubViewController:(Class)subViewControllerClass;

// 获取每个tab页对应的PJTabBarItem组成的数组
-(NSArray*)getMainTabModuleData;
@end
