//
//  LoginStatusAlertView.m
//  anhui
//
//  Created by 葛君语 on 2016/10/26.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "LoginStatusAlertView.h"

@interface LoginStatusAlertView ()

@property (nonatomic,copy) NSString *createDate;

@end

@implementation LoginStatusAlertView

#pragma mark -显示待审核状态
+ (void)show:(NSString *)createDate
{
    LoginStatusAlertView *alert = [[[NSBundle mainBundle]loadNibNamed:@"LoginStatusAlertView" owner:nil options:nil]lastObject];
    
    alert.createDate = createDate;
    
    [alert show];
}

#pragma mark -赋值
- (void)setCreateDate:(NSString *)createDate
{
    _createDate  = createDate;
    
    //注册时间
    UILabel *createDateLabel = [self viewWithTag:100];
    createDateLabel.text = [NSString stringWithFormat:@"注册时间：%@",_createDate];
    //账号
    UILabel *accountLabel = [self viewWithTag:200];
    accountLabel.text = [NSString stringWithFormat:@"注册账号：%@",[[NSUserDefaults standardUserDefaults]objectForKey:KEY_ACCOUTN]];
    //提交审核
    UILabel *auditDateLabel = [self viewWithTag:300];
    auditDateLabel.text = [NSString stringWithFormat:@"提交审核：%@",_createDate];
}


#pragma mark -展示
- (void)show
{
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIView *frontView = [[window subviews] firstObject];
    
    //蒙版
    UIView *coverView = [[UIView alloc]initWithFrame:MAIN_FRAME];
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [frontView addSubview:coverView];
    
    //提示框
    self.center = coverView.center;
    [coverView addSubview:self];
    
}

#pragma mark -btnAction
//点击 “我知道了”
- (IBAction)confrimAction:(UIButton *)sender {
    
    [self.superview removeFromSuperview];
}



@end
