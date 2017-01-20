//
//  RollAdsDataDTO.m
//  xxt_xj
//
//  Created by Yang on 15/2/11.
//  Copyright (c) 2015年 Points. All rights reserved.
//

#import "RollAdsDataDTO.h"

@implementation RollAdsDataDTO

-(void)encodeFromDictionary:(NSDictionary *)dic {
    if (dic == nil) {
        return;
    }
    self.adsId = [dic objectForKey:@"id"] == nil ? @"" : [dic objectForKey:@"id"];
    self.adsAction = [dic objectForKey:@"action"] == nil ? @"" :[dic objectForKey:@"action"];
    self.adsPosition = [dic objectForKey:@"position"]? @"" :[dic objectForKey:@"position"];
    self.adsUrl = [dic objectForKey:@"url"] == nil ? @"" :[dic objectForKey:@"url"];
    self.monitorParam = [dic objectForKey:@"monitorParam"] == nil ? @"" :[dic objectForKey:@"monitorParam"];
    self.adsTitle = [dic objectForKey:@"title"] == nil? @"" : [dic objectForKey:@"title"];
    
    self.iscut_screen = [dic objectForKey:@"iscut_screen"] == nil ? @"" : [dic objectForKey:@"iscut_screen"];
    self.share_url = [dic objectForKey:@"share_url"] == nil ? @"" : [dic objectForKey:@"share_url"];
}
@end
