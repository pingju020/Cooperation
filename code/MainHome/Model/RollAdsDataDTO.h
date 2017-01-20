//
//  RollAdsDataDTO.h
//  xxt_xj
//
//  Created by Yang on 15/2/11.
//  Copyright (c) 2015年 Points. All rights reserved.
//

#import "DataBaseModel.h"

@interface RollAdsDataDTO : DataBaseModel
@property (nonatomic, copy) NSString *adsPosition;
@property (nonatomic, copy) NSString *adsId;
@property (nonatomic, copy) NSString *adsAction;
@property (nonatomic, copy) NSString *adsUrl;
@property (nonatomic, copy) NSString *monitorParam;//点击广告，是否需要客户端带参数，1：要带，2：不带

@property (nonatomic, copy) NSString *adsTitle;


//新添加
@property (nonatomic,copy) NSString *iscut_screen; // 0 表示 分享url   1 表示 分享截屏
@property (nonatomic,copy) NSString *share_url;   //用于分享的网页地址，当分享方式为url时，分享的是这个url

@end
