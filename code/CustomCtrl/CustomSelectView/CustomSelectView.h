//
//  CustomSelectView.h
//  anhui
//
//  Created by 葛君语 on 2016/11/1.
//  Copyright © 2016年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomSelectView : UIView

//初始化
- (instancetype)initWithTitle:(NSString *)title buttonTitles:(NSString *)firstTitle,...NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithTitle:(NSString *)title;

//额外添加按钮
- (void)addButtonWithTitle:(NSString *)title;

//展示
- (void)show;

//点击事件
@property (nonatomic,copy) void (^clickHandle)(NSInteger buttonIndex);

//被选中的下标
@property (nonatomic,assign) NSInteger selectedIndex;



@end

