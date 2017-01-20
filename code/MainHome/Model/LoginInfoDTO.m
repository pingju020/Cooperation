//
//  LoginInfoDTO.m
//  xxt_xj
//
//  Created by Yang on 15/2/4.
//  Copyright (c) 2015年 Points. All rights reserved.
//

#import "LoginInfoDTO.h"

@implementation LoginReturnInfoDTO
- (void)encodeFromDictionary:(NSDictionary *)dic {
    if (dic == nil) {
        return;
    }
    self.userId = [dic objectForKey:@"userId"];
    self.userName = [dic objectForKey:@"userName"];
    self.orgin = [dic objectForKey:@"orgin"];
    self.avatar = [dic objectForKey:@"avatar"];
    self.userType = [dic objectForKey:@"userType"];
    self.token = [dic objectForKey:@"token"];
    self.replyName = [dic objectForKey:@"replyName"];
    self.creditScore = [dic objectForKey:@"creditScore"];
    self.creditScoreEndtime = [dic objectForKey:@"creditScoreEndtime"];
    self.isSign = [dic objectForKey:@"isSign"];
    self.isChat = [dic objectForKey:@"isChat"];
    
    if (IsStrEmpty(self.userId)) {
        self.userId = @"";
    }
    if (IsStrEmpty(self.userName)) {
        self.userName = @"";
    }
    if (IsStrEmpty(self.orgin)) {
        self.orgin = @"";
    }
    if (IsStrEmpty(self.avatar)) {
        self.avatar = @"";
    }
    if (IsStrEmpty(self.userType)) {
        self.userType = @"";
    }
    if (IsStrEmpty(self.token)) {
        self.token = @"";
    }
    if (IsStrEmpty(self.replyName)) {
        self.replyName = @"";
    }
    if (IsStrEmpty(self.creditScore)) {
        self.creditScore = @"";
    }
    if (IsStrEmpty(self.creditScoreEndtime)) {
        self.creditScoreEndtime = @"";
    }
    if (IsStrEmpty(self.isSign)) {
        self.isSign = @"";
    }
    if (IsStrEmpty(self.isChat)) {
        self.isChat = @"";
    }

}
@end
@implementation AutoLoginInfoDTO
- (void)encodeFromDictionary:(NSDictionary *)dic {
    if (dic == nil) {
        return;
    }
    self.userId = [dic objectForKey:@"userId"];
    self.userName = [dic objectForKey:@"userName"];
    self.token = [dic objectForKey:@"token"];
    if (IsStrEmpty(self.userId)) {
        self.userId = @"";
    }
    if (IsStrEmpty(self.userName)) {
        self.userName = @"";
    }
    if (IsStrEmpty(self.token)) {
        self.token = @"";
    }

}

@end
@implementation LoginUserChildrenInfoDTO
- (void)encodeFromDictionary:(NSDictionary *)dic {
    if (dic == nil) {
        return;
    }
    self.childrenId = [self getValueFrom:dic byKey:@"id"];
    self.childrenName = [self getValueFrom:dic byKey:@"name"];
    self.isActive = [self getValueFrom:dic byKey:@"isActive"];
    self.childrenpPhone = [self getValueFrom:dic byKey:@"phone"];
    self.remoteId = [self getValueFrom:dic byKey:@"remoteId"];
    self.ChildrenSchool = [self getValueFrom:dic byKey:@"school"];
//    self.parentId = [LoginUserUtil userId];
    NSString* strUrl = [self getValueFrom:dic byKey:@"cavatar"];
    if (strUrl.length > 0) {
        //self.childHeadImgUrl = [NSString stringWithFormat:@"%@/educloud_share/%@",XJ_SERVER, strUrl];
    }
    else{
        self.childHeadImgUrl = @"";
    }
    self.classId = [self getValueFrom:dic byKey:@"classId"];
    self.className = [self getValueFrom:dic byKey:@"classname"];
    self.sex = [self getValueFrom:dic byKey:@"sex"];
    self.schoolName = [self getValueFrom:dic byKey:@"schoolname"];
    self.kindred = [self getValueFrom:dic byKey:@"kindred"];
    self.birthday = [self getValueFrom:dic byKey:@"birthday"];
    self.modifyDate = [self getValueFrom:dic byKey:@"modifydDate"];
    self.gradeid = [self getValueFrom:dic byKey:@"gradeid"];
    self.gradename = [self getValueFrom:dic byKey:@"gradename"];
}

-(NSString*)getValueFrom:(NSDictionary*)dicData byKey:(NSString*)strKey{
    NSString* strValue = [dicData objectForKey:strKey];
    if (strValue == nil) {
        return @"";
    }
    return strValue;
}
@end
