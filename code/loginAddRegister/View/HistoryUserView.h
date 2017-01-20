//
//  HistoryUserView.h
//  anhui
//
//  Created by Points on 15/6/5.
//  Copyright (c) 2015年 Education. All rights reserved.
//
@protocol HistoryUserViewDelegate <NSObject>

@required

- (void)onSelectContactWith:(NSString *)account withPwd:(NSString *)pwd withUrl:(NSString *)url;

- (void)onDeleteContact:(NSString *)account;

- (void)onRemoveSelf;
@end

#import <UIKit/UIKit.h>

@interface HistoryUserView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *m_table;
}
@property (nonatomic,weak)id<HistoryUserViewDelegate>m_delegate;
@property (nonatomic,strong)NSArray *m_arrData;
@property (nonatomic,assign)BOOL m_isTeacher;

- (id)initWithFrame:(CGFloat)maxY withArr:(NSArray *)arr isTeacher:(BOOL)isTeacher;

- (instancetype)initWithMaxY:(CGFloat)maxY; //新版，不区分教师家长

@end
