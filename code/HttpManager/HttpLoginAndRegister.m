//
//  HttpLoginAndRegister.m
//  Cooperation
//
//  Created by yangjuanping on 16/11/7.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "HttpLoginAndRegister.h"
#import "XXTEncrypt/XXTEncrypt.h"

static NSString* kTermManu = nil;

@implementation HttpLoginAndRegister
SINGLETON_FOR_CLASS(HttpLoginAndRegister)


+(void)load{
    kTermManu = [NSString stringWithFormat:@"%@,%@,i01,%@,%@", [[UIDevice currentDevice] model],[[UIDevice currentDevice] systemVersion],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],@""];
}

#pragma mark - 登录
- (void)startLoginWithAccount:(NSString *)account
                      pwdCode:(NSString *)pwdCode
                         role:(NSString *)role
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed
{
    pwdCode = [[XXTEncrypt XXTmd5:pwdCode] uppercaseString];
    NSDictionary *param = @{@"commandtype":@"login",
                            @"term_manufacturer":[[HttpSessionManager  sharedInstance] getTermManu],
                            @"account":account,
                            @"password":pwdCode,
                            @"extend":[HTTP_MANAGER getExternNullToken],
                            @"origin":[HTTP_MANAGER getOrigin],
                            @"login_type":@"1",
                            @"user_type":role};
    
    [HTTP_MANAGER startNormalPostWithParagram:param successedBlock:success failedBolck:failed];
    
    
}

#pragma mark - 重置密码
- (void)newResetPassword:(NSString *)smsCode account:(NSString *)account password:(NSString *)pwd userType:(NSString*)userType successedBlock:(SuccessedBlock)success failedBolck:(FailedBlock)failed {
    NSString* pwdCode = [[XXTEncrypt XXTmd5:pwd] uppercaseString];
    NSDictionary *param = @{
                            @"commandtype":@"resetPassword",
                            @"extend":[HTTP_MANAGER getExternNullToken],
                            @"origin":[HTTP_MANAGER getOrigin],
                            @"account":account,
                            @"password":pwdCode,
                            @"smsCode":smsCode,
                            @"user_type":userType
                            };
    [HTTP_MANAGER startNormalPostWithParagram:param
                               successedBlock:success
                                  failedBolck:failed];
}

#pragma mark - 注册和密码修改的密码验证接口
- (void)checkSMSCode:(NSString *)name
             smsCode:(NSString *)smsCode
             smsType:(NSString *)smsType
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed {
    
    NSDictionary *param = @{
                            @"commandtype":@"checkSMSCode",
                            @"extend":[HTTP_MANAGER getExternNullToken],
                            @"origin":[HTTP_MANAGER getOrigin],
                            @"smsCode":smsCode,
                            @"account":name,
                            @"smsType":smsType
                            };
    
    [HTTP_MANAGER startNormalPostWithParagram:param successedBlock:success failedBolck:failed];
}

#pragma mark - 发送验证码
- (void)sendVerifyCode:(NSString *)userName
              sendType:(NSString *)sendType
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed
{
    NSDictionary* param = @{
                            @"commandtype":@"sendSMSCode",
                            @"account":userName,
                            @"smsType":sendType,
                            @"extend":[HTTP_MANAGER getExternNullToken],
                            @"origin":[HTTP_MANAGER getOrigin]
                            };
    [HTTP_MANAGER startNormalPostWithParagram:param successedBlock:success failedBolck:failed];
}

#pragma mark -启动页接口
-(void)getLoginPicWithType:(NSString *)pic_type
              successBlock:(SuccessedBlock)success
               failedBlock:(FailedBlock)failed
{
    NSDictionary * param = @{@"commandtype":@"getSplashPic",
                             @"pic_type":pic_type,
                             @"origin":[HTTP_MANAGER getOrigin],
                             @"extend":[HTTP_MANAGER getExternNullToken]};
    [HTTP_MANAGER startNormalPostWithParagram:param successedBlock:success failedBolck:failed];
}


#pragma mark -- 获取称呼科目等信息
-(void)getItemInfoList:(NSString*)type
                 Grade:(NSString*)grade
        successedBlock:(SuccessedBlock)success
           failedBlock:(FailedBlock)failed{
    NSString *extend = [XXTEncrypt  extendDES:@""];
    NSDictionary *params = @{@"commandtype":@"getItemInfoList",
                             @"type":type,
                             @"grade":grade,
                             @"extend":extend,
                             @"origin":[HTTP_MANAGER getOrigin]};
    
    [HTTP_MANAGER startNormalPostWithParagram:params successedBlock:success failedBolck:failed];
}

#pragma mark -注册信息 v3.1
- (void)registerInfoNewWithName:(NSString *)name
                         itemid:(NSString *)itemid
                           type:(NSString *)type
                        classid:(NSString *)classid
                            tel:(NSString *)tel
                 successedBlock:(SuccessedBlock)success
                    failedBolck:(FailedBlock)failed
{
    NSDictionary *param = @{@"commandtype":@"registerInfoNew",
                            @"name":name,
                            @"itemid":itemid,
                            @"type":type,
                            @"classid":classid,
                            @"tel":tel,
                            @"extend":[HTTP_MANAGER getExternNullToken],
                            @"origin":[HTTP_MANAGER getOrigin]};
    
    [HTTP_MANAGER startNormalPostWithParagram:param successedBlock:success failedBolck:failed];
}

#pragma mark - 获取年级和班级 v3.1
- (void)queryGradeAndClassWithSchool_id:(NSString *)school_id
                         successedBlock:(SuccessedBlock)success
                            failedBolck:(FailedBlock)failed
{
    NSDictionary *param = @{@"commandtype":@"queryGradeAndClass",
                            @"school_id":school_id,
                            @"extend":[HTTP_MANAGER getExternNullToken],
                            @"origin":[HTTP_MANAGER getOrigin]};
    
    [HTTP_MANAGER startNormalPostWithParagram:param successedBlock:success failedBolck:failed];
}

#pragma mark - 登录 v3.1
- (void)loginNewWithAccount:(NSString *)account
                    pwdCode:(NSString *)pwdCode
                 login_type:(NSString *)login_type
                  user_type:(NSString *)user_type
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    UIDevice *device  = [UIDevice currentDevice];
    NSString *model   = device.model;
    NSString *os      = [NSString stringWithFormat:@"%@%@",device.systemName,device.systemVersion];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *network = @"";
    
    NSDictionary *param = @{@"commandtype":@"loginNew",
                            @"account":account,
                            @"password":pwdCode,
                            @"login_type":login_type,
                            @"user_type":user_type,
                            @"term_manufacturer":kTermManu,
                            @"model":model,
                            @"os":os,
                            @"version":version,
                            @"network":network,
                            @"imei":@"",
                            @"extend":[HTTP_MANAGER getExternNullToken],
                            @"origin":[HTTP_MANAGER getOrigin]};
    
    
    [HTTP_MANAGER startNormalPostWithParagram:param successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        if (isSucceed) {
            NSDictionary *dataDict = succeedResult[@"data"];
            [HTTP_MANAGER setToken:dataDict[@"token"]];
        }
        success(succeedResult,isSucceed);
        
    } failedBolck:failed];
}

#pragma mark - 注册 v3.1
- (void)registerNewWithTel:(NSString *)tel
                      code:(NSString *)code
                  password:(NSString *)password
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    NSString *pwdCode = [[XXTEncrypt XXTmd5:password]uppercaseString];
    NSDictionary *param = @{@"commandtype":@"registerNew",
                            @"tel":tel,
                            @"code":code,
                            @"password":pwdCode,
                            @"extend":[HTTP_MANAGER getExternNullToken],
                            @"origin":[HTTP_MANAGER getOrigin]};
    [HTTP_MANAGER startNormalPostWithParagram:param successedBlock:success failedBolck:failed];
}

#pragma mark -开通第二家长信息 v3.1
- (void)registerSecondParentWithName:(NSString *)name
                              itemid:(NSString *)itemid
                                type:(NSString *)type
                             classid:(NSString *)classid
                                 tel:(NSString *)tel
                               phone:(NSString *)phone
                      successedBlock:(SuccessedBlock)success
                         failedBolck:(FailedBlock)failed
{
    NSDictionary *param = @{@"commandtype":@"registerSecondParent",
                            @"name":name,
                            @"itemid":itemid,
                            @"type":type,
                            @"classid":classid,
                            @"tel":tel,
                            @"phone":phone,
                            @"extend":[HTTP_MANAGER getExternNullToken],
                            @"origin":[HTTP_MANAGER getOrigin]};
    
    [HTTP_MANAGER startNormalPostWithParagram:param successedBlock:success failedBolck:failed];
    
}

#pragma mark -- 验证班级信息
-(void)verifyClassCode:(NSString*)strClassId
        successedBlock:(SuccessedBlock)success
           failedBlock:(FailedBlock)failed{
    
    NSDictionary *params = @{@"commandtype":@"verifyClassCode",
                             @"classid":strClassId,
                             @"extend":[HTTP_MANAGER getExternNullToken],
                             @"origin":[HTTP_MANAGER getOrigin]};
    
    [HTTP_MANAGER startNormalPostWithParagram:params successedBlock:success failedBolck:failed];
}

#pragma mark -第二家长绑定验证 v3.1
- (void)verifySecondParentCodeWithTel:(NSString *)tel
                                phone:(NSString *)phone
                                 code:(NSString *)code
                              classid:(NSString *)classid
                       successedBlock:(SuccessedBlock)success
                          failedBolck:(FailedBlock)failed
{
    NSDictionary *params = @{@"commandtype":@"verifyCode",
                            @"tel":tel,
                            @"phone":phone,
                            @"code":code,
                            @"classid":classid,
                            @"extend":[HTTP_MANAGER getExternNullToken],
                            @"origin":[HTTP_MANAGER getOrigin]};
    
    [HTTP_MANAGER startNormalPostWithParagram:params successedBlock:success failedBolck:failed];
}

#pragma mark - 验证账号 v3.1
- (void)verifyLoginAccount:(NSString *)account
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    NSDictionary *params = @{@"commandtype":@"verifyAccount",
                            @"account":account,
                            @"extend":[HTTP_MANAGER getExternNullToken],
                            @"origin":[HTTP_MANAGER getOrigin]};
    [HTTP_MANAGER startNormalPostWithParagram:params successedBlock:success failedBolck:failed];
}


#pragma mark - 滚动广告页请求
- (void)getRollAds:(NSString *)radsType successBlock:(SuccessedBlock)success failedBolck:(FailedBlock)failed {
    NSDictionary *params = @{
                             @"commandtype":@"getRollAds",
                             @"extend":[HTTP_MANAGER GetExternToken],
                             @"origin":[HTTP_MANAGER getOrigin],
                             @"radsType":radsType,
                             };
    
    [HTTP_MANAGER startNormalPostWithParagram:params successedBlock:success failedBolck:failed];
}
@end
