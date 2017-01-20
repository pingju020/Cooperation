//
//  GetPasswordViewController.m
//  anhui
//
//  Created by 葛君语 on 2016/10/25.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "GetPasswordViewController.h"
#import "LoginTextView.h"
#import "LoginButton.h"
#import "UIButton+Expand.h"
#import "RegisterModel.h"
#import "RegexKitLite.h"
#import "PubllicMaskViewHelper.h"
#import "XXTEncrypt.h"
#import "HttpLoginAndRegister.h"

static CGFloat kTextH;

@interface GetPasswordViewController ()
@property (nonatomic,strong) LoginTextView *phoneView;
@property (nonatomic,strong) LoginTextView *codeView;
@property (nonatomic,strong) LoginTextView *passwordView;
@property (nonatomic,strong) LoginButton *confirmButton;
@property (nonatomic,strong) UILabel *tipLabel;

@property (nonatomic,assign) BOOL isSettingNewPwd; //是否在设置新密码，刚进入页面是输入验证码的流程，所以默认为NO

@end

@implementation GetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"获取密码";
    self.view.backgroundColor = VcBackgroudColor;
    [self tipLabel];
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
    [[HttpLoginAndRegister sharedInstance] sendVerifyCode:_phoneView.text
                        sendType:@"1"
                  successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                      [self removeWaitingView];
                      if (isSucceed) {
                          [_codeView.rightButton countDownWithStartTime:60 waitTitleForward:@"还剩" backward:@"秒"];
                      }else{
                          [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                      }
                  }
                     failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                         [self removeWaitingView];
                         [PubllicMaskViewHelper showTipViewWith:@"网络异常" inSuperView:self.view withDuration:1];
                     }];
}

//下一步/确定
- (void)confirmClicked
{
    //收回键盘
    [self resignKeyboard];
    
    if (_isSettingNewPwd) {  //设置新密码中
        if (_passwordView.text.length<6 || _passwordView.text.length>20) {
            [PubllicMaskViewHelper showTipViewWith:@"请输入6-20位字母或数字组合密码" inSuperView:self.view withDuration:1];
            return;
        }
        
        //输入没问题，开始设置新密码
        [self setNewPassword];
        
    }else{ //输入验证码中
        if (![_phoneView.text isMatchedByRegex:@"1[3|5|7|8|][0-9]{9}"]) {
            [PubllicMaskViewHelper showTipViewWith:@"请输入正确手机号" inSuperView:self.view withDuration:1];
            return;
        };
        
        if (IsStrEmpty(_codeView.text)) {
            [PubllicMaskViewHelper showTipViewWith:@"请输入验证码" inSuperView:self.view withDuration:1];
            return;
        }
        
        //输入没问题，开始验证验证码
        [self checkCode];
        
        
    }
    
    
}

#pragma mark -request
- (void)checkCode
{
    [self showWaitingView];
    [[HttpLoginAndRegister sharedInstance] checkSMSCode:_phoneView.text
                       smsCode:_codeView.text
                       smsType:@"1" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                           [self removeWaitingView];
                           
                           if (isSucceed) {
                               //开始设置新密码
                               self.isSettingNewPwd = YES;
                               
                           }else{
                               [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                               
                           }
                       }
                   failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:@"网络异常" inSuperView:self.view withDuration:1];
                   }];
}

- (void)setNewPassword
{
    NSString *pwdCode = [[XXTEncrypt XXTmd5:_passwordView.text] uppercaseString];
    
    [self showWaitingView];
    [[HttpLoginAndRegister sharedInstance] newResetPassword:_codeView.text
                           account:_phoneView.text
                          password:pwdCode userType:@"1"
                    successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                        [self removeWaitingView];
                        
                        if (isSucceed) {
                            RegisterModel *model = [RegisterModel shared];
                            model.account  = _phoneView.text;
                            model.password = _passwordView.text;
                            model.modelClass = 2;
                            [[NSNotificationCenter defaultCenter]postNotificationName:kRegisterSuccessNotification object:nil];
                            
                            [self.navigationController popViewControllerAnimated:YES];
                            
                            
                        }else{
                            [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                        }
                    }
                       failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                           [self removeWaitingView];
                           [PubllicMaskViewHelper showTipViewWith:@"网络异常" inSuperView:self.view withDuration:1];
                       }];
}

#pragma mark -变更状态
- (void)setIsSettingNewPwd:(BOOL)isSettingNewPwd
{
    _isSettingNewPwd = isSettingNewPwd;
    if (!isSettingNewPwd) {
        return;
    }
    
    self.title = @"设置密码";
    self.phoneView.hidden    = YES;
    self.codeView.hidden     = YES;
    self.tipLabel.hidden     = YES;
    self.passwordView.hidden = NO;
    
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    self.confirmButton.top = self.passwordView.bottom+50;
    [self.passwordView.textField becomeFirstResponder];
}

#pragma mark -键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resignKeyboard];
}

- (void)resignKeyboard
{
    [self.phoneView.textField resignFirstResponder];
    [self.codeView.textField resignFirstResponder];
    [self.passwordView.textField resignFirstResponder];
}

#pragma mark -setUI
- (LoginTextView *)phoneView
{
    if (!_phoneView) {
        kTextH = MAIN_HEIGHT * 0.079;
        
        _phoneView = [[LoginTextView alloc]initWithFrame:CGRectMake(0, HEIGHT_NAVIGATION+DISTANCE_TOP+10, MAIN_WIDTH, kTextH) iconImage:nil buttonImage:nil selectedButtonImage:nil placeholder:@"请输入手机号码"];
        _phoneView.textField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneView.text = _defaultPhone;
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

- (LoginButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[LoginButton alloc]initWithFrame:CGRectMake(10, self.codeView.bottom+MAIN_HEIGHT*0.09, MAIN_WIDTH-20, kTextH)];
        [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.confirmButton.bottom+50, 300, 20)];
        _tipLabel.centerX = MAIN_WIDTH/2;
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.textColor = [UIColor colorWithHexString:@"#AEAFB0"];
        _tipLabel.text = @"如果您不知道密码，可通过本界面获取。";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (LoginTextView *)passwordView
{
    if (!_passwordView) {
        _passwordView = [LoginTextView createPasswordTextViewWithFrame:_phoneView.frame];
        _passwordView.textField.placeholder = @"设置密码，6-20位字母和数字组合";
        _passwordView.topLineHidden = NO;
        _passwordView.isIconHidden = YES;
        _passwordView.textField.secureTextEntry = NO;
        _passwordView.rightButton.selected = YES;
        _passwordView.hidden = YES;
        [self.view addSubview:_passwordView];
    }
    return _passwordView;
}

@end
