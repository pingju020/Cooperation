//
//  LoginManager.h
//  anhui
//
//  Created by 葛君语 on 2016/10/20.
//  Copyright © 2016年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LoginBlock)(BOOL isSuccess,NSString *msg); //登录完成回调block

@interface LoginManager : NSObject

#pragma mark ------------------账号验证------------------

@property (nonatomic,copy) NSString *parent_statu;      //1.和教育计费用户；2.和教育计费待审核用户；3.自注册待审核用户；4.自注册用户；5.互联网用户；6.非体系内用户;7其它状态
@property (nonatomic,copy) NSString *teacher_statu;     //1.和教育用户；2.自注册用户；3.互联网用户；4.非体系内用户

@property (nonatomic,copy) NSString *is_first_install;  //0-首次安装；1-不是首次安装

@property (nonatomic,copy) NSString *user_role;         //默认0，表示既是老师又是家长，1表示老师，3表示家长

@property (nonatomic,copy) NSString *create_date;       //注册时间或者是开通订购时间

@property (nonatomic,copy) NSString *audit_date;        //审核提交时间


//解析账号验证数据
+ (instancetype)parsingWithDictionary:(NSDictionary *)dict;


#pragma mark ------------------登录------------------



//用户实际登录使用的身份
@property (nonatomic,copy) NSString *user_type; //1教师 3家长

//开始登录
/* 账号，密码，登录方式，登录完成block*/

- (void)startLoginWithAccount:(NSString *)account
                     password:(NSString *)password
                   login_type:(NSString *)login_type  //1:账号密码 2：账号验证码
              loginCompletion:(LoginBlock)loginCompletion;


@end



#pragma mark ------------------自动登录------------------
@interface AutoLoginModel : NSObject
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *passWord;
@property (nonatomic,copy) NSString *autoLogin;
@property (nonatomic,copy) NSString *isLogined;
@property (nonatomic,copy) NSString *userType;
@property (nonatomic,copy) NSString *isXXT;

+ (instancetype)obtain;

@end
