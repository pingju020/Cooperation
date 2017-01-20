//
//  SelectRoleViewController.m
//  anhui
//
//  Created by 葛君语 on 2016/10/24.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "SelectRoleViewController.h"
#import "JoinClassButton.h" //Register_school
#import "LoginTextView.h"
#import "LoginButton.h"
#import "RegisterModel.h"
#import "JoinInfoViewController.h"
#import "CustomSelectView.h"
#import "HttpLoginAndRegister.h"


@interface SelectRoleViewController ()
@property (nonatomic,strong) UIView *blackTopView;
@property (nonatomic,strong) JoinClassButton *schoolView;     //标题
@property (nonatomic,strong) LoginTextView *roleView;         //选择角色
@property (nonatomic,strong) LoginTextView *gradeView;        //选择年级
@property (nonatomic,strong) LoginTextView *classView;        //选择班级
@property (nonatomic,strong) LoginButton *confirmButton;      //确认按钮

@property (nonatomic,assign) BOOL isTeacher;
@property (nonatomic,assign) BOOL isSelectRole;


@property (nonatomic,strong) GradeListModel *selectedGradeModel; //被选中的年级
@property (nonatomic,strong) ClassListModel *selectedClassModel; //被选中的班级

@end

@implementation SelectRoleViewController
- (instancetype)initWithIsSelectRole:(BOOL)isSelectRole
{
    self = [super init];
    if (self) {
        _isSelectRole = isSelectRole;
        _isTeacher = YES; //默认是老师
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _isSelectRole ? @"选择角色" : @"选择年级和班级";
    self.view.backgroundColor = VcBackgroudColor;
    [self confirmButton];
    [self schoolView];

}


#pragma mark -btnAction
- (void)confirmClicked
{
    if (_isSelectRole) {  //选择角色页面
        [self requestItemInfoList]; //请求信息列表
        
    }else{  //选择年级和班级页面
        [self pustToSelectRole]; //跳转到选择角色页面
        

    }
    
    
}

- (void)selectRoleClicked:(UIButton *)sender
{
    CustomSelectView *view = [[CustomSelectView alloc]initWithTitle:@"请选择您的角色" buttonTitles:@"教师",@"家长", nil];
    
    view.selectedIndex = _isTeacher ? 0 : 1 ;
    
    view.clickHandle = ^(NSInteger buttonIndex){
        _isTeacher = buttonIndex == 0;
        [_roleView.rightButton setTitle:(_isTeacher?@"教师":@"家长") forState:UIControlStateNormal];
    };
    
    [view show];

}

- (void)selectGradeClicked:(UIButton *)sender
{
    CustomSelectView *view = [[CustomSelectView alloc]initWithTitle:@"请选择年级"];
    
    for (GradeListModel *model in _gradeList) {
       [view addButtonWithTitle:model.name];
    }
    
    view.selectedIndex = [_gradeList indexOfObject:_selectedGradeModel];
    
    view.clickHandle = ^(NSInteger buttonIndex){
        self.selectedGradeModel = _gradeList[buttonIndex];
    };
    
    [view show];

}

- (void)selectClassClicked:(UIButton *)sender
{
    
    NSArray *classList =_selectedGradeModel.classList;
    
    if (classList.count == 0) {
        [PubllicMaskViewHelper showTipViewWith:@"没有班级" inSuperView:self.view withDuration:1];
        return;
    }
    
    CustomSelectView *view = [[CustomSelectView alloc]initWithTitle:@"请选择班级"];
    
    for (ClassListModel *model in classList) {
        [view addButtonWithTitle:model.name];
    }

    view.selectedIndex = [classList indexOfObject:_selectedClassModel];
    
    view.clickHandle = ^(NSInteger buttonIndex){
        self.selectedClassModel = classList[buttonIndex];
    };
    
    [view show];
    
}

#pragma mark -request
- (void)requestItemInfoList
{
    [self showWaitingView];
    [LOGIN_REGISTER getItemInfoList:(_isTeacher?@"1":@"2")
                              Grade:[RegisterModel shared].gradeId
                     successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                         [self removeWaitingView];
                         if (isSucceed) {
                             NSArray *infoList = [ItemInfoModel parsingItemInfoListWithList:succeedResult[@"list"]];
                             
                             if (IsArrEmpty(infoList)) {
                                 [PubllicMaskViewHelper showTipViewWith:@"请求数据为空" inSuperView:self.view withDuration:1];
                                 return ;
                             }
                             
                             JoinInfoViewController *vc = [[JoinInfoViewController alloc]initWithInfoList:infoList isTeacher:_isTeacher];
                             [self.navigationController pushViewController:vc animated:YES];
                         }else{
                             [PubllicMaskViewHelper showTipViewWith:succeedResult[@"desc"] inSuperView:self.view withDuration:1];
                         }
                     }
                        failedBlock:^(AFHTTPSessionManager *session, NSError *error) {
                            [self removeWaitingView];
                            [PubllicMaskViewHelper showTipViewWith:@"网络异常" inSuperView:self.view withDuration:1];
                        }];
}

- (void)pustToSelectRole
{
    if (!_selectedClassModel) {
        [PubllicMaskViewHelper showTipViewWith:@"请选择班级" inSuperView:self.view withDuration:1];
        return;
    }
    
    RegisterModel *model = [RegisterModel shared];
    
    model.gradeId   = _selectedGradeModel.gradeId;
    model.classId   = _selectedClassModel.classId;
    model.className = [NSString stringWithFormat:@"%@%@%@",model.schoolName,_selectedGradeModel.name,_selectedClassModel.name];
    
    SelectRoleViewController *vc = [[SelectRoleViewController alloc]initWithIsSelectRole:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -赋值
- (void)setGradeList:(NSArray *)gradeList
{
    _gradeList = gradeList;
    
    //第一个值作为选择框的默认值
    self.selectedGradeModel = [gradeList firstObject];

}

//选中年级
- (void)setSelectedGradeModel:(GradeListModel *)selectedGradeModel
{
    _selectedGradeModel = selectedGradeModel;

    //显示年级名称
    [self.gradeView.rightButton setTitle:selectedGradeModel.name forState:UIControlStateNormal];
    
    //第一个班级为默认选项
    self.selectedClassModel = [selectedGradeModel.classList firstObject];
    
}

- (void)setSelectedClassModel:(ClassListModel *)selectedClassModel
{
    _selectedClassModel = selectedClassModel;
    
    NSString *className = selectedClassModel ? selectedClassModel.name : nil;
    
    [self.classView.rightButton setTitle:className forState:UIControlStateNormal];
    
}

#pragma mark -setUI
- (UIView *)blackTopView
{
    if (!_blackTopView) {
        _blackTopView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT_NAVIGATION+DISTANCE_TOP, MAIN_WIDTH, MAIN_HEIGHT*0.09)];
        _blackTopView.backgroundColor = [UIColor colorWithHexString:@"#243C34"];
        [self.view addSubview:_blackTopView];
        [self.view sendSubviewToBack:_blackTopView];
    }
    return _blackTopView;
}

- (LoginTextView *)roleView
{
    if (!_roleView) { //207 258
        _roleView = [LoginTextView createSelectTextViewWithFrame:CGRectMake(0, self.blackTopView.bottom+MAIN_HEIGHT*0.108, MAIN_WIDTH, MAIN_HEIGHT*0.079)];
        _roleView.textField.placeholder = @"选择角色";
        [_roleView.rightButton addTarget:self action:@selector(selectRoleClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_roleView.rightButton setTitle:@"教师" forState:UIControlStateNormal];
        [self.view addSubview:_roleView];
    }
    return _roleView;
}

- (LoginTextView *)gradeView
{
    if (!_gradeView) {
        _gradeView = [LoginTextView createSelectTextViewWithFrame:CGRectMake(0, self.blackTopView.bottom+MAIN_HEIGHT*0.108, MAIN_WIDTH, MAIN_HEIGHT*0.079)];
        _gradeView.textField.placeholder = @"选择年级";
        [_gradeView.rightButton addTarget:self action:@selector(selectGradeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_gradeView];
    }
    return _gradeView;
}

- (LoginTextView *)classView
{
    if (!_classView) {
        _classView = [LoginTextView createSelectTextViewWithFrame:CGRectMake(0, self.gradeView.bottom, MAIN_WIDTH, self.gradeView.height)];
        _classView.topLineHidden = YES;
        _classView.textField.placeholder = @"选择班级";
        [_classView.rightButton addTarget:self action:@selector(selectClassClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_classView];
    }
    return _classView;
}

- (LoginButton *)confirmButton
{
    if (!_confirmButton) {
        CGFloat y = _isSelectRole ? self.roleView.bottom + 50 : self.classView.bottom + 50;
        
        _confirmButton = [[LoginButton alloc]initWithFrame:CGRectMake(10, y, MAIN_WIDTH-20, MAIN_HEIGHT*0.079)];
        [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
        
    }
    return _confirmButton;
}

- (JoinClassButton *)schoolView
{
    if (!_schoolView) {
        _schoolView = [[JoinClassButton alloc]initWithFrame:CGRectMake(15, 0, MAIN_WIDTH-30, MAIN_HEIGHT*0.134)];
        _schoolView.centerY = self.blackTopView.bottom;
        _schoolView.userInteractionEnabled = NO;
        _schoolView.imageName = @"Register_school";
        _schoolView.title     = @"您正在申请加入：";
        //在选择角色，说明班级已经选好，显示完整班级名 。否则只显示学校名
        _schoolView.tip       = _isSelectRole ? [RegisterModel shared].className : [RegisterModel shared].schoolName;
        [self.view addSubview:_schoolView];
    }
    return _schoolView;
}

@end
