//
//  LeftAlignAlertView.h
//  anhui
//
//  Created by yangjuanping on 16/5/16.
//  Copyright © 2016年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftAlignAlertView : UIView
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<LeftAlignAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (void)show;

@property (nonatomic,copy) void (^buttonBlock)(NSInteger buttonIndex) ;


@property (nonatomic,assign) NSTextAlignment textAlignment;   //default is NSTextAlignmentCenter

@end


@protocol LeftAlignAlertViewDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)leftAlertView:(LeftAlignAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
