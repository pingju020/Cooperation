//
//  RegisterModel.h
//  anhui
//
//  Created by 葛君语 on 2016/10/24.
//  Copyright © 2016年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kRegisterSuccessNotification; //注册完成的通知名称

//加入班级Model
@interface RegisterModel : NSObject

//账号信息
@property (nonatomic,copy) NSString *account;  //账号
@property (nonatomic,copy) NSString *password; //密码

//加入班级信息
@property (nonatomic,copy) NSString *classId;      //班级码
@property (nonatomic,copy) NSString *className;    //班级名称
@property (nonatomic,copy) NSString *gradeId;      //年级属性   还有个年级id,未用到，暂未添加
@property (nonatomic,copy) NSString *schoolId;     //学校Id
@property (nonatomic,copy) NSString *schoolName;   //学校名称

//个人信息
@property (nonatomic,copy) NSString *infoId;       //科目或昵称id

//场景
@property (nonatomic,assign) NSInteger modelClass; //1注册 2找回密码 3登录后加入班级 

//单例
+ (instancetype)shared;

@end


//年级Model
@interface GradeListModel : NSObject

@property (nonatomic,copy) NSString *gradeId; //年级ID
@property (nonatomic,copy) NSString *name;    //年级名称
@property (nonatomic,strong) NSArray *classList; //班级列表

+ (NSArray *)parsingGradeListWithList:(NSArray *)list;

@end


//班级Model
@interface ClassListModel : NSObject

@property (nonatomic,copy) NSString *classId; //班级ID
@property (nonatomic,copy) NSString *name;    //班级名称

+ (NSArray *)parsingClassListWithList:(NSArray *)list;


@end


//个人信息Model
@interface ItemInfoModel : NSObject

@property (nonatomic,copy) NSString *infoId;    //科目或昵称id
@property (nonatomic,copy) NSString *infoDesc;  //科目或昵称名称

+ (NSArray *)parsingItemInfoListWithList:(NSArray *)list;

@end


//注册审核信息Model
@interface RegisterStatusModel : NSObject
@property (nonatomic,copy) NSString *status; //1免审核 2正在审核 3第二家长

//为第三家长时所需参数
@property (nonatomic,copy) NSString *phone;            //第一家长手机号
@property (nonatomic,copy) NSString *agent_name;       //代理商姓名
@property (nonatomic,copy) NSString *agent_tel;        //代理商电话
@property (nonatomic,copy) NSString *studentid;        //学生id
@property (nonatomic,copy) NSString *studentName;      //学生名

- (instancetype)initWithDictionary:(NSDictionary *)dict;


@end
