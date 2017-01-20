//
//  BottomPickerView.m
//  anhui
//
//  Created by yangjuanping on 15/12/21.
//  Copyright © 2015年 Education. All rights reserved.
//

#import "BottomPickerView.h"

//#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface BottomPickerView(){
    UIColor *toolBarColor;
    UIColor *textColorNormal;
    UIColor *textColorPressed;
    UIColor *pickerBgColor;
}
@end


@implementation BottomPickerView
+(instancetype)styleDefault:(NSString*)strTitle{
    BottomPickerView* sheet = [[BottomPickerView alloc]initWithFrame:CGRectMake(
                                                                                      0,
                                                                                      0,
                                                                                      UIScreen.mainScreen.bounds.size.width,
                                                                                      UIScreen.mainScreen.bounds.size.height)];
    
    [sheet setBackgroundColor:[UIColor clearColor]];
    sheet.toolBar = [sheet actionToolBar];
    sheet.pickerView = [sheet actionPicker];
    [sheet addSubview:sheet.toolBar];
    [sheet addSubview:sheet.pickerView];
    [sheet.labTitle setText:strTitle];
    
    
    return sheet;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        toolBarColor = [UIColor colorWithRed:240.0 green:240.0 blue:240.0 alpha:0.9];
        textColorNormal = [UIColor colorWithRed:0 green:146.0 blue:255.0 alpha:1];
        textColorPressed = [UIColor colorWithRed:209.0 green:213.0 blue:219.0 alpha:0.9];
        pickerBgColor = textColorPressed;
    }
    
    return self;
}
-(void)setupInitPostion:(UIViewController *)controller{
    [UIApplication.sharedApplication.keyWindow?UIApplication.sharedApplication.keyWindow:UIApplication.sharedApplication.windows[0]
                                                                              addSubview:self];
    [self.superview bringSubviewToFront:self];
    CGFloat pickerViewYpositionHidden = UIScreen.mainScreen.bounds.size.height;
    [self.pickerView setFrame:CGRectMake(self.pickerView.frame.origin.x,
                                         pickerViewYpositionHidden,
                                         self.pickerView.frame.size.width,
                                         self.pickerView.frame.size.height)];
    [self.toolBar setFrame:CGRectMake(self.toolBar.frame.origin.x,
                                      pickerViewYpositionHidden,
                                      self.toolBar.frame.size.width,
                                      self.toolBar.frame.size.height)];
}
-(void)show:(UIViewController *)controller{
    [self setupInitPostion:controller];
    
    CGFloat toolBarYposition = UIScreen.mainScreen.bounds.size.height -
    (self.pickerView.frame.size.height + self.toolBar.frame.size.height);
    
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.5]];
                         [controller.view setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
                         [controller.navigationController.navigationBar setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
                         
                         [self.toolBar setFrame:CGRectMake(self.toolBar.frame.origin.x,
                                                           toolBarYposition,
                                                           self.toolBar.frame.size.width,
                                                           self.toolBar.frame.size.height)];
                         
                         [self.pickerView setFrame:CGRectMake(self.pickerView.frame.origin.x,
                                                              toolBarYposition+self.toolBar.frame.size.height,
                                                              self.pickerView.frame.size.width,
                                                              self.pickerView.frame.size.height)];
                         
                     }
                     completion:nil];
    
}
-(void)dismiss:(UIViewController *)controller{
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self setBackgroundColor:[UIColor clearColor]];
                         [controller.view setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
                         [controller.navigationController.navigationBar setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
                         [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                             UIView* v = (UIView*)obj;
                             [v setFrame:CGRectMake(v.frame.origin.x,
                                                    UIScreen.mainScreen.bounds.size.height,
                                                    v.frame.size.width,
                                                    v.frame.size.height)];
                         }];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
    
}

-(UIView *)actionToolBar{
    UIView *tools = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 44)];
    tools.backgroundColor = toolBarColor;
    UIButton *cancle = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle setTitleColor:textColorPressed forState:UIControlStateHighlighted];
    [cancle setTitleColor:textColorNormal forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(actionCancle) forControlEvents:UIControlEventTouchUpInside];
    //[cancle sizeToFit];
    [tools addSubview:cancle];
    
//    cancle.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint *cancleConstraintLeft = [NSLayoutConstraint constraintWithItem:cancle attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:tools attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10.0f];
//    NSLayoutConstraint *cancleConstrainY = [NSLayoutConstraint constraintWithItem:cancle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tools attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
//    [tools addConstraint:cancleConstraintLeft];
//    [tools addConstraint:cancleConstrainY];
    
    UIButton *ok = [[UIButton alloc]initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width-60, 0, 60, 44)];
    [ok setTitle:@"确定" forState:UIControlStateNormal];
    [ok setTitleColor:textColorNormal forState:UIControlStateNormal];
    [ok setTitleColor:textColorPressed forState:UIControlStateHighlighted];
    [ok addTarget:self action:@selector(actionDone) forControlEvents:UIControlEventTouchUpInside];
    //[ok sizeToFit];
    [tools addSubview:ok];
    
    _labTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancle.frame), 0, CGRectGetMinX(ok.frame)-CGRectGetMaxX(cancle.frame), 44)];
    [_labTitle setTextAlignment:NSTextAlignmentCenter];
    [_labTitle setTextColor:[UIColor darkGrayColor]];
    [_labTitle setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]-1]];
    [tools addSubview:_labTitle];
    
//    ok.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint *okConstraintRight = [NSLayoutConstraint constraintWithItem:ok attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:tools attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-10.0f];
//    NSLayoutConstraint *okConstraintY = [NSLayoutConstraint constraintWithItem:ok attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tools attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
//    [tools addConstraint:okConstraintRight];
//    [tools addConstraint:okConstraintY];
    
    return tools;
}

-(UIPickerView *)actionPicker;{
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, UIScreen.mainScreen.bounds.size.width, 216)];
    picker.showsSelectionIndicator=YES;
    [picker setBackgroundColor:pickerBgColor];
    
    return picker;
}

-(void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)anime{
    [_pickerView selectRow:row inComponent:component animated:anime];
}

-(NSInteger)selectedRowInComponent:(NSInteger)component{
    return [_pickerView selectedRowInComponent:component];
}

-(void)actionDone{
    if([_delegate respondsToSelector:@selector(actionDone)]){
        [_delegate actionDone];
    }
}

-(void)actionCancle{
    if ([_delegate respondsToSelector:@selector(actionCancle)]) {
        [_delegate actionCancle];
    }
}
-(void)setDelegate:(id<BottomPickerViewDelegate>)delegate{
    _delegate = delegate;
    _pickerView.delegate = delegate;
}
@end