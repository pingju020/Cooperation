//
//  NSDictionary+ValueCheck.h
//  xxt_xj
//
//  Created by Points on 14-4-19.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(valueCheck)

-(id)stringWithFilted:(NSString *)key;
- (NSString *)stringForKey:(NSString *)aKey;
- (NSInteger)integerForKey:(NSString *)aKey;

- (NSMutableDictionary *)dictionarySort:(NSMutableDictionary *)dic;
- (NSDictionary *)addSigdic:(NSMutableDictionary *)dic;

// 广告
- (NSDictionary *)addAdsSigdic:(NSMutableDictionary *)dic;
- (NSString *)inputStrWithAdsDic:(NSDictionary *)param;

@end
