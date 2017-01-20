//
//  MainDataModel.m
//  anhui
//
//  Created by yangjuanping on 16/2/16.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "MainDataModel.h"
#import "RollAdsDataDTO.h"

@interface MainDataModel()
@end

@implementation MainDataModel
SINGLETON_FOR_CLASS(MainDataModel);

-(BOOL)parseRollAds:(NSDictionary*)dicData{
    if(dicData){
        NSMutableArray * arr = [NSMutableArray array];
        NSMutableArray* arrImg =  [[NSMutableArray alloc]init];
        NSArray *data = dicData[@"data"];
        for (NSDictionary *retDic in data) {
            RollAdsDataDTO *dto = [[RollAdsDataDTO alloc] init];
            [dto encodeFromDictionary:retDic];
            [arr addObject:dto];
            [arrImg addObject:dto.adsUrl];
        }
        
        _arrAdsList = arr;
        _arrImgList = arrImg;
        return TRUE;
        
    }
    return FALSE;
}

-(BOOL)parseInfo:(NSDictionary *)dicData{
    NSArray* arrMsg = dicData[@"msglist"];
//    NSMutableArray* arrItem = [[NSMutableArray alloc]init];
//    for (int i = 0; i < 2; i++) {
//        NSMutableDictionary* item = [[NSMutableDictionary alloc]init];
//        NSDictionary* msgItem = [arrMsg objectAtIndex:i];
//        
//        [item setValue:msgItem[@"topic_img"] forKey:@"topic_img"];
//        [item setValue:msgItem[@"time"] forKey:@"time"];
//        [item setValue:msgItem[@"topic_title"] forKey:@"topic_title"];
//        [item setValue:msgItem[@"topic_id"] forKey:@"topic_id"];
//        [arrItem addObject:item];
//    }
//    _arrInfoList = arrItem;
//    return YES;
    
    _infoListManager = [[InfoCollectionManager alloc]init];
    _infoListManager.infoSectionTitle = @"精彩资讯";
    _infoListManager.infoSectionRightBtnName = @"更多";
    NSMutableArray* arrItems = [[NSMutableArray alloc]init];
    for (int i = 0; i < 2; i++) {
        NSDictionary * msgItem = [arrMsg objectAtIndex:i];
        InfoItem* item = [[InfoItem alloc]init];
        item.iconName = @"app_one.jpg";
        //item.iconUrl = [NSString stringWithFormat:@"%@/%@",XJ_SERVER,msgItem[@"topic_img"]];
        item.itemId = msgItem[@"topic_id"];
        item.itemTitle = msgItem[@"topic_title"];
        item.itemDesc = msgItem[@"time"];
        [arrItems addObject:item];
    }
    _infoListManager.infoItems = arrItems;
    return YES;
}
@end
