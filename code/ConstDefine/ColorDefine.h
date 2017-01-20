//
//  ColorDefine.h
//  Cooperation
//
//  Created by yangjuanping on 16/10/18.
//  Description: 该头文件主要用来放颜色相关的宏或者常用色值定义
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#ifndef ColorDefine_h
#define ColorDefine_h

//16进制色值参数转换
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define  COMMON_CORLOR_HIGHLIGHT      UIColorFromRGB(0x60CDF6)
#define  COMMON_CORLOR_NORMAL         UIColorFromRGB(0x787878)//UIColorFromRGB(0xc4c4c4)

#define VcBackgroudColor                UIColorFromRGB(0xF3F4F6)

#endif /* ColorDefine_h */
