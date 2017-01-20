//
//  BaseViewController.m
//  xxt_xj
//
//  Created by Points on 13-11-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
//#import "EmptyTipView.h"
//#import "OTSEventItem.h"
//#import "OTSEventLoggerEngine.h"


//static UIColor* kNavigationBarColor = nil;
static UIFont* kNavigationBarTitleFont = nil;

@interface BaseViewController ()<UIGestureRecognizerDelegate>
//@property (nonatomic, retain) EmptyTipView *emptyTipView;

@end

@implementation BaseViewController

+(void)load{
    kCommonColorHighLight = UIColorFromRGB(0x08C875);
    kNavigationBarTitleFont = [UIFont boldSystemFontOfSize:19];
    //kNavigationBarColor = kCommonColorHighLight;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.m_delegate = nil;
}

- (id)init
{
    if(self = [super init])
    {
        isRequest = YES;
//        navigationBG = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, MAIN_WIDTH, HEIGHT_NAVIGATION+DISTANCE_TOP)];
//        navigationBG.userInteractionEnabled = YES;
//        [navigationBG setBackgroundColor:kCommonColorHighLight];
//        [self.view setBackgroundColor:[UIColor whiteColor]];
//        [self.view addSubview:navigationBG];
//        
//        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backBtn setFrame:CGRectMake(0,DISTANCE_TOP,56-5,46-5)];
//        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 10)];
//        [backBtn setBackgroundColor:[UIColor clearColor]];
//        [backBtn setImage:[UIImage imageNamed:@"news_back@2x.png"] forState:UIControlStateNormal];
//        [backBtn setImage:[UIImage imageNamed:@"news_back@2x.png"] forState:UIControlStateHighlighted];
//        [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [navigationBG addSubview:backBtn];
//        
//        m_rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [m_rightBtn addTarget:self action:@selector(settingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [m_rightBtn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
//        [m_rightBtn setFrame:CGRectMake(MAIN_WIDTH-40,7,30,30)];
//        [m_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [m_rightBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateHighlighted];
//        [m_rightBtn setBackgroundColor:[UIColor clearColor]];
//        [navigationBG addSubview:m_rightBtn];
//        
//        title= [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backBtn.frame)+10, DISTANCE_TOP+5, CGRectGetMinX(m_rightBtn.frame)-20-CGRectGetMaxX(backBtn.frame), 34)];
//        [title setFont:kNavigationBarTitleFont];
//        [title setBackgroundColor:[UIColor clearColor]];
//        title.hidden = NO;
//        [title setText:self.title];
//        [title setTextAlignment:NSTextAlignmentCenter];
//        [title setTextColor:[UIColor whiteColor]];
//        [navigationBG addSubview:title];
//        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeToSliderView)];
//        leftSwipe.direction = UISwipeGestureRecognizerDirectionRight;
//        [self.view addGestureRecognizer:leftSwipe];
    }
    return self;
}

- (void)addKeyboardObserve;
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardObserve;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti;
{

}

- (void)keyboardWillHide:(NSNotification *)noti;
{

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[MobClick beginLogPageView:NSStringFromClass([self class])];
    
    // 集成OTS
//    OTSEventItem *item=[[OTSEventItem alloc] init];
//    item.eventType=PageEvent;//事件类型
//    item.operPageStatus=PageAppear;//操作状态
//    NSString* strName = title.text.length>0?title.text:@"无标题窗口";//titlelength>0?self.title:@"无标题窗口";
//    item.name = strName;//事件名称，便于理解记录，由用户自己定义
//    item.tag=NSStringFromClass([self class]);//事件唯一ID 根据app实际情况自行定义，确保唯一
//    [[OTSEventLoggerEngine shareEventLoggerEngine] addEventLogger:item];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:NSStringFromClass([self class])];
//    
//    // 集成OTS
//    OTSEventItem *item=[[OTSEventItem alloc] init];
//    item.eventType=PageEvent;//事件类型
//    item.operPageStatus=PageDisAppear;//操作状态
//    NSString* strName = title.text.length>0?title.text:@"无标题窗口";//titlelength>0?self.title:@"无标题窗口";
//    item.name = strName;
//    //item.name=NSStringFromClass([self class]);//事件名称,便于理解记录,用户自己定义
//    item.tag=NSStringFromClass([self class]);//事件唯一ID。根据app实际情况自行定义
//    [[OTSEventLoggerEngine shareEventLoggerEngine] 		addEventLogger:item];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//    [self.navigationController setNavigationBarHidden:YES];
//    [self.navigationController.navigationBar setHidden:YES];
    if(OS_ABOVE_IOS7)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    navigationBG = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, MAIN_WIDTH, HEIGHT_NAVIGATION+DISTANCE_TOP)];
    navigationBG.userInteractionEnabled = YES;
    [navigationBG setBackgroundColor:kCommonColorHighLight];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:navigationBG];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0,DISTANCE_TOP,56-5,46-5)];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 10)];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setImage:[UIImage imageNamed:@"news_back@2x.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"news_back@2x.png"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [navigationBG addSubview:backBtn];
    
    m_rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_rightBtn addTarget:self action:@selector(settingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [m_rightBtn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [m_rightBtn setFrame:CGRectMake(MAIN_WIDTH-40,7,30,30)];
    [m_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [m_rightBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateHighlighted];
    [m_rightBtn setBackgroundColor:[UIColor clearColor]];
    [navigationBG addSubview:m_rightBtn];

    title= [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backBtn.frame)+10, DISTANCE_TOP+5, CGRectGetMinX(m_rightBtn.frame)-20-CGRectGetMaxX(backBtn.frame), 34)];
    [title setFont:kNavigationBarTitleFont];
    [title setBackgroundColor:[UIColor clearColor]];
    title.hidden = NO;
    [title setText:self.title];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:[UIColor whiteColor]];
    [navigationBG addSubview:title];
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeToSliderView)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:leftSwipe];
}

- (void)resetBackBtnImage;
{
    [backBtn setFrame:CGRectMake(10,DISTANCE_TOP,46,46)];
    [backBtn setImage:[UIImage imageNamed:@"news_back"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"news_back"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setBackBtnHomeImage;
{
//    [backBtn setImage:[UIImage imageNamed:@"common_home"] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"common_home_down"] forState:UIControlStateHighlighted];
}




- (void)setTitle:(NSString *)atitle
{
    [super setTitle:atitle];
    title.text = atitle;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //SpeLog(@"%@  ======  didReceiveMemoryWarning",NSStringFromClass([self class]));
}

#pragma mark -BaseViewControllerDelegate

- (void)initView
{
    
}

- (void)initData
{
    
}

- (void)backBtnClicked
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"delete" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -public


- (void)showWaitingView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"更新中";
    hud.minSize  = CGSizeMake(80, 80);
    hud.margin = 10.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
//    [hud hide:YES afterDelay:10];
}

- (void)showWaitingViewWithMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.minSize  = CGSizeMake(80, 80);
    UIImageView *waitView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,80, 80)];
    [waitView setImage:[UIImage imageNamed:@"Icon@2x"]];
    hud.customView = waitView;
    hud.margin = 10.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = message;
    [hud hide:YES afterDelay:100];
}

- (void)showWaitingViewWith:(int)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.minSize  = CGSizeMake(80, 80);
    UIImageView *waitView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,80, 80)];
    [waitView setImage:[UIImage imageNamed:@"Icon@2x"]];
    hud.customView = waitView;
    hud.margin = 10.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}

- (void)removeWaitingView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//- (void)removeEmptyView
//{
//    if([self.emptyTipView isDescendantOfView:self.view])
//    {
//        [self.emptyTipView removeFromSuperview];
//    }
//}

- (void)removeAllWaitingView {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)showEmptyIfNeedWithMessage:(NSString *)message noData:(BOOL)noData
{
//    if (noData) {
//        [self showEmptyWith:message];
//    } else {
//        [self removeEmptyView];
//    }
    
}

//- (void)showEmptyWith:(NSString *)tip
//{
//    [self removeEmptyView];
//    EmptyTipView *empty = [[EmptyTipView alloc]initWithFrame:CGRectMake(0, (is_iOS_7?64:44), MAIN_WIDTH, MAIN_HEIGHT - 64) WithTip:tip];
//    [empty setBackgroundColor:[UIColor whiteColor]];
//    self.emptyTipView = empty;
//    [empty release];
//    
//    if(![self.emptyTipView isDescendantOfView:self.view])
//    {
//        [self.view addSubview:self.emptyTipView];
//    }
//}

-(void)handleError:(NSString*)error
{
    //[PubllicMaskViewHelper showTipViewWith:error inSuperView:self.view withDuration:1];
}

- (void)removeBackBtn
{
    backBtn.hidden = YES;
}

- (void)setSliderBtn
{
    [backBtn setImage:nil forState:UIControlStateNormal];
    [backBtn setImage:nil forState:UIControlStateHighlighted];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:8];
    
//    ClassIconImageView *user = [[ClassIconImageView alloc]initWithFrame:CGRectMake(NAV_BUTTON_LEFT_OFFSET_X , DISTANCE_TOP+ 5, 34, 34)];
//    user.userInteractionEnabled = YES;
//    [user setNewImage:[LoginUserUtil headUrl] WithSpeWith:0.5 withDefaultImg:@"avatar_default@2x.png"];
//    [navigationBG addSubview:user];
    [navigationBG bringSubviewToFront:backBtn];
    
    UIImageView* user = [[UIImageView alloc]initWithFrame:CGRectMake(NAV_BUTTON_LEFT_OFFSET_X , DISTANCE_TOP+ 5, 34, 34)];
    [user setImage:[UIImage imageNamed:@"avatar_default@2x.png"]];
    self.userIconImageView = user;
}

- (void)updateUserImage:(NSString *)url {
//    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
//    [self.userIconImageView setNewImage:url WithSpeWith:0.5 withDefaultImg:nil];
}
- (void)sliderBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self.m_delegate onShowSliderView];
}

- (void)homeworkCome:(NSNotification *)noti
{
    
}

//设置
- (void)settingBtnClicked
{
    
}

- (CGSize )getStringheight:(UIFont *)font stringContent:(NSString *)string {
    //    CGSize stringSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(MAIN_WIDTH - 70, 40)];
    CGSize stringSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(MAIN_WIDTH - 70, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return stringSize;
}

- (void)showError
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showMsg:@"通讯失败，请检查网络是否正常！"];
}

- (void)showMsg:(NSString *)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}


#pragma mark - Private

//右滑
- (void)SwipeToSliderView
{
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(onBackAnaShowSliderView)])
    {
        [self.m_delegate onBackAnaShowSliderView];
    }
}

- (void)showCommentViewWithMessage:(NSString *)message;
{
    
}

- (void)removeCommentView;
{

}

- (void)hiddenKeyboardBtnAction:(id)sender {
    
}


#pragma mark -  甩屏

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return  UIInterfaceOrientationPortrait |
    UIInterfaceOrientationPortraitUpsideDown |
    UIInterfaceOrientationLandscapeLeft   |
    UIInterfaceOrientationLandscapeRight;
    
}

- (UIButton *)hiddenKeyboardBtn {
    if (!_hiddenKeyboardBtn) {
        _hiddenKeyboardBtn = [[UIButton alloc] init];
        [_hiddenKeyboardBtn addTarget:self action:@selector(hiddenKeyboardBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _hiddenKeyboardBtn.hidden = YES;
        [self.view addSubview:_hiddenKeyboardBtn];
    }
    return _hiddenKeyboardBtn;
}

-(void)loadInitialize{
    ;
}

@end
