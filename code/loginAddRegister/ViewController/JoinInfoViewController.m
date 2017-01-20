//
//  JoinInfoViewController.m
//  anhui
//
//  Created by 葛君语 on 2016/10/24.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "JoinInfoViewController.h"
#import "LoginTextView.h"
#import "LoginButton.h"
#import "RegisterModel.h"
#import "JoinSuccessViewController.h"
#import "SmsCodeViewController.h"
#import "CustomSelectView.h"
#import "HttpLoginAndRegister.h"

@interface JoinInfoViewController ()

@property (nonatomic,strong) LoginTextView *nameView;
@property (nonatomic,strong) LoginTextView *selectView;
@property (nonatomic,strong) UILabel *errorLabel;
@property (nonatomic,strong) LoginButton *confirmButton;

@property (nonatomic,assign) BOOL isTeacher;
@property (nonatomic,strong) NSArray *infoList;
@property (nonatomic,assign) NSInteger selectedIndex; //被选中的选项

@end

@implementation JoinInfoViewController

- (instancetype)initWithInfoList:(NSArray *)infoList isTeacher:(BOOL)isTeacher
{
    self = [super init];
    if (self) {
        self.infoList  = infoList;
        self.isTeacher = isTeacher;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _isTeacher ? @"教师信息设置" : @"家长信息设置";
    
    self.view.backgroundColor = VcBackgroudColor;
    
    [self confirmButton];

    //默认第一个被选中
    self.selectedIndex = 0;
}


#pragma mark -btnAction
- (void)confirmClicked
{
    [self.nameView.textField resignFirstResponder];

    if (IsStrEmpty(_nameView.text)) {
        [PubllicMaskViewHelper showTipViewWith:@"请输入姓名" inSuperView:self.view withDuration:1];
        return;
    }
    
    RegisterModel *registerModel = [RegisterModel shared];
    
    self.errorLabel.hidden = YES;
    
    [self showWaitingView];
    [LOGIN_REGISTER registerInfoNewWithName:_nameView.text
                                   itemid:registerModel.infoId
                                     type:(_isTeacher?@"1":@"3")
                                  classid:registerModel.classId
                                      tel:registerModel.account
                           successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                               [self removeWaitingView];
                               if (isSucceed) { //成功
                                   RegisterStatusModel *statusModel = [[RegisterStatusModel alloc]initWithDictionary:succeedResult];
                                   
                                   if ([statusModel.status isEqualToString:@"3"]) { //3第二家长
                                       statusModel.studentName = _nameView.text;
                                       SmsCodeViewController *vc = [[SmsCodeViewController alloc]initWithVerifySecondParent:statusModel];
                                       [self.navigationController pushViewController:vc animated:YES];
                                       
                                   }else{ //1免审核 2审核中
                                       BOOL isPassAudit = [statusModel.status isEqualToString:@"1"];
                                       JoinSuccessViewController *vc = [[JoinSuccessViewController alloc]initWithIsPassAudit:isPassAudit];
                                       [self.navigationController pushViewController:vc animated:YES];
                                       
                                   }
                               }else{ //失败
                                   if (_isTeacher) {
                                       [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                                   }else{
                                       self.errorLabel.hidden = NO;
                                   }
                               }
                           } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                               [self removeWaitingView];
                               [PubllicMaskViewHelper showTipViewWith:@"网络异常" inSuperView:self.view withDuration:1];
                              }];
}

- (void)selectClicked:(UIButton *)sender
{
    CustomSelectView *view = [[CustomSelectView alloc]initWithTitle:(_isTeacher?@"请选择科目":@"请选择称呼")];
    
    [_infoList enumerateObjectsUsingBlock:^(ItemInfoModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [view addButtonWithTitle:model.infoDesc];
    }];
    
    view.selectedIndex = _selectedIndex;
    
    view.clickHandle = ^(NSInteger buttonIndex){
        self.selectedIndex = buttonIndex;
    };

    [view show];
}

#pragma mark-键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nameView.textField resignFirstResponder];
}


- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    ItemInfoModel *model = _infoList[selectedIndex];
    [RegisterModel shared].infoId = model.infoId;
    [_selectView.rightButton setTitle:model.infoDesc forState:UIControlStateNormal];
}

#pragma mark -setUI
- (LoginTextView *)nameView
{
    if (!_nameView) {
        _nameView = [[LoginTextView alloc]initWithFrame:CGRectMake(0, HEIGHT_NAVIGATION+DISTANCE_TOP+10, MAIN_WIDTH, MAIN_HEIGHT*0.079)];
        _nameView.textField.keyboardType = UIKeyboardTypeDefault;
        _nameView.textField.placeholder  = _isTeacher ? @"请输入您的姓名" : @"请输入您孩子的姓名";
        [self.view addSubview:_nameView];
    }
    return _nameView;
}

- (LoginTextView *)selectView
{
    if (!_selectView) {
        _selectView = [LoginTextView createSelectTextViewWithFrame:CGRectMake(0, self.nameView.bottom, MAIN_WIDTH, MAIN_HEIGHT*0.079)];
        _selectView.topLineHidden = YES;
        _selectView.textField.placeholder = _isTeacher ? @"请选择任课科目" : @"请选择您与孩子的称呼";
        [_selectView.rightButton addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_selectView];
    }
    return _selectView;
}

- (LoginButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[LoginButton alloc]initWithFrame:CGRectMake(15, self.selectView.bottom+50, MAIN_WIDTH-30, MAIN_HEIGHT*0.079)];
        [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}
- (UILabel *)errorLabel
{
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.confirmButton.bottom+10, 300, 20)];
        _errorLabel.centerX = MAIN_WIDTH/2;
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.textColor = [UIColor colorWithHexString:@"#eb4525"];
        _errorLabel.font = [UIFont systemFontOfSize:13];
        _errorLabel.text = @"抱歉，系统未查询到您的孩子信息，请重新输入";
        [self.view addSubview:_errorLabel];
    }
    return _errorLabel;
}

@end
