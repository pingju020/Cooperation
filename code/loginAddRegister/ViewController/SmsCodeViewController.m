//
//  SmsCodeViewController.m
//  anhui
//
//  Created by 葛君语 on 2016/10/24.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "SmsCodeViewController.h"
#import "LoginTextView.h"
#import "LoginButton.h"
#import "SelectRoleViewController.h"
#import "RegisterModel.h"
#import "JoinSuccessViewController.h"
#import "HttpLoginAndRegister.h"

@interface SmsCodeViewController ()
@property (nonatomic,strong) LoginTextView *codeView;
@property (nonatomic,strong) LoginButton *confirmButton;
@property (nonatomic,strong) UILabel *errorLabel;
@property (nonatomic,strong) UILabel *tipTitleLabel;
@property (nonatomic,strong) UILabel *tipDescLabel;

@property (nonatomic,assign) NSInteger codeClass; //0 班级码  1 验证第二家长

@property (nonatomic,strong) RegisterStatusModel *statusModel; //验证第二家长需要的数据

@end

@implementation SmsCodeViewController

#pragma mark -初始化

- (instancetype)initWithClassCode
{
    self = [super init];
    if (self) {
        _codeClass = 0;
        self.title = @"输入班级码";
    }
    return self;
}

- (instancetype)initWithVerifySecondParent:(RegisterStatusModel *)statusModel
{
    self = [super init];
    if (self) {
        _codeClass = 1;
        self.title = @"输入验证码";
        _statusModel = statusModel;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = VcBackgroudColor;
    [self tipDescLabel];
    
}

#pragma mark -btnAction
- (void)confirmClicked
{
    [self.codeView.textField resignFirstResponder];
    
    self.errorLabel.hidden = YES;
    
    if (_codeClass == 0) {
        [self verifyClassCode];
    }else if (_codeClass == 1){
        [self verifySecondParentCode];
    }
    
    
}

#pragma mark -验证班级码
- (void)verifyClassCode
{
    NSString *classId = _codeView.text;
    
    if (IsStrEmpty(classId)) {
        [PubllicMaskViewHelper showTipViewWith:@"请输入班级码" inSuperView:self.view withDuration:1];
        return;
    }
    
    [self showWaitingView];
    [LOGIN_REGISTER verifyClassCode:classId
                   successedBlock:^(NSDictionary *succeedResult,BOOL isSucceed) {
                       [self removeWaitingView];
                       _errorLabel.hidden = isSucceed;
                       
                       if (isSucceed) {
                           RegisterModel *model =[RegisterModel shared];
                           model.className   = succeedResult[@"clazz"];
                           model.gradeId     = succeedResult[@"grade"];
                           model.classId     = classId;
                           
                           SelectRoleViewController *vc = [[SelectRoleViewController alloc]initWithIsSelectRole:YES];
                           [self.navigationController pushViewController:vc animated:YES];
                           
                       }
                   }
                      failedBlock:^(AFHTTPSessionManager *session, NSError *error) {
                          [self removeWaitingView];
                          [PubllicMaskViewHelper showTipViewWith:@"网络异常" inSuperView:self.view withDuration:1];
                      }];
}

#pragma mark -验证第二家长
- (void)verifySecondParentCode
{
    if (IsStrEmpty(_codeView.text)) {
        [PubllicMaskViewHelper showTipViewWith:@"请输入验证码" inSuperView:self.view withDuration:1];
        return;
    }
    
    RegisterModel *registerModel = [RegisterModel shared];
    
    [self showWaitingView];
    [LOGIN_REGISTER verifySecondParentCodeWithTel:registerModel.account
                                          phone:_statusModel.phone
                                           code:_codeView.text
                                        classid:registerModel.classId
                                 successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                                     if (isSucceed) {
                                         [self registerSecondParent];//验证完成注册第二家长
                                         
                                     }else{
                                         [self removeWaitingView];
                                         self.errorLabel.hidden = NO;
                                     }
                                     
                                 }
                                    failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                                        [self removeWaitingView];
                                        [PubllicMaskViewHelper showTipViewWith:@"网络异常" inSuperView:self.view withDuration:1];
                                    }];
}

//注册第二家长
- (void)registerSecondParent
{
    RegisterModel *registerModel = [RegisterModel shared];
    
    [LOGIN_REGISTER registerSecondParentWithName:_statusModel.studentName
                                          itemid:registerModel.infoId
                                            type:@"3"
                                         classid:registerModel.classId
                                             tel:registerModel.account
                                           phone:_statusModel.phone
                                  successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                                      [self removeWaitingView];
                                      if (isSucceed) {
                                          JoinSuccessViewController *vc = [[JoinSuccessViewController alloc]initWithIsPassAudit:YES];
                                          [self.navigationController pushViewController:vc animated:YES];
                                          
                                      }else{
                                          [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                                      }
                                  }
                                     failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                                         [self removeWaitingView];
                                         [PubllicMaskViewHelper showTipViewWith:@"网络异常" inSuperView:self.view withDuration:1];
                                     }];
}

#pragma mark -键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_codeView.textField resignFirstResponder];
}

//返回相关
- (void)backBtnClicked
{
    if (_codeClass == 0) { //输入班级码 放回上以页面
        [super backBtnClicked];
        
    }else if (_codeClass == 1){  //注册第二家长  直接返回登录页面/主页面
        
        RegisterModel *model = [RegisterModel shared];
        if (model.modelClass == 1) { //注册
            [[NSNotificationCenter defaultCenter]postNotificationName:kRegisterSuccessNotification object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];//返回登录页面
            
        }else if (model.modelClass == 3){ //登录后加入班级
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull subVC, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 1) {
                    [self.navigationController popToViewController:subVC animated:YES];          //返回主页面
                    *stop = YES;
                }
                
            }];
            
        }
        
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (_codeClass == 1) {
        return NO;
    }
    return YES;
}


#pragma mark -UI
- (LoginTextView *)codeView
{
    if (!_codeView) {
        _codeView = [[LoginTextView alloc]initWithFrame:CGRectMake(0, navigationBG.bottom+10, MAIN_WIDTH, MAIN_HEIGHT*0.079)];
        
        if (_codeClass == 0) {
            _codeView.textField.placeholder = @"请输入班级码";
        }else if (_codeClass == 1){
            _codeView.textField.placeholder = @"请输入验证码";
        }
        
        _codeView.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:_codeView];
    }
    return _codeView;
}

- (LoginButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[LoginButton alloc]initWithFrame:CGRectMake(10, self.codeView.bottom+40, MAIN_WIDTH-20, MAIN_HEIGHT*0.079)];
        [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
        
    }
    return _confirmButton;
}

- (UILabel *)errorLabel
{
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.confirmButton.bottom+10, 200, 20)];
        _errorLabel.centerX = MAIN_WIDTH/2;
        _errorLabel.textColor = [UIColor colorWithHexString:@"#eb4525"];
        _errorLabel.font = [UIFont systemFontOfSize:13];
        
        if (_codeClass == 0) {
             _errorLabel.text = @"您输入的班级码有误，请重新输入";
        }else if (_codeClass == 1){
             _errorLabel.text = @"您输入的验证码有误，请重新输入";
        }
       
        _errorLabel.hidden = YES;
        [self.view addSubview:_errorLabel];
    }
    return _errorLabel;
}

- (UILabel *)tipTitleLabel
{
    if (!_tipTitleLabel) {
        _tipTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.errorLabel.bottom+50, 200, 18)];
        _tipTitleLabel.centerX = MAIN_WIDTH/2;
        _tipTitleLabel.font = [UIFont systemFontOfSize:15];
        _tipTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        if (_codeClass == 0) {
            _tipTitleLabel.text = @"小提示：如何获取班级码？";
        }else if (_codeClass == 1){
            _tipTitleLabel.text = @"小提示：如何获取验证码？";
        }
        
        [self.view addSubview:_tipTitleLabel];
    }
    return _tipTitleLabel;
}

- (UILabel *)tipDescLabel
{
    if (!_tipDescLabel) {
        _tipDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.tipTitleLabel.bottom, MAIN_WIDTH-30, 80)];
        _tipDescLabel.textColor = [UIColor colorWithHexString:@"#a9a7a8"];
        _tipDescLabel.font = [UIFont systemFontOfSize:15];
        _tipDescLabel.numberOfLines = 0;
        
        if (_codeClass == 0) {
           _tipDescLabel.text = @"您可以联系孩子所在班级的老师或其他家长，通过客户端【通话】界面右上角的【更多】菜单来发送班级码";
        }else if (_codeClass == 1){
            NSString *phoneCode = [_statusModel.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]; //号码中间4位换成*
            NSString *desc = [NSString stringWithFormat:@"由于%@已绑定了一个家长%@，请您联系TA查收短信，并请在该界面中输入短信中的验证码数字。",_statusModel.studentName,phoneCode];
            _tipDescLabel.text = desc;
        }
        
        
        
        [self.view addSubview:_tipDescLabel];
    }
    return _tipDescLabel;
}
@end
