//
//  HttpSessionManager.h
//  Cooperation
//
//  Created by yangjuanping on 16/10/26.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "AFNetworking.h"

#define HTTP_MANAGER [HttpSessionManager  sharedInstance]

@interface HttpSessionManager : AFHTTPSessionManager

SINGLETON_FOR_HEADER(HttpSessionManager)

typedef void (^SuccessedBlock)(NSDictionary *succeedResult, BOOL isSucceed);

typedef void (^downFileSuccessedBlock)(NSString *lcoalPath);

typedef void (^FailedBlock)(AFHTTPSessionManager *session, NSError *error);

typedef void (^FailBlock)(NSError *error);

-(void)setToken:(NSString*)token;

-(NSString*)getTermManu;

-(NSString*)getExternNullToken;

-(NSString*)GetExternToken;

-(NSString*)getOrigin;

-(NSString*)getXjServer;

- (void)startNormalPostWithParagram:(NSDictionary *)para
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed;

@end
