//
//  RegisterModel.m
//  anhui
//
//  Created by 葛君语 on 2016/10/24.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "RegisterModel.h"

NSString *const kRegisterSuccessNotification = @"kRegisterSuccessNotification";

static NSString *safetyEncodeDicionary(NSDictionary *dict,NSString *key){
    if (!dict || !dict[key]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",dict[key]];
    
}

@implementation RegisterModel

//单例
+ (instancetype)shared
{
    static RegisterModel *_m;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _m = [RegisterModel new];
    });
    return _m;
}




@end


@implementation GradeListModel

+ (NSArray *)parsingGradeListWithList:(NSArray *)list
{
    if (IsArrEmpty(list)) {
        return @[];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [list enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        GradeListModel *model = [GradeListModel new];
        
        model.gradeId = safetyEncodeDicionary(dict, @"grade");
        model.name    = safetyEncodeDicionary(dict, @"name");
        
        model.classList = [ClassListModel parsingClassListWithList:dict[@"classList"]];
        
        [arr addObject:model];
    }];
    
    return [arr copy];
}





@end


@implementation ClassListModel


+ (NSArray *)parsingClassListWithList:(NSArray *)list
{
    if (IsArrEmpty(list)) {
        return @[];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [list enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        ClassListModel *model = [ClassListModel new];
        
        model.classId = safetyEncodeDicionary(dict, @"id");
        model.name    = safetyEncodeDicionary(dict, @"name");
        
        [arr addObject:model];
    }];
    
    return [arr copy];
}

@end


@implementation ItemInfoModel

+ (NSArray *)parsingItemInfoListWithList:(NSArray *)list
{
    if (IsArrEmpty(list)) {
        return @[];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [list enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        ItemInfoModel *model = [ItemInfoModel new];
        
        model.infoId   = safetyEncodeDicionary(dict, @"id");
        model.infoDesc = safetyEncodeDicionary(dict, @"name");
        
        [arr addObject:model];
    }];
    
    return [arr copy];
}

@end


@implementation RegisterStatusModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.status     = safetyEncodeDicionary(dict, @"status");
        self.phone      = safetyEncodeDicionary(dict, @"phone");
        self.agent_name = safetyEncodeDicionary(dict, @"agent_name");
        self.agent_tel  = safetyEncodeDicionary(dict, @"agent_tel");
        self.studentid  = safetyEncodeDicionary(dict, @"studentid");
    }
    return self;
}


@end


