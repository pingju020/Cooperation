//
//  LaunchImageView.h
//  anhui
//
//  Created by 葛君语 on 16/7/4.
//  Copyright © 2016年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchImageView : UIImageView

//移除广告页判断标准 : 1.显示时长大于3秒   2.登录结束

//登录是否结束
@property (nonatomic,assign) BOOL isFinishLogin;


@property (nonatomic,copy) void(^removeHandle)();

@end
