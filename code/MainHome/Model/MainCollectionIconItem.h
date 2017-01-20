//
//  MainCollectionIconItem.h
//  Cooperation
//
//  Created by yangjuanping on 2016/12/12.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MainItemBaseViewController;

@interface MainCollectionIconItem : NSObject
@property(nonatomic,weak)NSString* icon;
@property(nonatomic,weak)NSString* iconUrl;
@property(nonatomic,weak)NSString* title;
@property(nonatomic,weak)NSString* itemId;
@property(nonatomic,weak)MainItemBaseViewController* viewController;
@property(nonatomic,weak)Class     itemClass;
@end
