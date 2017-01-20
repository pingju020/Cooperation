//
//  HttpSessionManager.m
//  Cooperation
//
//  Created by yangjuanping on 16/10/26.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "HttpSessionManager.h"
#import "XXTEncrypt.h"
#import "NSDictionary+ValueCheck.h"
#import "DES3Util.h"

static NSString* kXjServerNew = nil;
static NSString* kTermManu = nil;
static NSString* kToken = nil;

@implementation HttpSessionManager
SINGLETON_FOR_CLASS(HttpSessionManager)

+(void)load{
    kXjServerNew = KEY_IS_PRODUCTION?@"http://120.210.214.20:8080/educloud/api/terminal":@"http://221.130.6.212:4887/educloud/api/terminal";
    
    kTermManu = [NSString stringWithFormat:@"%@,%@,i01,%@,%@", [[UIDevice currentDevice] model],[[UIDevice currentDevice] systemVersion],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],@""];
}

-(void)setToken:(NSString*)token{
    kToken = token;
}

-(NSString*)getTermManu{
    return kTermManu;
}

-(NSString*)getOrigin{
    return @"ios";
}

-(NSString*)getXjServer{
    return kXjServerNew;
}


- (id)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:kXjServerNew]];
    if(self)
    {
        //并发线程数
        [self.operationQueue setMaxConcurrentOperationCount:10];
        AFHTTPRequestSerializer * serial = [[AFHTTPRequestSerializer alloc]init];
        [serial setValue:@"application/json"  forHTTPHeaderField:@"Accept"];
        [self setRequestSerializer:serial];
        AFCompoundResponseSerializer *responseSerializer = [[AFCompoundResponseSerializer alloc] init];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
        [self setResponseSerializer:responseSerializer];
    }
    return self;
}


#pragma mark -- 适用于安徽和教育的token生成方法
-(NSString*)GetExternToken{
    if (IsStrEmpty(kToken)) {
        return [XXTEncrypt extendDES:@""];
    }
    return [XXTEncrypt extendDES:kToken];
}

-(NSString*)getExternNullToken{
    return [XXTEncrypt extendDES:@""];
}

//取消所有请求
- (void)cancelAllReq:(id)pointer
{
    [self.operationQueue cancelAllOperations];
}

#pragma mark - 封装过的网络请求接口


- (void)startNormalGetWith:( NSString *)url
                  paragram:(NSDictionary *)para
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
////    NSURL *_url = [NSURL URLWithString:[url  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
////    NSURLRequest *req = [NSURLRequest requestWithURL:_url];
//    AFHTTPSessionManager*  session = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kXjServerNew]];
//    //SpeLog(@"return=====request===%@",operation.request);
//    [session GET:url parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (success) {
//            //id res  = [ objectFromJSONString];
//            //success((NSDictionary *)res);
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    [self GET:url parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


//普通的post请求 算sig
- (void)startNormalPostWithParagram:(NSDictionary *)para
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    para = [para addSigdic:(NSMutableDictionary *)para];
    [self POST:kXjServerNew parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* strResult = [DES3Util decryptData:responseObject];
        NSData *data = [strResult dataUsingEncoding:NSUTF8StringEncoding];
        
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"request = %@,result = %@", para,result);
        NSLog(@"request = %@,result = %@", [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding],result);
        if ([result isKindOfClass:[NSDictionary class]]) {
            BOOL bRet = [[NSString stringWithFormat:@"%@",[result objectForKey:@"result"]] isEqualToString:@"1"] || [[NSString stringWithFormat:@"%@",[result objectForKey:@"ret"]] isEqualToString:@"0"];
            if (bRet) {
                success(result, YES);
            }
            else{
                success(result, NO);
            }
        }
        else{
            NSDictionary* dic = @{@"ret":@"-99",
                                  @"msg":@"invalid response data!"};
            success(dic, NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"request = %@,error = %@", task.originalRequest,error);
        failed(self, error);
    }];
}

//普通的post请求 不算sig
- (void)startNormalPostWithNoSig:( NSString *)url
                        paragram:(NSDictionary *)para
                  successedBlock:(SuccessedBlock)success
                     failedBolck:(FailedBlock)failed
{
    [self POST:kXjServerNew parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* strResult = [DES3Util decryptData:responseObject];
        NSLog(@"strResult = %@",strResult);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
}



//上传file类型的post请求
- (void)startVoiceMulitDataPost:( NSString *)url
                       postFile:(NSData *)uploadFileData
                       paragram:(NSDictionary *)para
                 successedBlock:(SuccessedBlock)success
                    failedBolck:(FailedBlock)failed
{
//    para = [para addSigdic:(NSMutableDictionary *)para];
//    [self POST:url
//    parameters:para
//constructingBodyWithBlock:^(id <AFMultipartFormData> formData)
//     {
//         if(uploadFileData)
//         {
//             [formData appendPartWithFileData:uploadFileData name:@"fileupload" fileName:@"voice.spx" mimeType:@"image/jpg"];
//         }
//     }
//       success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         if(success)
//         {
//             NSString *responseString = [DES3Util decrypt:operation.responseString];
//             
//             id res  = [responseString objectFromJSONString];
//             SpeAssert([res isKindOfClass:[NSDictionary class]]);
//             success((NSDictionary *)res);
//         }
//         SpeLog(@"responseObject==%@",responseObject);
//     }
//       failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         if (failed)
//         {
//             failed(nil, error);
//         }
//     }
//     ];
}

//上传视频post请求
- (void)startVideoMulitDataPost:( NSString *)url
                       postFile:(NSData *)uploadFileData
                       paragram:(NSDictionary *)para
                 successedBlock:(SuccessedBlock)success
                    failedBolck:(FailedBlock)failed
{
//    para = [para addSigdic:(NSMutableDictionary *)para];
//    [self POST:url
//    parameters:para
//constructingBodyWithBlock:^(id <AFMultipartFormData> formData)
//     {
//         if(uploadFileData)
//         {
//             [formData appendPartWithFileData:uploadFileData name:@"fileupload" fileName:@"video.mp4" mimeType:@"video/mp4"];
//         }
//     }
//       success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         if(success)
//         {
//             NSString *responseString = [DES3Util decrypt:operation.responseString];
//             
//             id res  = [responseString objectFromJSONString];
//             SpeAssert([res isKindOfClass:[NSDictionary class]]);
//             success((NSDictionary *)res);
//         }
//         SpeLog(@"responseObject==%@",responseObject);
//     }
//       failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         if (failed)
//         {
//             failed(nil, error);
//         }
//     }
//     ];
}


//上传file类型的post请求
- (void)startMulitDataPost:( NSString *)url
                  postFile:(NSData *)uploadFileData
                  paragram:(NSDictionary *)para
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
//    para = [para addSigdic:(NSMutableDictionary *)para];
//    [self POST:url
//    parameters:para
//constructingBodyWithBlock:^(id <AFMultipartFormData> formData)
//     {
//         if(uploadFileData)
//         {
//             [formData appendPartWithFileData:uploadFileData name:@"fileupload" fileName:@"pic.jpg" mimeType:@"image/jpg"];
//         }
//     }
//       success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         if(success)
//         {
//             NSString *responseString = [DES3Util decrypt:operation.responseString] == nil ?@"":[DES3Util decrypt:operation.responseString];
//             
//             id res  = [responseString objectFromJSONString];
//             SpeAssert([res isKindOfClass:[NSDictionary class]]);
//             success((NSDictionary *)res);
//         }
//         SpeLog(@"responseObject==%@",responseObject);
//     }
//       failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         if (failed)
//         {
//             failed(nil, error);
//         }
//     }
//     ];
}

@end
