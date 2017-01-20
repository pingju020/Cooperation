//
//  SelectRoleViewController.h
//  anhui
//
//  Created by 葛君语 on 2016/10/24.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "BaseViewController.h"

@interface SelectRoleViewController : BaseViewController

//是否是选择角色  YES 选择角色  NO 选择班级和学校
- (instancetype)initWithIsSelectRole:(BOOL)isSelectRole;


//选择班级和学校需要的数据列表
@property (nonatomic,strong) NSArray *gradeList;

@end
