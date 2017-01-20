//
//  RegisterNewController.m
//  anhui
//
//  Created by 葛君语 on 2016/10/20.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "RegisterNewController.h"
#import "LoginTextView.h"
#import "UIButton+Expand.h"
#import "LoginButton.h"
#import "JoinClassViewController.h"
#import "RegisterModel.h"
#import "LeftAlignAlertView.h"
#import "RegexKitLite.h"
#import "HttpLoginAndRegister.h"

static CGFloat kTextH;

@interface RegisterNewController ()
@property (nonatomic,strong) LoginTextView *phoneView;
@property (nonatomic,strong) LoginTextView *codeView;
@property (nonatomic,strong) LoginTextView *passwordView;
@property (nonatomic,strong) LoginButton *registerButton;

@end

@implementation RegisterNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    self.view.backgroundColor = VcBackgroudColor;
    [self registerButton];
}

#pragma mark -btnAction
- (void)codeClicked
{
    [self resignKeyboard];
    
    if (![_phoneView.text isMatchedByRegex:@"1[3|5|7|8|][0-9]{9}"]) {
        [PubllicMaskViewHelper showTipViewWith:@"请输入正确手机号" inSuperView:self.view withDuration:1];
        return;
    };
    
    
    [self showWaitingView];
    [LOGIN_REGISTER sendVerifyCode:_phoneView.text
                        sendType:@"2"
                  successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                      [self removeWaitingView];
                      if (isSucceed) {
                          [_codeView.rightButton countDownWithStartTime:60 waitTitleForward:@"还剩" backward:@"秒"];
                      }else{
                          [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                      }

                  } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                      [self removeWaitingView];
                      [PubllicMaskViewHelper showTipViewWith:@"网络异常" inSuperView:self.view withDuration:1];
                  }];
}

- (void)registerClicked
{
    [self resignKeyboard];
    
    if (![_phoneView.text isMatchedByRegex:@"1[3|5|7|8|][0-9]{9}"]) {
        [PubllicMaskViewHelper showTipViewWith:@"请输入正确手机号" inSuperView:self.view withDuration:1];
        return;
    };
    
    if (IsStrEmpty(_codeView.text)) {
        [PubllicMaskViewHelper showTipViewWith:@"请输入验证码" inSuperView:self.view withDuration:1];
        return;
    }
    
    if (_passwordView.text.length<6 || _passwordView.text.length>20) {
        [PubllicMaskViewHelper showTipViewWith:@"请输入6-20位字母或数字组合密码" inSuperView:self.view withDuration:1];
        return;
    }
    
    [self showWaitingView];
    [LOGIN_REGISTER registerNewWithTel:_phoneView.text
                                  code:_codeView.text
                              password:_passwordView.text
                        successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                            [self removeWaitingView];
                            if (isSucceed) {
                                
                                RegisterModel *model = [RegisterModel shared];
                                model.account  = _phoneView.text;
                                model.password = _passwordView.text;
                                model.modelClass = 1;
                                
                                LeftAlignAlertView *alert = [[LeftAlignAlertView alloc]initWithTitle:@"温馨提示"
                                                                                             message:@"恭喜您，注册成功! \r\n 加入班级后可使用更多和教育功能，是否立即加入班级？"
                                                                                            delegate:self
                                                                                   cancelButtonTitle:@"暂不"
                                                                                   otherButtonTitles:@"好的", nil];
                                
                                alert.buttonBlock = ^(NSInteger buttonIndex){
                                    if (buttonIndex == 0) {//暂不 退出登录页面
                                        [[NSNotificationCenter defaultCenter]postNotificationName:kRegisterSuccessNotification object:nil];
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                    }else if (buttonIndex == 1){//好的 开始选择班级
                                        [self.navigationController pushViewController:[JoinClassViewController new] animated:YES];
                                    }
                                };
                                
                                [alert show];
                                
                            }else{
                                [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                            }
                        } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                            [self removeWaitingView];
                            [PubllicMaskViewHelper showTipViewWith:@"网络异常" inSuperView:self.view withDuration:1];
                        }];
}

#pragma mark -键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resignKeyboard];
}

- (void)resignKeyboard
{
    [_phoneView.textField resignFirstResponder];
    [_codeView.textField resignFirstResponder];
    [_passwordView.textField resignFirstResponder];
}

#pragma mark -setUI
- (LoginTextView *)phoneView
{
    if (!_phoneView) {
        kTextH = MAIN_HEIGHT * 0.079;
        _phoneView = [[LoginTextView alloc]initWithFrame:CGRectMake(0, 10+navigationBG.bottom, MAIN_WIDTH, kTextH) iconImage:nil buttonImage:nil selectedButtonImage:nil placeholder:@"请输入手机号码"];
        _phoneView.text = self.phoneNum;
        _phoneView.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:_phoneView];
    }
    return _phoneView;
}

- (LoginTextView *)codeView
{
    if (!_codeView) {
        _codeView = [LoginTextView createCodeTextViewWithFrame:CGRectMake(0, self.phoneView.bottom, MAIN_WIDTH, kTextH)];
        _codeView.isIconHidden = YES;
        [_codeView.rightButton addTarget:self action:@selector(codeClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_codeView];
    }
    return _codeView;
}

- (LoginTextView *)passwordView
{
    if (!_passwordView) {
        _passwordView = [LoginTextView createPasswordTextViewWithFrame:CGRectMake(0, self.codeView.bottom, MAIN_WIDTH, kTextH)];
        _passwordView.textField.placeholder = @"设置密码，6-20位字母和数字组合";
        _passwordView.isIconHidden = YES;
        [self.view addSubview:_passwordView];
    }
    return _passwordView;
}

- (LoginButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [[LoginButton alloc]initWithFrame:CGRectMake(10, self.passwordView.bottom+MAIN_HEIGHT*0.09, MAIN_WIDTH-20, kTextH)];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_registerButton];
    }
    return _registerButton;
}


@end
