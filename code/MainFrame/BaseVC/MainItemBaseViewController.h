//
//  MainItemBaseViewController.h
//  Cooperation
//
//  Created by yangjuanping on 16/11/29.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "BaseViewController.h"
#import "MainItemBaseViewController.h"
#import "MainItemCollectionManager.h"
#import "MainCollectionIconItem.h"

#ifndef AH_MAINITEMBASEVC_MODULE
#define AH_MAINITEMBASEVC_MODULE \
+ (void)load { [[MainItemCollectionManager sharedInstance] RegisterMainItem:[self class]]; }
#endif

@class MainItemBaseViewController;

@interface MainItemBaseViewController : BaseViewController
-(void)loadInitialize;
-(void)ShowMainItemViewController:(UIViewController*)parentVC;
-(MainCollectionIconItem*)getIconItem;
@end
