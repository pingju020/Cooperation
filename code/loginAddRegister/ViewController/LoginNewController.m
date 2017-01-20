//
//  LoginNewController.m
//  anhui
//
//  Created by 葛君语 on 2016/10/18.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "LoginNewController.h"
#import "ClassIconImageView.h"
#import "LoginTextView.h"
#import "LoginManager.h"
#import "UIButton+Expand.h"
#import "LoginButton.h"
#import "HistoryUserView.h"
#import "PJTabBarController.h"
#import "LaunchImageView.h"
#import "NewFeatureViewController.h"
#import "RegisterNewController.h"
#import "RegisterModel.h"
#import "GetPasswordViewController.h"
#import "LeftAlignAlertView.h"
#import "CustomSelectView.h"
#import "RegexKitLite.h"
#import "HttpLoginAndRegister.h"
static NSString *kDefaultIcon = @"headPic.jpg";  //默认头像
static CGFloat kTextH; //输入框高度
CGFloat kButtonSpaceH; //确定按钮到输入框的间距

@interface LoginNewController ()<HistoryUserViewDelegate>

//UI
@property (nonatomic,strong) UIView *backgroundView;                //背景图
@property (nonatomic,strong) UIButton *registerButton;              //注册按钮
@property (nonatomic,strong) UIView *iconCircleView;                //圆环
@property (nonatomic,strong) ClassIconImageView *iconView;          //头像
@property (nonatomic,strong) LoginTextView *accountView;            //账号区
@property (nonatomic,strong) LoginTextView *passwordView;           //密码区
@property (nonatomic,strong) LoginTextView *codeView;               //验证码区
@property (nonatomic,strong) LoginButton *confrimButton;            //下一步&确认按钮
@property (nonatomic,strong) UIButton *changeTypeButton;            //切换登录方式按钮  密码/验证码
@property (nonatomic,strong) UIButton *getPasswordbutton;           //获取密码按钮
@property (nonatomic,strong) LaunchImageView *launchImageView;      //启动广告页

//开关
@property (nonatomic,assign) BOOL isAccountVerified; //账号是否验证过
@property (nonatomic,assign) BOOL isPasswordType;    //是否是密码方式登录  YES 密码 NO 验证码

//管理器
@property (nonatomic,strong) LoginManager *loginManager; //处理登录逻辑 和 相关数据
@property (nonatomic,strong) AutoLoginModel *autoModel; //自动登录信息

@end

@implementation LoginNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //标题
    self.title = @"登录";
    //初始化UI
    [self setUI];
    //自动登录
    [self autoLogin];
    
}


#pragma mark -btnAction
//点击历史记录
- (void)historyListClicked
{
    [self resignKeyboard];

    //生成选择框
    HistoryUserView *listView = [[HistoryUserView alloc]initWithMaxY:_accountView.bottom];
    listView.m_delegate = self;
    [self.view addSubview:listView];
}

//点击注册
- (void)registerClicked
{
    [self resignKeyboard];
    [self pushToRegister:nil];
}

//点击获取验证码
- (void)codeClicked
{
    if (![_accountView.text isMatchedByRegex:@"1[3|5|7|8|][0-9]{9}"]) {
        [PubllicMaskViewHelper showTipViewWith:@"请通过手机号码进行短信登录" inSuperView:self.view withDuration:1];
        return;
    };
    
    [self showWaitingView];
    
    [LOGIN_REGISTER sendVerifyCode:_accountView.text
                        sendType:@"1"
                  successedBlock:^(NSDictionary *succeedResult,BOOL isSucceed) {
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

//点击下一步/登录按钮
- (void)confrimClicked
{
    //撤回键盘
    [self resignKeyboard];

    
    if (_isAccountVerified) { //账号验证过了，点的是登录
        //检查密码或者验证码是否都输入了
        if (_isPasswordType && IsStrEmpty(_passwordView.text)) { //密码
            [PubllicMaskViewHelper showTipViewWith:@"请输入密码" inSuperView:self.view withDuration:1];
            return;
        }else if (!_isPasswordType && IsStrEmpty(_codeView.text)){//验证码
            [PubllicMaskViewHelper showTipViewWith:@"请输入验证码" inSuperView:self.view withDuration:1];
            return;
            
        }
        //如果多身份，让用户选择身份
        if ([_loginManager.user_role isEqualToString:@"0"]) {
            
            CustomSelectView *view = [[CustomSelectView alloc]initWithTitle:@"请选择登录角色" buttonTitles:@"教师",@"家长", nil];
            view.clickHandle = ^(NSInteger buttonIndex){
                _loginManager.user_type = (buttonIndex == 0 ? @"1" : @"3");
                [self startLogin];
            };
            [view show];
            
            return;
        }
        //没有问题开始登录
        [self startLogin];
        
        
    }else{  //账号未验证，点的是验证账号
        //检测账号是否输入
        if (IsStrEmpty(_accountView.text)) {
            [PubllicMaskViewHelper showTipViewWith:@"未输入账号" inSuperView:self.view withDuration:1];
            return;
        }
        //没有问题开始验证账号
        [self startVerifyAccount];
        
    }
    
}

//点击切换登录方式
- (void)changeTypeClicked:(UIButton *)sender
{
    _isPasswordType ^= 1;
    
    //更改标题
    [sender setTitle:(_isPasswordType?@"通过短信登录":@"通过账号密码登录") forState:UIControlStateNormal];
    
    //获取密码按钮隐藏/显示
    _getPasswordbutton.hidden = !_isPasswordType;
    //密码框
    self.passwordView.hidden  = !_isPasswordType;
    //验证码框
    self.codeView.hidden      = _isPasswordType;
    
}

//点击获取密码
- (void)getPasswordClicked
{
    [self resignKeyboard];
    GetPasswordViewController *vc = [GetPasswordViewController new];
    vc.defaultPhone = _accountView.text;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -登录相关
//验证账号
- (void)startVerifyAccount
{
    [self showWaitingView];
    [LOGIN_REGISTER verifyLoginAccount:_accountView.text
                      successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                          [self removeWaitingView];
                          if (isSucceed) {
                              _loginManager = [LoginManager parsingWithDictionary:succeedResult];
                              
                              //未注册
                              if ([_loginManager.parent_statu isEqualToString:@"6"] && [_loginManager.teacher_statu isEqualToString:@"4"]) {
                                  [self removeLaunchImage]; //实际场景这行函数不存在，测试用
                                  LeftAlignAlertView *alert = [[LeftAlignAlertView alloc]initWithTitle:@"温馨提示"
                                                                                               message:@"您还不是和教育用户,现在去注册吧。"
                                                                                              delegate:self
                                                                                     cancelButtonTitle:@"暂不"
                                                                                     otherButtonTitles:@"好的", nil];
                                  alert.buttonBlock = ^(NSInteger buttonIndex){
                                      if (buttonIndex == 1) {
                                          [self pushToRegister:_accountView.text];
                                      }
                                  };

                                  
                                  [alert show];
                                  

                                  return ;
                              }
                              
                              //注册过
                              self.isAccountVerified = YES;//弹出密码框
                              //首次使用 让用户选择是否设置密码
                              if ([_loginManager.is_first_install isEqualToString:@"0"]) {
                                  LeftAlignAlertView *alert = [[LeftAlignAlertView alloc]initWithTitle:@"温馨提示"
                                                                                               message:@"您尚未登录过和教育平台，是否先设置密码？"
                                                                                              delegate:self
                                                                                     cancelButtonTitle:@"暂不"
                                                                                     otherButtonTitles:@"好的", nil];
                                  alert.buttonBlock = ^(NSInteger buttonIndex){
                                      if (buttonIndex == 1) {
                                          [self getPasswordClicked];
                                      }
                                  };
                                  
                                  [alert show];
                              }else{
                                  [self removeWaitingView];
                                  //如果是自动登录，则自动填充密码开始登录
                                  if (_autoModel) {
                                      _passwordView.text = _autoModel.passWord;
                                      _loginManager.user_type = _autoModel.userType;
                                      _passwordView.isRightHidden = YES;
                                      [self startLogin];
                                  }
                              }
                              

                              
                              
                              
                              
                          }else{
                              [self removeLaunchImage];
                              _autoModel = nil;
                              [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                          }
                      }
                         failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                             [self removeLaunchImage];
                             [self removeWaitingView];
                             _autoModel = nil;
                             [PubllicMaskViewHelper showTipViewWith:@"网络异常" inSuperView:self.view withDuration:1];
                         }];
}

//登录
- (void)startLogin
{
    NSString *login_type    = _isPasswordType ? @"1" : @"2";   //1密码 2验证码
    NSString *password      = _isPasswordType ? _passwordView.text : _codeView.text;
    
    [self showWaitingView];
    [_loginManager startLoginWithAccount:_accountView.text
                                password:password
                              login_type:login_type
                         loginCompletion:^(BOOL isSuccess, NSString *msg) {
                             [self removeWaitingView];
                             [self removeLaunchImage];
                             _autoModel = nil;
                             
                             if (isSuccess) {
                                 //更新头像
                                 [_iconView setNewImage:kDefaultIcon WithSpeWith:1 withDefaultImg:kDefaultIcon];
                                 //跳转主页面
                                 PJTabBarController* vc = [[PJTabBarController alloc]init];
                                 [self.navigationController pushViewController:vc animated:YES];
                                 
                                 //如果之前因为没有历史记录隐藏了下拉按钮，登录成功后显示
                                 if (_accountView.isRightHidden) {
                                     _accountView.isRightHidden = NO;
                                 }
                                 
                             }else{
                                 [PubllicMaskViewHelper showTipViewWith:msg inSuperView:self.view withDuration:1];
                             }
    }];
}

//自动登录
- (void)autoLogin
{
    //第一次登录
    if (![[NSUserDefaults standardUserDefaults] objectForKey:IS_FIRST_LAUNCH]) {
        return;
    }
    
    _autoModel = [AutoLoginModel obtain];
    
    if (!_autoModel) {//自动登录账号不存在
        _launchImageView.isFinishLogin = YES;
    }else{
        _accountView.text = _autoModel.userName;
        [self startVerifyAccount];
    }
    
}

#pragma mark -HistoryUserViewDelegate
- (void)onSelectContactWith:(NSString *)account withPwd:(NSString *)pwd withUrl:(NSString *)url
{
    if (_isAccountVerified && ![_accountView.text isEqualToString:account]) {
            self.isAccountVerified = NO;
    }

    [_iconView setNewImage:url WithSpeWith:1 withDefaultImg:kDefaultIcon];
    self.accountView.text  = account;
    self.passwordView.text = pwd;
    
    //安全起见，切换隐藏眼睛图标
    if (_passwordView.rightButton.selected) { //被选中表示可见
        _passwordView.rightButton.selected = NO;
        _passwordView.textField.secureTextEntry = YES;
    }
    _passwordView.isRightHidden = YES;
}

- (void)onRemoveSelf
{
//    if (IsArrEmpty([sqliteADO queryAllUser])) { //如果历史记录全部清空，隐藏下拉按钮
//        _accountView.isRightHidden = YES;
//    }
}

- (void)onDeleteContact:(NSString *)account
{
//    [sqliteADO deleteUserWithName:account];

}

#pragma mark -porperites
//是否验证过账号
- (void)setIsAccountVerified:(BOOL)isAccountVerified
{
    _isAccountVerified = isAccountVerified;
    
    //改按登录钮&下一步标题和位置
    [self.confrimButton setTitle:isAccountVerified?@"登录":@"下一步" forState:UIControlStateNormal];
    //验证完会多出一个输入框，按钮下移一个输入框的距离
    self.confrimButton.top = self.accountView.bottom + kButtonSpaceH + (isAccountVerified ? kTextH : 0);
    
    //切换登录方式和获取密码隐藏/显示
    self.changeTypeButton.hidden  = !isAccountVerified;
    self.getPasswordbutton.hidden = !isAccountVerified;
    
    //隐藏验证码输入框
    self.codeView.hidden = YES;
    self.codeView.text = nil;
    
    //隐藏/显示密码输入框
    self.passwordView.hidden = !isAccountVerified;
    
    //默认是密码登录
    _isPasswordType = YES;
    
}

//如果已经验证过账号，再改动账号需要重新验证
- (void)accountChanged
{
    if (_isAccountVerified) {
        self.isAccountVerified = NO;
        _codeView.text = nil;
    }
    _passwordView.text = nil;
    _passwordView.isRightHidden = NO;
}

- (void)removeLaunchImage
{
    if (_launchImageView) {
        _launchImageView.isFinishLogin = YES;
    }
}

- (void)showWaitingView
{
    if (_launchImageView) {
        return;
    }
    [super showWaitingView];
}

#pragma mark -键盘
//收起键盘
- (void)resignKeyboard
{
    [self.accountView.textField resignFirstResponder];
    [self.passwordView.textField resignFirstResponder];
    [self.codeView.textField resignFirstResponder];
}

//键盘通知
- (void)keyboardNotification:(NSNotification *)noti
{
    BOOL isShow = [noti.name isEqualToString:UIKeyboardWillShowNotification]; //键盘弹出还是收回
    self.view.top = isShow ? -100 : 0;
}

//添加通知
- (void)addNotification
{
    //键盘通知
    if (iPhone4) { //4屏幕小，键盘会遮挡输入框
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    //注册成功通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerSuccessNotification:) name:kRegisterSuccessNotification object:nil];
}

- (void)registerSuccessNotification:(NSNotification *)noti
{
    RegisterModel *registerModel = [RegisterModel shared];
    _passwordView.text = registerModel.password;
    
    //该通知有两种情况  注册成功 和 找回密码
    //注册成功 以及 找回密码同时账号有变化 的情况下要重新验证
    if (registerModel.modelClass==1 || (registerModel.modelClass==2 && ![_accountView.text isEqualToString:registerModel.account])) { //1是注册成功  2是找回密码
        
        _accountView.text = registerModel.account;
        self.isAccountVerified = NO;
        [self startVerifyAccount]; //开始验证账号
    }


}

- (void)pushToRegister:(NSString *)defaultPhone
{
    RegisterNewController *vc = [RegisterNewController new];
    vc.phoneNum = defaultPhone;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -setUI
- (void)setUI
{
    //广告页
    [self launchImageView];
    //取消后退按钮
    [backBtn removeFromSuperview];
    //注册按钮
    [self registerButton];
    //头像
    [self iconCircleView];
    //确认按钮
    [self confrimButton];
    
    //添加通知
    [self addNotification];
    
    //游客功能屏蔽，默认都是非游客
    //[LoginUserUtil setIsVisitor:NO];
}

- (LaunchImageView *)launchImageView
{
    //第一次登录不显示广告页，显示滚动页
    if (![[NSUserDefaults standardUserDefaults] objectForKey:IS_FIRST_LAUNCH]) {
        
        [self.navigationController pushViewController:[NewFeatureViewController new] animated:NO];
        
        return nil;
    }
    
    if (!_launchImageView) {
        self.view.userInteractionEnabled = NO;
        
        _launchImageView = [[LaunchImageView alloc]initWithFrame:MAIN_FRAME];
        
        typeof(self) __weak weakSelf = self;
        _launchImageView.removeHandle = ^{
            [weakSelf.launchImageView removeFromSuperview];
            weakSelf.launchImageView = nil;
            weakSelf.view.userInteractionEnabled = YES;
        };
        
        [self.view addSubview:_launchImageView];
    }
    return _launchImageView;
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:MAIN_FRAME];
        _backgroundView.backgroundColor = VcBackgroudColor;
        [self.view addSubview:_backgroundView];
        [self.view sendSubviewToBack:_backgroundView];
        
        //添加手势
        _backgroundView.userInteractionEnabled = YES;
        [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)]];
    }
    return _backgroundView;
}

- (UIButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [[UIButton alloc]initWithFrame:CGRectMake(MAIN_WIDTH-100-20, 0, 100, 30)];
        _registerButton.centerY = title.centerY;
        _registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerClicked) forControlEvents:UIControlEventTouchUpInside];
        [navigationBG addSubview:_registerButton];
    }
    return _registerButton;
    
}

- (UIView *)iconCircleView
{
    if (!_iconCircleView) {
        
        CGFloat y = navigationBG.bottom + MAIN_HEIGHT*0.046;
        CGFloat w = MAIN_WIDTH*0.24;
        
        _iconCircleView = [[UIView alloc]initWithFrame:CGRectMake((MAIN_WIDTH-w)/2, y, w, w)];
        _iconCircleView.backgroundColor = [UIColor whiteColor];
        _iconCircleView.layer.cornerRadius = w/2;
        _iconCircleView.layer.borderColor = [UIColor colorWithHexString:@"#D5D5D5"].CGColor;
        _iconCircleView.layer.borderWidth = 0.5;
        [self.backgroundView addSubview:_iconCircleView];
        
        
        _iconView = [[ClassIconImageView alloc]initWithFrame:CGRectMake(2.5, 2.5, w-5, w-5)];
        [_iconView setNewImage:kDefaultIcon WithSpeWith:1 withDefaultImg:kDefaultIcon];
        [_iconCircleView addSubview:_iconView];
    }
    return _iconCircleView;
}

- (LoginTextView *)accountView
{
    if (!_accountView) {
        kTextH = MAIN_HEIGHT*0.086;
        CGFloat y = navigationBG.bottom +MAIN_HEIGHT*0.23;
        
        _accountView = [LoginTextView createAccountTextViewWithFrame:CGRectMake(0, y, MAIN_WIDTH, kTextH)];
        [_accountView.rightButton addTarget:self action:@selector(historyListClicked) forControlEvents:UIControlEventTouchUpInside];
        [_accountView.textField addTarget:self action:@selector(accountChanged) forControlEvents:UIControlEventEditingChanged];
        
//        //没有历史记录不显示下拉按钮
//        if (IsArrEmpty([sqliteADO queryAllUser])) {
//            _accountView.isRightHidden = YES;
//        }
        
        [self.backgroundView addSubview:_accountView];
    }
    return _accountView;
}

- (LoginTextView *)passwordView
{
    if (!_passwordView) {
        _passwordView = [LoginTextView createPasswordTextViewWithFrame:CGRectMake(0, self.accountView.bottom, MAIN_WIDTH, kTextH)];
        _passwordView.hidden = YES;
        [self.backgroundView addSubview:_passwordView];
    }
    return _passwordView;
}

- (LoginTextView *)codeView
{
    if (!_codeView) {
        _codeView = [LoginTextView createCodeTextViewWithFrame:self.passwordView.frame];
        [_codeView.rightButton addTarget:self action:@selector(codeClicked) forControlEvents:UIControlEventTouchUpInside];
        _codeView.hidden = YES;
        [self.backgroundView addSubview:_codeView];
    }
    return _codeView;
}

- (LoginButton *)confrimButton
{
    if (!_confrimButton) {
        
        kButtonSpaceH = MAIN_HEIGHT * 0.102;
        
        _confrimButton = [[LoginButton alloc]initWithFrame:CGRectMake(10, self.accountView.bottom+kButtonSpaceH, MAIN_WIDTH-20, MAIN_HEIGHT*0.078)];
        [_confrimButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_confrimButton addTarget:self action:@selector(confrimClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:_confrimButton];
        
    }
    return _confrimButton;
}

- (UIButton *)changeTypeButton
{
    if (!_changeTypeButton) {
        _changeTypeButton = [[UIButton alloc]initWithFrame:CGRectMake(15, self.accountView.bottom+kTextH, 120, kButtonSpaceH)];
        [_changeTypeButton setTitle:@"通过短信登录" forState:UIControlStateNormal];
        [_changeTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_changeTypeButton addTarget:self action:@selector(changeTypeClicked:) forControlEvents:UIControlEventTouchUpInside];
        _changeTypeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _changeTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.backgroundView addSubview:_changeTypeButton];
        
    }
    return _changeTypeButton;
}

- (UIButton *)getPasswordbutton
{
    if (!_getPasswordbutton) {
        _getPasswordbutton = [[UIButton alloc]initWithFrame:CGRectMake(MAIN_WIDTH-15-100, self.accountView.bottom+kTextH, 100, kButtonSpaceH)];
        [_getPasswordbutton setTitle:@"获取密码?" forState:UIControlStateNormal];
        [_getPasswordbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_getPasswordbutton addTarget:self action:@selector(getPasswordClicked) forControlEvents:UIControlEventTouchUpInside];
        _getPasswordbutton.titleLabel.font = [UIFont systemFontOfSize:13];
        _getPasswordbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.backgroundView addSubview:_getPasswordbutton];
    }
    return _getPasswordbutton;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
