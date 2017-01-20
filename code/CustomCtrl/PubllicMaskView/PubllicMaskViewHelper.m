//
//  PubllicMaskViewHelper.m
//  JZH_BASE
//
//  Created by Points on 13-11-14.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#define TAG_MASKVIEW  0xAB
#import "PubllicMaskViewHelper.h"
#import "MBProgressHUD.h"

@implementation PubllicMaskViewHelper
//弹出转圈圈
+ (void)showMaskViewIn:(NSString *)showTip
{
//    MaskView *bg = [[MaskView alloc]initWithFrame:MAIN_FRAME];
//    bg.tag = TAG_MASKVIEW;
//    [[UIApplication sharedApplication].keyWindow addSubview:bg];
//    [bg release];
//    
//    UIActivityIndicatorView *m_inditor = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((MAIN_WIDTH-40)/2, (MAIN_HEIGHT-40)/2, 40, 40)];
//    [m_inditor setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [m_inditor startAnimating];
//    [bg addSubview:m_inditor];
//    [m_inditor release];
//    
//    UILabel *tipLab =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(m_inditor.frame), MAIN_WIDTH, 30)];
//    [tipLab setBackgroundColor:[UIColor clearColor]];
//    [tipLab setText:showTip];
//    [tipLab setTextColor:[UIColor whiteColor]];
//    [tipLab setFont:[UIFont systemFontOfSize:20]];
//    [tipLab setTextAlignment:NSTextAlignmentCenter];
//    [bg addSubview:tipLab];
//    [tipLab release];
    
}

//给一个消息提示
+ (void)showTipViewWith:(NSString *)tip inSuperView:(UIView*)superView withDuration:(int)duration
{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        hud.minSize  = CGSizeMake(80, 30);
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = tip;
        hud.margin = 10.f;
        hud.yOffset = 0;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:duration];
}

+ (void)showTipViewWith:(NSString *)tip inSuperView:(UIView*)superView withDuration:(int)duration withYOffset:(int)offset
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    hud.minSize  = CGSizeMake(80, 80);
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = tip;
    hud.margin = 10.f;
    hud.yOffset = offset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:duration];
}

+ (void)hideView:(UIView *)view  animated:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:view animated:animated];
}

+ (void)showTipViewWith:(NSString *)tip WhenChattingWithCenter:(CGFloat)y withDuration:(int)duration
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.minSize  = CGSizeMake(100, 30);
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = tip;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:duration];
}

+ (void)removeCurrentTipView:(id)tipView
{
    UIView * v = (UIView *)tipView;
    [UIView animateWithDuration:1
                     animations:^{ v.alpha = 0;}
                     completion:^(BOOL isFinished){[v removeFromSuperview];
                     }];
}

+ (void)showWaitingView:(UIView *)parentView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    hud.minSize  = CGSizeMake(80, 80);
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.margin = 10.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:60];
}

+ (void)removeWaitingView:(UIView *)parentView
{
    [MBProgressHUD hideHUDForView:parentView animated:NO];
}



@end
