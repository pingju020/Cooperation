//
//  BaseSubVcForMainTab.h
//  Cooperation
//
//  Created by yangjuanping on 16/10/25.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "BaseViewController.h"
#import "MainTabLoadContext.h"


#ifndef AH_BASESUBVCFORMAINTAB_MODULE
#define AH_BASESUBVCFORMAINTAB_MODULE \
+ (void)load { [[MainTabLoadContext sharedInstance] RegisterSubViewController:[self class]]; }
#endif

@class PJTabBarItem;

@interface BaseSubVcForMainTab : BaseViewController

-(PJTabBarItem*)getTabBarItem;
@end
