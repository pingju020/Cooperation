//
//  TopicEmojiUtil.m
//  xxt_xj
//
//  Created by Points on 13-12-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "FontSizeUtil.h"
//#import "EmojiShifterUtil.h"
@implementation FontSizeUtil

+ (CGSize)sizeOfString:(NSString *)str withFont:(UIFont *)font
{
    CGSize bubbleSize =CGSizeZero;
    CGSize size = CGSizeMake(MAIN_WIDTH,MAXFLOAT);
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000)
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:font forKey: NSFontAttributeName];
    bubbleSize =  [str  boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:stringAttributes context:nil].size;
#else
    bubbleSize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#endif
    return bubbleSize;
}


+ (CGSize)sizeOfString:(NSString *)str withFont:(UIFont *)font withWidth:(int)width
{
    // 临时的处理有表情时，计算空间有误的问题
//    NSArray * arr = [str componentsMatchedByRegex:REGEX_EMOJI];
//    if (arr.count != 0)
//    {
//        for(NSString * finded in arr)
//        {
//            NSString * str1 = [EmojiShifterUtil getOrginal:finded];
//            if(str1 == nil)
//            {
//                continue;
//            }
//            str = [str stringByReplacingOccurrencesOfString:finded withString:@"123"];
//        }
//    }
    
    CGSize bubbleSize =CGSizeZero;
    CGSize size = CGSizeMake(width,MAXFLOAT);
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000)
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:font forKey: NSFontAttributeName];
    bubbleSize =  [str  boundingRectWithSize:size options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:stringAttributes context:nil].size;
#else
    bubbleSize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#endif
    return bubbleSize;
}

@end
