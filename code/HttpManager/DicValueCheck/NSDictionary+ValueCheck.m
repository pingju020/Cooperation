//
//  NSDictionary+ValueCheck.m
//  xxt_xj
//
//  Created by Points on 14-4-19.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import "NSDictionary+ValueCheck.h"
#import "XXTEncrypt.h"
//#import "SNDefines.h"


#pragma mark -sig的约定key值
#define SECRETKEY @"F2f65547aE8cA0cEf4Ee"
#define SECRETKEYADS @"acsiof0(D"

@implementation NSDictionary(valueCheck)
-(id)stringWithFilted:(NSString *)key
{
    
    if([self isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    
    id obj = [self objectForKey:key];
    if([obj isKindOfClass:[NSNull class]])
    {
        obj = @"";
    }
    
    if(obj == nil)
    {
        return nil;
    }
    
    if([obj isKindOfClass:[NSNumber class]])
    {
        NSNumber *ret = (NSNumber *)obj;
        return [NSString stringWithFormat:@"%lld",[ret longLongValue]];
    }
    return obj;
}

- (NSString *)stringForKey:(NSString *)aKey;
{
    id obj = [self objectForKey:aKey];
    NSString *str;
    
    if([obj isKindOfClass:[NSNull class]])
    {
        obj = @"";
    }
    
    if(obj == nil)
    {
        obj = @"";
    }
    
    str = [NSString stringWithFormat:@"%@", obj];
    
    return str;
}

- (NSInteger)integerForKey:(NSString *)aKey;
{
    NSString *s = [self stringForKey:aKey];
    return s.integerValue;
}


- (NSMutableDictionary *)dictionarySort:(NSMutableDictionary *)dic {
    NSMutableDictionary *sortedDic = [[NSMutableDictionary alloc] init];
    NSArray *keyArr = [dic allKeys];
    
    NSArray *sortedArray = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *key in sortedArray) {
        [sortedDic setValue:dic[key] forKey:key];
    }
    
    return sortedDic;
}

- (NSDictionary *)addSigdic:(NSMutableDictionary *)dic {
    dic = [dic dictionarySort:(NSMutableDictionary *)dic];
    NSString *signature = [XXTEncrypt XXTmd5:[self inputStrWithDic:dic]];
    [dic setValue:signature forKey:@"sig"];
    return dic;
    
    
}

#pragma mark - 添加签名参数sig
- (NSString *)inputStrWithDic:(NSDictionary *)param
{
    
    NSMutableString *inputStr = [NSMutableString string];
    NSArray *keyArr = [param allKeys];
    
    NSArray *sortedArray = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    for (NSString *key in sortedArray) {
        NSString *value = [param objectForKey:key];
        [inputStr appendString:[NSString stringWithFormat:@"%@=%@",key,value]];
        //        [inputStr appendString:value];
    }
    [inputStr appendString:SECRETKEY];
    
    NSString *urlInputStr1 = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)inputStr,NULL,CFSTR("!'();:@&=+$,/?%#[]~"),kCFStringEncodingUTF8));
    //    NSString *urlInputStr1 = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)inputStr,NULL,NULL,kCFStringEncodingUTF8));
    
    NSString *urlInputStr2 = [urlInputStr1 stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
    return urlInputStr2;
}

#pragma mark - 添加广告签名参数sig
- (NSDictionary *)addAdsSigdic:(NSMutableDictionary *)dic {
    dic = [dic dictionarySort:(NSMutableDictionary *)dic];
    
    NSMutableString *inputStr = [NSMutableString string];
    NSArray *keyArr = [dic allKeys];
    
    NSArray *sortedArray = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    for (NSString *key in sortedArray) {
        NSString *value = [dic objectForKey:key];
        [inputStr appendString:[NSString stringWithFormat:@"%@=%@",key,value]];
    }
    
    NSString *signature = [XXTEncrypt XXTmd5:inputStr];
    [dic setValue:signature forKey:@"sig"];
    return dic;
}

- (NSString *)inputStrWithAdsDic:(NSDictionary *)param
{
    
    NSMutableString *inputStr = [NSMutableString string];
    NSArray *keyArr = [param allKeys];
    
    NSArray *sortedArray = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    for (NSString *key in sortedArray) {
        NSString *value = [param objectForKey:key];
        [inputStr appendString:[NSString stringWithFormat:@"%@=%@",key,value]];
        //        [inputStr appendString:value];
    }
    [inputStr appendString:SECRETKEYADS];
    
    NSString *urlInputStr1 = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)inputStr,NULL,CFSTR("!'();:@&=+$,/?%#[]~"),kCFStringEncodingUTF8));
    //    NSString *urlInputStr1 = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)inputStr,NULL,NULL,kCFStringEncodingUTF8));
    
    NSString *urlInputStr2 = [urlInputStr1 stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
    return urlInputStr2;
}


@end
