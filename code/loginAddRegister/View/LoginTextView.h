//
//  LoginTextView.h
//  anhui
//
//  Created by 葛君语 on 2016/10/17.
//  Copyright © 2016年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTextView : UIView

#pragma mark -工厂模式
+ (instancetype)createAccountTextViewWithFrame:(CGRect)frame;  //账号框
+ (instancetype)createPasswordTextViewWithFrame:(CGRect)frame; //密码框
+ (instancetype)createCodeTextViewWithFrame:(CGRect)frame;     //验证码框
+ (instancetype)createSelectTextViewWithFrame:(CGRect)frame;   //带右箭头的输入框

#pragma mark -自定义
- (instancetype)initWithFrame:(CGRect)frame    
                    iconImage:(id)iconImage  //传图片或者图片名
                  buttonImage:(id)buttonImage
          selectedButtonImage:(id)selectedButtonImage
                  placeholder:(NSString *)placeholder;

///图标
@property (nonatomic,assign) BOOL isIconHidden; //是否隐藏左边图标 default NO

///输入框
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,copy) NSString *text;

///右按钮
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,assign) BOOL isRightHidden; //是否隐藏右边图标 default NO

//分割线
@property (nonatomic,assign) BOOL topLineHidden;     //是否需要上分隔线 default NO
@property (nonatomic,assign) BOOL bottomLineHidden;  //是否需要下分隔线 default NO


@end
