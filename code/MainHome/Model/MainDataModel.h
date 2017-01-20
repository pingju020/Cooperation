//
//  MainDataModel.h
//  anhui
//
//  Created by yangjuanping on 16/2/16.
//  Copyright © 2016年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoCollectionManager.h"

@protocol MainDataModelDelegate <NSObject>
-(void)getRollAds:(BOOL)success;
-(void)getTopic:(BOOL)success;
@end

@interface MainDataModel : NSObject
@property(nonatomic, assign)id<MainDataModelDelegate> delegate;
@property(nonatomic, assign)NSString* strInfo;
@property(nonatomic, strong)InfoCollectionManager* infoListManager;
@property(nonatomic, strong)NSArray* arrImgList;
@property(nonatomic, strong)NSArray* arrAdsList;
@property(nonatomic, strong)NSArray* arrChildrenList;
@property(nonatomic, strong)NSArray* arrHideGroup;

SINGLETON_FOR_HEADER(MainDataModel);

-(BOOL)parseRollAds:(NSDictionary*)dicData;

-(BOOL)parseInfo:(NSDictionary *)dicData;
@end
