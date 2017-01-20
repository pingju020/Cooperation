//
//  LeftAlignAlertView.m
//  anhui
//
//  Created by yangjuanping on 16/5/16.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "LeftAlignAlertView.h"
#import "FontSizeUtil.h"

#define BTN_HEIGHT 37

@interface LeftAlignAlertView()
@property(nonatomic,strong)NSArray* arrOtherButtons;
@property(nonatomic,assign)NSInteger otherButtonNum;
@property(nonatomic,strong)UIView* viewBg;
@property(nonatomic,strong)UILabel* labMessage;
@property(nonatomic,strong)UILabel* labTitle;
@property(nonatomic,weak) id<LeftAlignAlertViewDelegate> delegate;
@end

@implementation LeftAlignAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<LeftAlignAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT)]) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        
        NSMutableArray* arrButtons = [[NSMutableArray alloc]init];
        [arrButtons addObject:[cancelButtonTitle copy]];
        NSString *otherButtonTitle;
        _otherButtonNum = 1;
        
        self.delegate = delegate;
        
        va_list args;
        va_start(args, otherButtonTitles);
        if (otherButtonTitles)
        {
            [arrButtons addObject:[otherButtonTitles copy]];
            _otherButtonNum++;
            
            while ((otherButtonTitle = va_arg(args, NSString *)))
            {
                //依次取得所有参数
                [arrButtons addObject:[otherButtonTitle copy]];
                _otherButtonNum++;
            }
        }  
        va_end(args);
        _arrOtherButtons = arrButtons;
        [self.labTitle setText:title];
        [self.labMessage setText:message];
        //[self.labMessage sizeToFit];
        
        CGSize size= [FontSizeUtil sizeOfString:_labMessage.text withFont:_labMessage.font withWidth:_labMessage.width];
        _labMessage.height = size.height;
        
        CGFloat btnHeight = 0.0;
        switch (_otherButtonNum) {
            case 1:
                btnHeight = BTN_HEIGHT;
                break;
            case 2:
                btnHeight = BTN_HEIGHT;
                break;
            default:
                btnHeight = BTN_HEIGHT*(_otherButtonNum);
                break;
        }
        [self.viewBg setHeight:(BTN_HEIGHT+CGRectGetHeight(self.labMessage.frame)+btnHeight+5+50)];
        self.viewBg.center = CGPointMake(MAIN_WIDTH/2,MAIN_HEIGHT/2);
        
        [self addButtons];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        ;
    }
    return self;
}

- (UIView*)viewBg{
    if (!_viewBg) {
        _viewBg = [[UIView alloc]initWithFrame:CGRectMake(40, 0, MAIN_WIDTH-80, 180)];
        [_viewBg setBackgroundColor:[UIColor whiteColor]];
        _viewBg.layer.cornerRadius = 3;
        _viewBg.layer.masksToBounds = YES;
        [self addSubview:_viewBg];
    }
    return _viewBg;
}

- (UILabel*)labTitle{
    if (!_labTitle) {
        _labTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, MAIN_WIDTH-80, 20)];
        [_labTitle setTextAlignment:NSTextAlignmentCenter];
        [_labTitle setFont:[UIFont systemFontOfSize:16]];
        [_labTitle setTextColor:[UIColor blackColor]];
        [self.viewBg addSubview:_labTitle];
    }
    return _labTitle;
}

-(UILabel*)labMessage{
    if (!_labMessage) {
        _labMessage = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.labTitle.frame)+20, MAIN_WIDTH-100, 0)];
        [_labMessage setTextAlignment:NSTextAlignmentCenter];
        [_labMessage setFont:[UIFont systemFontOfSize:13]];
        [_labMessage setTextColor:[UIColor colorWithHexString:@"#868686"]];
        _labMessage.numberOfLines = 0;
        [self.viewBg addSubview:_labMessage];
    }
    return _labMessage;
}

-(void)addButtons{
    if (_otherButtonNum == 1) {
        UIView* sep = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labMessage.frame)+5+20, MAIN_WIDTH-80, 1)];
        [sep setBackgroundColor:[UIColor colorWithHexString:@"#E5E4E5"]];
        [self.viewBg addSubview:sep];
        
        UIButton* btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sep.frame)+5, MAIN_WIDTH-80, BTN_HEIGHT)];
        NSString* strTitle = [_arrOtherButtons objectAtIndex:0];
        [btnCancel setTitle:strTitle forState:UIControlStateNormal];
        [btnCancel setTitleColor:COMMON_CORLOR_NORMAL forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
        btnCancel.tag = 0;
        [btnCancel addTarget:self action:@selector(btnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewBg addSubview:btnCancel];
    }
    else if (_otherButtonNum == 2){
        UIView* sep = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labMessage.frame)+5+20, MAIN_WIDTH-80, 1)];
        [sep setBackgroundColor:[UIColor colorWithHexString:@"#E5E4E5"]];
        [self.viewBg addSubview:sep];
        
        UIButton* btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sep.frame)+5, MAIN_WIDTH/2-40, BTN_HEIGHT)];
        [btnCancel setTitle:[_arrOtherButtons objectAtIndex:0] forState:UIControlStateNormal];
        [btnCancel setTitleColor:COMMON_CORLOR_NORMAL forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
        btnCancel.tag = 0;
        [btnCancel addTarget:self action:@selector(btnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewBg addSubview:btnCancel];
        
        UIView* sep1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btnCancel.frame), CGRectGetMaxY(sep.frame), 1, _viewBg.height-sep.bottom)];
        [sep1 setBackgroundColor:[UIColor colorWithHexString:@"#E5E4E5"]];
        [self.viewBg addSubview:sep1];
        
        UIButton* btnButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sep1.frame), CGRectGetMaxY(sep.frame)+5, MAIN_WIDTH/2-40, BTN_HEIGHT)];
        [btnButton setTitle:[_arrOtherButtons objectAtIndex:1] forState:UIControlStateNormal];
        [btnButton setTitleColor:COMMON_CORLOR_NORMAL forState:UIControlStateNormal];
        btnButton.titleLabel.font = [UIFont systemFontOfSize:15];
        btnButton.tag = 1;
        [btnButton addTarget:self action:@selector(btnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewBg addSubview:btnButton];
    }
    else{
        CGFloat fMaxY = CGRectGetMaxY(self.labMessage.frame)+5;
        NSInteger nIndex = 0;
        for (NSString* strName in _arrOtherButtons) {
            UIView* sep = [[UIView alloc]initWithFrame:CGRectMake(0, fMaxY, MAIN_WIDTH-80, 1)];
            [sep setBackgroundColor:[UIColor colorWithHexString:@"#E5E4E5"]];
            [self.viewBg addSubview:sep];
            
            UIButton* btnButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sep.frame)+5, MAIN_WIDTH-80, BTN_HEIGHT)];
            [btnButton setTitle:strName forState:UIControlStateNormal];
            [btnButton setTitleColor:COMMON_CORLOR_NORMAL forState:UIControlStateNormal];
            [btnButton addTarget:self action:@selector(btnTouched:) forControlEvents:UIControlEventTouchUpInside];
            btnButton.titleLabel.font = [UIFont systemFontOfSize:15];
            btnButton.tag = nIndex++;
            [self.viewBg addSubview:btnButton];
            
            fMaxY = CGRectGetMaxY(btnButton.frame);
        }
    }
}

-(void)btnTouched:(id)sender{
    UIButton* btn = sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftAlertView:clickedButtonAtIndex:)]) {
        [self.delegate leftAlertView:self clickedButtonAtIndex:btn.tag];
    }
    
    if (self.buttonBlock) {
        self.buttonBlock(btn.tag);
    }
    
    [self removeFromSuperview];
}

// adds a button with the title. returns the index (0 based) of where it was added. buttons are displayed in the order added except for the
// cancel button which will be positioned based on HI requirements. buttons cannot be customized.
- (NSInteger)addButtonWithTitle:(NSString *)title{
    return 0;
}
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex{
    return @"";
}

// shows popup alert animated.
- (void)show{
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIView *frontView = [[window subviews] objectAtIndex:0];
    
    // 添加到窗口
    [frontView addSubview:self];
}


- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    
    _labMessage.textAlignment = textAlignment;
}

@end
