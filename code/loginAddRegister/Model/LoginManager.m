//
//  LoginManager.m
//  anhui
//
//  Created by 葛君语 on 2016/10/20.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "LoginManager.h"
#import "MainDataModel.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "DES3Util.h"
#import "XXTEncrypt.h"
#import "HttpLoginAndRegister.h"
#import "MJExtension.h"

E_ROLE role;

@interface LoginManager ()

//登录相关
@property (nonatomic,copy)   NSString *account;
//密码
@property (nonatomic,copy)   NSString *password;
//1:账号密码 2：账号验证码
@property (nonatomic,copy)   NSString *login_type;
//登录成功返回的数据
@property (nonatomic,strong) NSDictionary *succeedResult;
//登录回调
@property (nonatomic,copy)   LoginBlock loginBlock;


@end


@implementation LoginManager

-(void)setUser_type:(NSString *)user_type{
    _user_type = user_type;
    if ([_user_type isEqualToString:@"1"]) {
        role = E_ROLE_TEACHER;
    }
    else{
        role = E_ROLE_PARENT;
    }
}

#pragma mark -验证
//解析
+ (instancetype)parsingWithDictionary:(NSDictionary *)dict
{
    LoginManager *m = [LoginManager mj_objectWithKeyValues:dict];
    
    //如果用户不是多身份，那登录角色就是用户当前身份
    if (![m.user_role isEqualToString:@"0"]) {
        m.user_type = m.user_role;
    }
    
    
    return m;
    //return nil;
}


#pragma mark -登录

- (void)startLoginWithAccount:(NSString *)account
                     password:(NSString *)password
                   login_type:(NSString *)login_type
              loginCompletion:(LoginBlock)loginCompletion
{
    _account         = account;
    _password        = password;
    _login_type      = login_type;
    
    //密码需要加密传输
    NSString *pwdCode;
    if ([login_type isEqualToString:@"1"]) { //账号密码
        pwdCode = [[XXTEncrypt XXTmd5:password] uppercaseString];
    }else if ([login_type isEqualToString:@"2"]){ //验证码
        pwdCode = [DES3Util encrypt:password];
        
    }else{
        return;
    }
    
    [LOGIN_REGISTER loginNewWithAccount:account
                              pwdCode:pwdCode
                           login_type:login_type
                            user_type:_user_type
                         successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                             if (isSucceed) {
                                 _succeedResult = succeedResult;
                                 
                                 _loginBlock = loginCompletion;
                                 
                                 //开始处理数据
                                 [self setupLoginInfo];
                                 
                             }else{
                                 loginCompletion(NO,succeedResult[@"msg"]);
                             }
                         } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                             loginCompletion(NO,@"网络异常");
                         }];
    
    
}

#pragma mark -处理登录信息
- (void)setupLoginInfo
{
//    //清除缓存
//    [[EGOCache globalCache]clearCache];
//    [[SDImageCache sharedImageCache]cleanDisk];
    
    //本地储存键值
    [self saveLocalKeyValues];
    
    //保存孩子信息
    [self saveChildrenInfo];
    
    //保存自动登录账号信息
    [self saveAutoLoginInfo];
    
    //保存登录用户信息
    [self saveLoginInfo];
    
    //添加联系人
    [self getAHContacts];
    
    //获取群组状态
    [self getClassStatus];
    
    //登录成功，添加OTS信息
    [self sendOTSAccount];
}

//本地储存键值
- (void)saveLocalKeyValues
{
    NSDictionary *dataDict = _succeedResult[@"data"];
    
    NSNumber *userID           = dataDict[@"userId"];
    NSNumber *schoolType       = _succeedResult[@"schoolType"];
    NSString *isChinaMobileStr = [self checkChinaMobile] ? @"1" :@"0";
    
//    [[NSUserDefaults standardUserDefaults] setObject:isChinaMobileStr forKey:KEY_IS_CHINA_MOBILE];
//    [[NSUserDefaults standardUserDefaults] setObject:_account forKey:KEY_ACCOUTN];
//    [[NSUserDefaults standardUserDefaults] setObject:_password forKey:KEY_PASSWORD];
//    [[NSUserDefaults standardUserDefaults] setInteger:AccountTypeEdu forKey:KEY_ACCOUNT_TYPE];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",userID] forKey:KEY_REMOTEID];
//    [[NSUserDefaults standardUserDefaults] setObject:schoolType forKey:KEY_SCHOOLTYPE];
//    [[NSUserDefaults standardUserDefaults] setObject:_user_type forKey:KEY_LOGIN_ROLE];
//    
//    //判断是否是自注册用户(orgin=1为自注册)
//    NSNumber *orgin = dataDict[@"orgin"];
//    [[NSUserDefaults standardUserDefaults] setObject:orgin forKey:KEY_ORGIN];
    
}

//检测电话号码
- (BOOL)checkChinaMobile
{
    BOOL ret = NO;
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (carrier == nil)
    {
        return NO;
    }
    
    NSString *name = [carrier carrierName];
    NSRange range = [name rangeOfString:@"中国移动"];
    if (range.location != NSNotFound) {
        return YES;
    }
    
    NSString *code = [carrier mobileNetworkCode];
    if (code == nil)
    {
        return NO;
    }
    
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"])
    {
        ret = YES;
    }
    
    return ret;
}


//保存孩子信息
- (void)saveChildrenInfo
{
//    NSDictionary *dataDict = _succeedResult[@"data"];
//    
//    //
//    [sqliteADO deleteUserChildrenInfo:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_REMOTEID]];
//    
//    //
//    NSArray *childrenArr = dataDict[@"studentData"];
//    
//    if (!IsArrEmpty(childrenArr)) {
//        for (NSDictionary *childrenDic in childrenArr) {
//            LoginUserChildrenInfoDTO *loginUserChildrenInfoDto = [[LoginUserChildrenInfoDTO alloc] init];
//            [loginUserChildrenInfoDto encodeFromDictionary:childrenDic];
//            loginUserChildrenInfoDto.parentId = [NSString stringWithFormat:@"%@",dataDict[@"userId"]];
//            [sqliteADO saveUserChildrenInfo:loginUserChildrenInfoDto];
//        }
//        
//    }
//    
//    NSArray *currentChildrenArr = [sqliteADO queryUserChildrenInfo:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_REMOTEID]];
//    LoginUserChildrenInfoDTO *childrenInfo = [[LoginUserChildrenInfoDTO alloc] init];
//    childrenInfo = [currentChildrenArr firstObject];
//    NSString *currentChildrenId = childrenInfo.childrenId == nil ? @"" : childrenInfo.childrenId;
//    [[NSUserDefaults standardUserDefaults] setValue:currentChildrenId forKey:KEY_CURRENT_CHILERENID];
}

//自动登录账号信息
- (void)saveAutoLoginInfo
{
//    //游客或者验证码登录不储存
//    if ([LoginUserUtil isVisitor] || [_login_type isEqualToString:@"2"]) {
//        return;
//    }
//    
//    NSDictionary *dic = @{@"userName":_account,
//                          @"passWord":_password,
//                          @"autoLogin":@"1",
//                          @"isLogined":@"1",
//                          @"userType":_user_type,
//                          @"isXXT":@"0"};
//    
//    [LoginUserUtil saveUserToAutoPlist:dic];
    
}

//保存登录用户信息
- (void)saveLoginInfo
{
//    NSDictionary *dataDict = _succeedResult[@"data"];
//    
//    //
//    NSString *token = dataDict[@"token"];
//    
//    //
//    [[GlobalData getInstance] setParameter:token forKey:USERTOKEN];
//    [GlobalData saveToDisk:token forKey:USERTOKEN];
//    [[GlobalData getInstance] setParameter:dataDict forKey:USERINFO];
//    [LoginUserUtil writeDictionaryToPlist:dataDict];
//    
//    //保存数据库
//    if (![LoginUserUtil isVisitor]) {
//        //验证码登录密码为空
//        NSString *password = [_login_type isEqualToString:@"1"]?_password:@"";
//        
//        //最多存3个历史用户信息，多的删除 只保留两个
//        NSArray *userList = [sqliteADO queryAllUser];
//        NSInteger count = userList.count;
//        if (count>=3) {
//            [userList enumerateObjectsWithOptions:NSEnumerationReverse
//                                       usingBlock:^(NSDictionary *contact, NSUInteger idx, BOOL * _Nonnull stop) {
//                                           if (idx < count-2) {
//                                               NSString *userName = contact[@"userName"];
//                                               [sqliteADO deleteUserWithName:userName];
//                                           }
//                                       }];
//        }
//        
//        //插入信息
//        [sqliteADO insertUserTB:_account
//                   withPassword:password
//                     withUserId:[LoginUserUtil userId]
//                   withUserType:_user_type];
//    }
//    
//    //创建存放图片和音频的文件夹
//    [LocalImageHelper createUploadFileInDocument];
}

//添加联系人
- (void)getAHContacts
{
    //回调登录结束信息
    _loginBlock(YES,nil);

//    [HTTP_MANAGER getAHContacts:^(NSDictionary *succeedResult) {
//        BOOL isSucceed = IS_REQUEST_SUCCEED(succeedResult);
//        
//        if (isSucceed) {
//            //
//            [sqliteADO clearContactTable];
//            
//            //
//            [[NSUserDefaults standardUserDefaults] setObject:succeedResult[@"has_shortdn"]
//                                                      forKey:KEY_ISOPEN_VNET];
//            
//            //
//            NSArray *arr = succeedResult[@"list"];
//            
//            for (NSDictionary *groupInfo in arr) {
//                
//                NSMutableArray *arrMember =  [NSMutableArray array];
//                for(NSDictionary *memberCell in groupInfo[@"memberlist"])
//                {
//                    [arrMember addObject:memberCell];
//                }
//                
//                NSString *groupId = [NSString stringWithFormat:@"%@%lld",KEY_APPID, [groupInfo[@"classid"] longLongValue]];
//                
//                [sqliteADO clearGroupTableWithGroupId:groupId];
//                [sqliteADO clearContactTableWithGroupId:groupId];
//                
//                [sqliteADO saveContactToDB:arrMember withGroupID:groupId];
//                [sqliteADO saveGroupToDB:groupInfo];
//            }
//            
//            //
//            [[NewMsgManager sharedInstance] GetNewMsgTurning];
//            [[NewMsgManager sharedInstance] startGetNewMsgTimer];
//            
//            [[NSNotificationCenter defaultCenter]postNotificationName:KEY_NEED_UPDATE_CONTACT object:nil];
//            
//        }
//        
//        //回调登录结束信息
//        _loginBlock(YES,nil);
//        
//        
//        
//    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
//        
//        //回调登录结束信息
//        _loginBlock(YES,nil);
//    }];
}

//获取群组状态
- (void)getClassStatus
{
//    [HTTP_MANAGER getClassStatus:^(NSDictionary *succeedResult) {
//        BOOL isSucceed = IS_REQUEST_SUCCEED(succeedResult);
//        //获取用户信息成功
//        if (isSucceed) {
//            [MainDataModel sharedInstance].arrHideGroup = [[NSArray alloc]initWithArray:succeedResult[@"list"] copyItems:YES];
//            
//        }else{
//            SpeLog(@"获取群组状态失败");
//        }
//        
//    }
//                     failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
//                         SpeLog(@"获取群组状态失败%@",error);
//                     }];

}

//登录成功，添加OTS信息
- (void)sendOTSAccount
{
//    OTSManageLibInfo *libInfo = [OTSManageLibInfo sharedManageLibInfo];
//    libInfo.phoneNum = _account;
//    [[OTSSDKManager getMergeSDK] registerWithProvince:@"安徽"
//                                                 city:@""
//                                          projectCode:@"ios"
//                                             phoneNum:_account
//                                         SuccessBlock:^(NSString *infomation) {
//                                         }
//                                          FailedBlock:^(NSString *error) {
//                                              ;
//                                          }];
}

@end



#pragma mark -------------------自动登录------------------

@implementation AutoLoginModel

+ (instancetype)obtain
{
//    NSDictionary *loginDic = [LoginUserUtil getDicFromCurrentSavedUserPlist];
//    
//    BOOL isAutoLogin = [loginDic[@"autoLogin"] isEqualToString:@"1"];
//    
//    if (!isAutoLogin) {
//        return nil;
//    }
//    
//    AutoLoginModel *model = [AutoLoginModel mj_objectWithKeyValues:loginDic];
//    
//    return model;
    return nil;

}

//游客账号密码，功能屏蔽
//if (isTeacher) {
//    strVisitorName = KEY_IS_PRODUCTION ? @"18214749690" : @"13739270020";
//    strPwd         = KEY_IS_PRODUCTION ? @"xxthjy02"    : @"1234";
//}else{
//    strVisitorName = KEY_IS_PRODUCTION ? @"18214749686" : @"13739270024";
//    strPwd         = KEY_IS_PRODUCTION ? @"xxthjy01"    : @"1234";
//}

@end
