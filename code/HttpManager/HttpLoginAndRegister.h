//
//  HttpLoginAndRegister.h
//  Cooperation
//
//  Created by yangjuanping on 16/11/7.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpSessionManager.h"

#define LOGIN_REGISTER [HttpLoginAndRegister sharedInstance]

@interface HttpLoginAndRegister : NSObject
SINGLETON_FOR_HEADER(HttpLoginAndRegister)

#pragma mark - 登录
- (void)startLoginWithAccount:(NSString *)account
                      pwdCode:(NSString *)pwdCode
                         role:(NSString *)role
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;

#pragma mark - 重置密码
- (void)newResetPassword:(NSString *)smsCode
                 account:(NSString *)account
                password:(NSString *)pwd
                userType:(NSString*)userType
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed;

#pragma mark - 注册和密码修改的密码验证接口
- (void)checkSMSCode:(NSString *)name
             smsCode:(NSString *)smsCode
             smsType:(NSString *)smsType
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed;

#pragma mark - 发送验证码
- (void)sendVerifyCode:(NSString *)userName
              sendType:(NSString *)sendType
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed;

#pragma mark -启动页接口
-(void)getLoginPicWithType:(NSString *)pic_type
              successBlock:(SuccessedBlock)success
               failedBlock:(FailedBlock)failed;


#pragma mark -- 获取称呼科目等信息
-(void)getItemInfoList:(NSString*)type
                 Grade:(NSString*)grade
        successedBlock:(SuccessedBlock)success
           failedBlock:(FailedBlock)failed;


#pragma mark -注册信息 v3.1
- (void)registerInfoNewWithName:(NSString *)name
                         itemid:(NSString *)itemid
                           type:(NSString *)type
                        classid:(NSString *)classid
                            tel:(NSString *)tel
                 successedBlock:(SuccessedBlock)success
                    failedBolck:(FailedBlock)failed;

#pragma mark - 获取年级和班级 v3.1
- (void)queryGradeAndClassWithSchool_id:(NSString *)school_id
                         successedBlock:(SuccessedBlock)success
                            failedBolck:(FailedBlock)failed;

#pragma mark - 登录 v3.1
- (void)loginNewWithAccount:(NSString *)account
                    pwdCode:(NSString *)pwdCode
                 login_type:(NSString *)login_type
                  user_type:(NSString *)user_type
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed;

#pragma mark - 注册 v3.1
- (void)registerNewWithTel:(NSString *)tel
                      code:(NSString *)code
                  password:(NSString *)password
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

#pragma mark -开通第二家长信息 v3.1
- (void)registerSecondParentWithName:(NSString *)name
                              itemid:(NSString *)itemid
                                type:(NSString *)type
                             classid:(NSString *)classid
                                 tel:(NSString *)tel
                               phone:(NSString *)phone
                      successedBlock:(SuccessedBlock)success
                         failedBolck:(FailedBlock)failed;

-(void)verifyClassCode:(NSString*)strClassId
        successedBlock:(SuccessedBlock)success
           failedBlock:(FailedBlock)failed;

#pragma mark -第二家长绑定验证 v3.1
- (void)verifySecondParentCodeWithTel:(NSString *)tel
                                phone:(NSString *)phone
                                 code:(NSString *)code
                              classid:(NSString *)classid
                       successedBlock:(SuccessedBlock)success
                          failedBolck:(FailedBlock)failed;

#pragma mark - 验证账号 v3.1
- (void)verifyLoginAccount:(NSString *)account
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

#pragma mark - 滚动广告页请求
- (void)getRollAds:(NSString *)radsType
      successBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;

@end
