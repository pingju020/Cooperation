//
//  LoginInfoDTO.h
//  xxt_xj
//
//  Created by Yang on 15/2/4.
//  Copyright (c) 2015年 Points. All rights reserved.
//

#import "DataBaseModel.h"

@interface LoginReturnInfoDTO : DataBaseModel
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *orgin;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *replyName;
@property (nonatomic, strong) NSString *creditScore;
@property (nonatomic, strong) NSString *creditScoreEndtime;
@property (nonatomic, strong) NSString *isSign;
@property (nonatomic, strong) NSString *isChat;
@end

@interface AutoLoginInfoDTO : DataBaseModel
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *isAutoLogin;


@end

@interface LoginUserChildrenInfoDTO : DataBaseModel
@property (nonatomic, strong) NSString *childrenId;
@property (nonatomic, strong) NSString *childrenName;
@property (nonatomic, strong) NSString *isActive;
@property (nonatomic, strong) NSString *childrenpPhone;
@property (nonatomic, strong) NSString *remoteId;
@property (nonatomic, strong) NSString *ChildrenSchool;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *childHeadImgUrl;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *kindred;
@property (nonatomic, strong) NSString *schoolName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *modifyDate;
@property (nonatomic, strong) NSString *gradeid;
@property (nonatomic, strong) NSString *gradename;
@end