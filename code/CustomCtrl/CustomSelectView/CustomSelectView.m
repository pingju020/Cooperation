//
//  CustomSelectView.m
//  anhui
//
//  Created by 葛君语 on 2016/11/1.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "CustomSelectView.h"

static CGFloat kViewWidth = 240; //控件宽度
static CGFloat kBtnHeight = 40;

@interface SelectButton : UIButton
@end


@interface CustomSelectView ()
@property (nonatomic,strong) UIView *backView;       //白色背景 所有UI放在这个view上   self是一个蒙版
@property (nonatomic,strong) UILabel *titleLabel;    //标题

@property (nonatomic,strong) NSMutableArray *buttonList; //按钮列表
@end

@implementation CustomSelectView

- (instancetype)initWithTitle:(NSString *)title buttonTitles:(NSString *)firstTitle, ...
{
    self = [super initWithFrame:MAIN_FRAME];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _selectedIndex = -1;
        
        //添加标题
        self.titleLabel.text = title;
        
        //按钮列表
        va_list argList;
        _buttonList = [NSMutableArray array];
        
        if (firstTitle) {
            [_buttonList addObject:firstTitle];
            
            va_start(argList, firstTitle);
            
            id temp;
            
            while((temp = va_arg(argList, id))){
                [_buttonList addObject:temp];
            }
        }
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
{
    return [self initWithTitle:title buttonTitles:nil, nil];
}

//添加按钮
- (void)addButtonWithTitle:(NSString *)title
{
    [_buttonList addObject:title];
}


//展示
- (void)show
{
    //创建按钮
    [_buttonList enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        SelectButton *btn = [[SelectButton alloc]initWithFrame:CGRectMake(0, self.titleLabel.bottom+10+idx*kBtnHeight, kViewWidth, kBtnHeight)];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.tag = idx+100;
        [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:btn];
        
        if (idx == _selectedIndex) { //默认选中的按钮
            btn.selected = YES;
        }
        
        if (idx == _buttonList.count-1) { //最后一个按钮，确定整个弹框高度
            _backView.height = btn.bottom;
        }
        
    }];
    
    _backView.center = self.center;
    
    //添加
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIView *frontView = [[window subviews] firstObject];
    
    [frontView addSubview:self];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}


- (void)selectAction:(SelectButton *)sender
{
    if (_clickHandle) {
        _clickHandle(sender.tag-100);
    }
    
    [self removeFromSuperview];
}

#pragma mark -setUI
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, 60)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 3;
        _backView.clipsToBounds = YES;
        [self addSubview:_backView];
    }
    return _backView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, kViewWidth-40, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end





@implementation SelectButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
        //标题
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor colorWithHexString:@"#999A9B"] forState:UIControlStateNormal];
        
        //图片
        [self setImage:[UIImage imageNamed:@"C_Select_off"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"C_Select_on"] forState:UIControlStateSelected];
        
        //分割线
        UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, kBtnHeight-1, kViewWidth, 1)];
        sepLine.backgroundColor = [UIColor colorWithHexString:@"#E9EAEB"];
        [self addSubview:sepLine];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(15, (kBtnHeight-20)/2, 150, 20);
    self.imageView.frame  = CGRectMake(kViewWidth-30, (kBtnHeight-15)/2, 15, 15);
}

@end

