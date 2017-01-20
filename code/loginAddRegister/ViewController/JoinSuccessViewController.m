//
//  JoinSuccessViewController.m
//  anhui
//
//  Created by 葛君语 on 2016/10/24.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "JoinSuccessViewController.h"
#import "LoginButton.h"
#import "RegisterModel.h"
#import "FontSizeUtil.h"

@interface JoinSuccessViewController ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UILabel *accountLabel;
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) LoginButton *confirmButton;

@property (nonatomic,assign) BOOL isPassAudit;

@end

@implementation JoinSuccessViewController

- (instancetype)initWithIsPassAudit:(BOOL)isPassAudit
{
    self = [super init];
    if (self) {
        _isPassAudit = isPassAudit;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"加入班级";
    
    self.view.backgroundColor = VcBackgroudColor;
    
    [backBtn removeFromSuperview];
    
    [self confirmButton];
}

#pragma mark -btnAction
- (void)confirmClicked
{
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

//取消滑动返回手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

#pragma mark -setUI
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT_NAVIGATION+DISTANCE_TOP+ 30, 200, 20)];
        _titleLabel.centerX = MAIN_WIDTH/2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = _isPassAudit ? @"恭喜您，加入班级成功！" : @"您的班级加入申请已提交";
        _titleLabel.textColor = [UIColor colorWithHexString:@"#009662"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, self.titleLabel.bottom, MAIN_WIDTH-70, 20)];
        _detailLabel.textColor = [UIColor grayColor];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.numberOfLines = 0;
        _detailLabel.contentMode = UIViewContentModeLeft;
        _detailLabel.text = _isPassAudit ? @"现在您可以使用以下账号登录客户端" : @"      为了更好地为您提供服务，平台将对您的信息进行审核，审核通过后，您就可以使用和教育的完整功能了。\r\n      现在您可以使用以下账号登录客户端先行体验，并查询审核状态";
        
        //计算高度
        CGSize size = [FontSizeUtil sizeOfString:_detailLabel.text
                                        withFont:_detailLabel.font
                                       withWidth:_detailLabel.width];
        _detailLabel.height = size.height +5;
        
        
        [self.view addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UILabel *)accountLabel
{
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, self.detailLabel.bottom, 150, 20)];
        _accountLabel.font = [UIFont systemFontOfSize:12];
        _accountLabel.textColor = [UIColor grayColor];
        _accountLabel.contentMode = UIViewContentModeLeft;
        _accountLabel.text = [NSString stringWithFormat:@"账号：%@",[RegisterModel shared].account];
        [self.view addSubview:_accountLabel];
    }
    return _accountLabel;
}

- (UIView *)whiteView
{
    if (!_whiteView) {
        
        CGFloat y = HEIGHT_NAVIGATION+DISTANCE_TOP+20;
        _whiteView = [[UIView alloc]initWithFrame:CGRectMake(15, y, MAIN_WIDTH-30, self.accountLabel.bottom+10-y)];
        _whiteView.layer.cornerRadius = 5;
        _whiteView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_whiteView];
        [self.view sendSubviewToBack:_whiteView];
        
    }
    return _whiteView;
}

- (LoginButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[LoginButton alloc]initWithFrame:CGRectMake(10, self.whiteView.bottom+70, MAIN_WIDTH-20, MAIN_HEIGHT*0.079)];
        
        RegisterModel *model = [RegisterModel shared];
        
        if (model.modelClass == 1) { //注册
            [_confirmButton setTitle:@"立即登录" forState:UIControlStateNormal];
        }else if (model.modelClass == 3){ //登录后加入班级
            [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
        }
        
        [_confirmButton addTarget:self action:@selector(confirmClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

@end
