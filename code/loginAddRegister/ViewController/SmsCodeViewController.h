//
//  SmsCodeViewController.h
//  anhui
//
//  Created by 葛君语 on 2016/10/24.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "BaseViewController.h"
@class RegisterStatusModel;

@interface SmsCodeViewController : BaseViewController

//输入班级码
- (instancetype)initWithClassCode;

//输入第二家长验证码
- (instancetype)initWithVerifySecondParent:(RegisterStatusModel *)statusModel;

@end
