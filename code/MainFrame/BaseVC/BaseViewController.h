//
//  BaseViewController.h
//  xxt_xj
//
//  Created by Points on 13-11-25.
//  Copyright (c) 2013å¹´ Points. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "XTNavigationController.h"
#import "ConnectionBaseProtocol.h"
//#import "ClassIconImageView.h"
//#import "MJRefreshBaseView.h"

static UIColor* kCommonColorHighLight = nil;

@interface BaseViewController : UIViewController<BaseViewControllerDelegate>
{
    UIImageView *navigationBG;
    UIButton *backBtn;
    UILabel *title;
    UIButton *selectBtn;
    UIButton *m_rightBtn;

    UILabel *_commentLabel; ///< 暂无数据
    BOOL isRequest;

}
@property(nonatomic,assign) id<BaseViewControllerDelegate>m_delegate;
@property (nonatomic, strong) UIImageView *homeworkMarkImageView;
@property (nonatomic, strong) UIButton *hiddenKeyboardBtn;
@property (nonatomic, strong) UIView *userIconImageView;
//@property (nonatomic,assign) MJRefreshState m_state;
-(void)handleError:(NSString*)error;

- (void)removeBackBtn;

- (void)setSliderBtn;

- (void)updateUserImage:(NSString *)url;

- (void)homeworkCome:(NSNotification *)noti;

- (void)showWaitingView;
- (void)showWaitingViewWithMessage:(NSString *)message;
- (void)showWaitingViewWith:(int)delay;

- (void)showEmptyIfNeedWithMessage:(NSString *)message noData:(BOOL)noData;

- (void)removeWaitingView;

/** 是否来自侧边栏 */
@property (nonatomic, assign) BOOL fromSide;

/** 设置返回按钮图标为home */
- (void)setBackBtnHomeImage;
/** 重置返回按钮图标为返回 */
- (void)resetBackBtnImage;


/** 添加键盘通知 */
- (void)addKeyboardObserve;
/** 移除键盘通知 */
- (void)removeKeyboardObserve;
- (void)keyboardWillShow:(NSNotification *)noti;
- (void)keyboardWillHide:(NSNotification *)noti;

@property(nonatomic, retain, readonly) NSArray *pullDownMenuItems;    ///< 下拉菜单选项

- (void)showCommentViewWithMessage:(NSString *)message;
- (void)removeCommentView;

- (void)removeAllWaitingView;
- (CGSize )getStringheight:(UIFont *)font stringContent:(NSString *)string;
- (void)showError;
- (void)showMsg:(NSString *)msg;
@end
