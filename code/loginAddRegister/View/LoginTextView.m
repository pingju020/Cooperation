//
//  LoginTextView.m
//  anhui
//
//  Created by 葛君语 on 2016/10/17.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "LoginTextView.h"

@interface LoginTextView ()<UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UIView *topLine;
@property (nonatomic,strong) UIView *bottomLine;
@property (nonatomic,strong) UIView *sepLine;
@property (nonatomic,strong) UIImage *iconImage;

@end

@implementation LoginTextView

#pragma mark -工厂模式
//账号
+ (instancetype)createAccountTextViewWithFrame:(CGRect)frame 
{
    LoginTextView *view = [[self alloc]initWithFrame:frame
                                           iconImage:@"Login_account"
                                         buttonImage:@"Login_downList"
                                 selectedButtonImage:nil
                                         placeholder:@"和教育(原校讯通)账号/手机号码"];
    view.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    return view;
}

//密码
+ (instancetype)createPasswordTextViewWithFrame:(CGRect)frame
{
    LoginTextView *view = [[self alloc]initWithFrame:frame
                                           iconImage:@"Login_lock"
                                         buttonImage:@"Login_eye"
                                 selectedButtonImage:@"Login_eye_h"
                                         placeholder:@"如果不知道密码，请获取密码"];
    
    
    view.textField.secureTextEntry = YES;
    view.textField.keyboardType = UIKeyboardTypeASCIICapable;
    view.topLineHidden = YES;
    
    [view.rightButton addTarget:view action:@selector(passwordChange:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
    
}

//验证码
+ (instancetype)createCodeTextViewWithFrame:(CGRect)frame
{
    LoginTextView *view = [[self alloc]initWithFrame:frame
                                           iconImage:@"Login_code"
                                         buttonImage:nil
                                 selectedButtonImage:nil
                                         placeholder:@"请输入短信验证码"];
    view.topLineHidden = YES;
    view.textField.keyboardType = UIKeyboardTypeNumberPad;
    //设置验证码按钮
    [view setCodeButton];
    
    return view;
    
}

//带右箭头的输入框
+ (instancetype)createSelectTextViewWithFrame:(CGRect)frame
{
    LoginTextView *view = [[self alloc]initWithFrame:frame];
    
    view.textField.userInteractionEnabled = NO;
    
    [view setSelectButton]; //选择按钮
    
    return view;
}

#pragma mark -初始化

- (instancetype)initWithFrame:(CGRect)frame
                    iconImage:(id)iconImage
                  buttonImage:(id)buttonImage
          selectedButtonImage:(id)selectedButtonImage
                  placeholder:(NSString *)placeholder
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
        
        if (iconImage) {
            if ([iconImage isKindOfClass:[UIImage class]]) {
                self.iconImage = iconImage;
            }else if ([iconImage isKindOfClass:[NSString class]]){
                self.iconImage = [UIImage imageNamed:iconImage];
            }
            
        }else{
            self.isIconHidden = YES;
        }
        
        if (buttonImage) {
            if ([buttonImage isKindOfClass:[UIImage class]]) {
                [self.rightButton setImage:buttonImage forState:UIControlStateNormal];
            }else if ([iconImage isKindOfClass:[NSString class]]){
                [self.rightButton setImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
            }
            
        }else{
            self.isRightHidden = YES;
        }
        
        if (selectedButtonImage) {
            if ([selectedButtonImage isKindOfClass:[UIImage class]]) {
                [self.rightButton setImage:selectedButtonImage forState:UIControlStateSelected];
            }else if ([selectedButtonImage isKindOfClass:[NSString class]]){
                [self.rightButton setImage:[UIImage imageNamed:selectedButtonImage] forState:UIControlStateSelected];
            }
            
        }

        self.textField.placeholder = placeholder;

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame iconImage:nil buttonImage:nil selectedButtonImage:nil placeholder:nil];
    return self;
}

#pragma mark -btnAction
- (void)passwordChange:(UIButton *)sender
{
    sender.selected ^= 1;
    
    self.textField.secureTextEntry = !sender.selected;
}

//回车键
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -porperties
- (void)setIconImage:(UIImage *)iconImage
{
    if (_isIconHidden || !iconImage) {
        return;
    }
    
    _iconImage = iconImage;
    self.icon.image = iconImage;
    
}



- (void)setIsIconHidden:(BOOL)isIconHidden
{
    if (_isIconHidden == isIconHidden) {
        return;
    }
    
    _isIconHidden = isIconHidden;
    
    self.icon.hidden    = isIconHidden;
    self.sepLine.hidden = isIconHidden;
    
    if (isIconHidden) {
        self.textField.left = 15;
        self.textField.width += self.sepLine.right+10 - 15 ;
    }else{
        self.textField.left = self.sepLine.right + 10;
        self.textField.width -= (self.sepLine.right + 10 - 15);
    }
}

- (void)setIsRightHidden:(BOOL)isRightHidden
{
    if (_isRightHidden == isRightHidden) {
        return;
    }
    
    _isRightHidden = isRightHidden;
    
    self.rightButton.hidden = isRightHidden;
    
    if (isRightHidden) {
        self.textField.width += self.rightButton.width;
    }else{
        self.textField.width -= self.rightButton.width;
    }
}

- (void)setTopLineHidden:(BOOL)topLineHidden
{
    _topLineHidden = topLineHidden;
    
    self.topLine.hidden = topLineHidden;
}

- (void)setBottomLineHidden:(BOOL)bottomLineHidden
{
    _bottomLineHidden = bottomLineHidden;
    
    self.bottomLineHidden = bottomLineHidden;
}

- (void)setText:(NSString *)text
{
    self.textField.text = text;
}

- (NSString *)text
{
    return self.textField.text;
}

#pragma mark -initialization
- (void)initialization
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self topLine];
    [self bottomLine];
    
    [self textField];
}

//右边按钮左右间距 5  左图标左右间距15，分割线和输入框间距10
- (UIButton *)rightButton
{
    if (!_rightButton) {
        CGFloat w = 24;
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width-5-5-w, (self.height-w)/2, w, w)];
        [self addSubview:_rightButton];
    }
    return _rightButton;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(self.sepLine.right+10, 0, self.width-(self.sepLine.right+10)-(self.rightButton.width+10), self.height)];
        _textField.delegate = self;
        _textField.textAlignment = NSTextAlignmentLeft;
        if (iPhone4 || iPhone5) {
            _textField.font = [UIFont systemFontOfSize:14];
        }
        
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:_textField];
    }
    return _textField;
}

- (UIView *)sepLine
{
    if (!_sepLine) {
        _sepLine = [[UIView alloc]initWithFrame:CGRectMake(self.icon.right+15, 10, 0.5, self.height-10*2)];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#D5D5D5"];
        [self addSubview:_sepLine];
    }
    return _sepLine;
}

- (UIImageView *)icon
{
    if (!_icon) {
        
        CGFloat w = 24;
        
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, (self.height-w)/2, w, w)];
        [self addSubview:_icon];
    }
    return _icon;
}

- (UIView *)topLine
{
    if (!_topLine) {
        _topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 1)];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"#D5D5D5"];
        [self addSubview:_topLine];
    }
    return _topLine;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"#D5D5D5"];
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (void)setCodeButton
{
    CGFloat w = self.width*0.25;
    
    _rightButton.frame = CGRectMake(self.width-10-w, 10, w, self.height-20);
    _textField.width = self.width-(_sepLine.right+10)-(w+20);
    
    [_rightButton setTitleColor:[UIColor colorWithHexString:@"#62CE8F"] forState:UIControlStateNormal];
    [_rightButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _rightButton.layer.cornerRadius = 5;
    _rightButton.layer.borderColor = [UIColor colorWithHexString:@"#62CE8F"].CGColor;
    _rightButton.layer.borderWidth = 1;
    _rightButton.hidden = NO;
}

- (void)setSelectButton
{
    //8*13 小箭头
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-15-8, (self.height-13)/2, 8, 13)];
    arrow.image = [[UIImage imageNamed:@"cona_right"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    arrow.tintColor = [UIColor colorWithHexString:@"#CFCFD3"];
    [self addSubview:arrow];
    
    _rightButton.frame = CGRectMake(0, 0, arrow.left-10, self.height);
    _rightButton.hidden = NO;
    _rightButton.titleLabel.font = _textField.font;
    [_rightButton setTitleColor:[UIColor colorWithHexString:@"#CFCFD3"] forState:UIControlStateNormal];
    _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

@end
