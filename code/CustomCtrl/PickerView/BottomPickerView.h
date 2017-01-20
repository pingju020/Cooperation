//
//  BottomPickerView.h
//  anhui
//
//  Created by yangjuanping on 15/12/21.
//  Copyright © 2015年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomPickerViewDelegate <UIPickerViewDelegate>
//点击取消的回调接口
-(void)actionCancle;
//点击确定的回调接口
-(void)actionDone;
@end

@interface BottomPickerView : UIView
@property(assign, nonatomic) id<BottomPickerViewDelegate> delegate;
@property(strong, nonatomic)UIView* toolBar;
@property(strong, nonatomic)UIPickerView* pickerView;
@property(strong, nonatomic)UILabel* labTitle;

+(instancetype)styleDefault:(NSString*)strTitle;
-(void)show:(UIViewController *)controller;
-(void)dismiss:(UIViewController *)controller;
//选中指定的行列
-(void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)anime;
//获取被选中的行列
-(NSInteger)selectedRowInComponent:(NSInteger)component;
@end