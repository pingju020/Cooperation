//
//  MainHomeItemView.h
//  Cooperation
//
//  Created by yangjuanping on 16/11/21.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainHomeItemLoadContext.h"

#ifndef AH_MAINHOME_ITEMVIEW
#define AH_MAINHOME_ITEMVIEW \
+(void)load{[[MainHomeItemLoadContext sharedInstance]RegisterMainHomeItem:[self class]]; }
#endif

//****************************************
// 主页所有控件的基类
// 所有该类的子类除了实现要在主页展现的效果外，还必须额外实现下面的接口
// -(CGFloat)getItemHeight -- 返回控件自身的高度
// -(NSInteger)getItemIndex -- 返回控件在主页的顺序，因为主页第一个控件为广告，所以所有的继承自该类的控件index都是从1起。如MainItemCollectionView，为目前主页除广告控件外第一个控件，本来index当为0，但是现在实际是1.其余以此类推。
// 另，所有该类的子类，都应该在类的implementation中添加AH_MAINHOME_ITEMVIEW的调用，保证自注册。
//****************************************
@interface MainHomeItemView : UIView
-(CGFloat)getItemHeight;
-(NSInteger)getItemIndex;
@end
