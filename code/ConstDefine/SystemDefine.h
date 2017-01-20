//
//  SystemDefine.h
//  Cooperation
//
//  Created by yangjuanping on 16/10/18.
//  Description: 该头文件主要用来放系统相关的宏和常量定义，比如判断系统版本，机器尺寸等
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#ifndef SystemDefine_h
#define SystemDefine_h

#import <Foundation/Foundation.h>


#define KEY_IS_PRODUCTION  0  //是否正式环境


#define  OS_ABOVE_IOS8_2               ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.2)
#define  OS_ABOVE_IOS7                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 1 : 0)
#define  OS_ABOVE_IOS6                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define  OS_ABOVE_IOS4                 ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0)
#define SETSTATESTYTLELIGHT if (OS_ABOVE_IOS7) { \
[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;\
}



// 导航栏按钮左侧距离
#define NAV_BUTTON_LEFT_OFFSET_X   15
// 导航栏按钮右侧距离
#define NAV_BUTTON_RIGHT_OFFSET_X  10
// 导航栏按钮间距
#define NAV_BUTTON_OFFSET_X        3
// 导航栏按钮宽度
#define NAV_BUTTON_OFFSET_WIDTH    30
// 导航栏按钮高度
#define NAV_BUTTON_OFFSET_HEIGHT   30
#define NAV_BUTTON_IMAGE_WIDTH    21
#define NAV_BUTTON_IMAGE_HEIGHT   21
// 右侧开始，第一个按钮
#define  NAV_RIGHT_BUTTON_RECT  CGRectMake(MAIN_WIDTH - NAV_BUTTON_OFFSET_WIDTH - NAV_BUTTON_RIGHT_OFFSET_X, 7 + DISTANCE_TOP, NAV_BUTTON_OFFSET_WIDTH, NAV_BUTTON_OFFSET_HEIGHT)
// 右侧开始，第二个按钮
#define  NAV_RIGHT_BUTTON_RECT_2  CGRectMake(MAIN_WIDTH - NAV_BUTTON_OFFSET_WIDTH - NAV_BUTTON_RIGHT_OFFSET_X  - NAV_BUTTON_OFFSET_X - NAV_BUTTON_OFFSET_WIDTH, 7 + DISTANCE_TOP, NAV_BUTTON_OFFSET_WIDTH, NAV_BUTTON_OFFSET_HEIGHT)

#define  MAIN_HEIGHT                  [UIScreen mainScreen].bounds.size.height
#define  MAIN_WIDTH                   [UIScreen mainScreen].bounds.size.width
#define  MAIN_FRAME                   [UIScreen mainScreen].bounds

#define  HEIGHT_SEGEMENT_RES           30
#define  HEIGHT_NAVIGATION             44
#define  HEIGHT_STATUSBAR              20

#define  SCREEN_EQUAL_480              (MAIN_HEIGHT == 480 ? YES :NO )
#define  DISTANCE_TOP                  ((OS_ABOVE_IOS7) ? 20 :0)
#define  TABBAR_TOP                    ((OS_ABOVE_IOS7) ? 40 :0)

#define  CIRCLE_TOP                 ((OS_ABOVE_IOS7) ? 0 :20)
#define  HEIGTH_IS_ABOVE_480                  ((int)MAIN_HEIGHT >= 480)

#define  HEIGTH_IS_480                  ((int)MAIN_HEIGHT == 480)

#define  HEIGHT_MAIN_BOTTOM           50


#define SINGLETON_FOR_HEADER(className) \
+ (className *)sharedInstance;

//单例实现的公用函数
#define SINGLETON_FOR_CLASS(className) \
+ (className *)sharedInstance { \
static className *shared = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared = [[self alloc] init]; \
}); \
return shared; \
}

//是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))


#define OC(str) [NSString stringWithCString:(str) encoding:NSUTF8StringEncoding]


#define  IS_FIRST_LAUNCH                       @"IS_FIRST_LAUNCH"
#define  NOT_FIRST_LAUNCH                      @"NOT_FIRST_LAUNCH"

typedef NS_ENUM(NSInteger, E_DEVICE_TYPE) {
    iPhone2G = 0,
    iPhone3G,
    iPhone3GS,
    iPhone4,
    iPhone4S,
    iPodTouch1,
    iPodTouch2,
    iPodTouch3,
    iPodTouch4,
    iPhone5,
    iPhone5S,
    iPhone5C,
    iPodTouch5,
    iPodTouch6,
    iPhone6,
    iPhoneSE,
    iPhone6S,
    iPhone7,
    iPhoneSimulator,
    iPhone6Plus,
    iPhone6SPlus,
    iPhone7Plus,
    invalidDevice
};

typedef NS_ENUM(NSInteger, E_ROLE) {
    E_ROLE_TEACHER = 0,
    E_ROLE_PARENT,
    E_ROLE_STUDENT
};

extern E_DEVICE_TYPE deviceType;
extern E_ROLE role;


#endif /* SystemDefine_h */
