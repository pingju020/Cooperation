//
//  LaunchImageView.m
//  anhui
//
//  Created by 葛君语 on 16/7/4.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "LaunchImageView.h"
#import "UIImageView+WebCache.h"
#import "HttpLoginAndRegister.h"

@interface LaunchImageView ()
@property (nonatomic,copy) NSString *picType;
@property (nonatomic,copy) NSString *placeholderImageName;
@property (nonatomic,copy) NSString *picKey;
//@property (nonatomic,copy) NSString *picPath;

@property (nonatomic,assign) BOOL is3sDelay;

@end


@implementation LaunchImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


-(BOOL)UPdateLaunchImg:(NSString*)strPicKey URL:(NSString*)strUrl{
    if (![strPicKey isEqualToString:self.picKey] && strUrl.length >0) {
        [self sd_setImageWithURL:[NSURL URLWithString:strUrl]
                placeholderImage:self.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    //png格式
                    NSData *imagedata=UIImagePNGRepresentation(image);
                    //JEPG格式
                    //NSData *imagedata=UIImageJEPGRepresentation(image,1.0);
                    
                    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                    NSString *documentsDirectory=[paths objectAtIndex:0];
                    
                    NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:@"saveFore.png"];
                    [imagedata writeToFile:savedImagePath atomically:YES];
                    
                }];
        self.picKey = strPicKey;
        [[NSUserDefaults standardUserDefaults] setObject:self.picKey forKey:@"lauchimg_key"];
        return YES;
    }
    return NO;
}

#pragma mark -setup
- (void)setup
{
    self.picKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"lauchimg_key"];
    if (self.picKey.length > 0) {
        NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *documentsDirectory=[paths objectAtIndex:0];
        
        NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:@"saveFore.png"];
        self.image = [UIImage imageWithContentsOfFile:savedImagePath];
    }
    else{
        self.image = [UIImage imageNamed:self.placeholderImageName];
    }
    
    //获取图片信息
    [[HttpLoginAndRegister sharedInstance]
           getLoginPicWithType:self.picType
     successBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
         if (isSucceed){
             [self UPdateLaunchImg:succeedResult[@"pic_key"] URL:succeedResult[@"pic_path"]];
         }
     } failedBlock:^(AFHTTPSessionManager *session, NSError *error) {
         NSLog(@"广告页请求失败%@",error);
     }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.is3sDelay = YES;
    });

    
}

#pragma mark -properties
- (void)setIs3sDelay:(BOOL)is3sDelay
{
    _is3sDelay = is3sDelay;
    
    if (is3sDelay && _isFinishLogin) {
        if (self.removeHandle) {
            self.removeHandle();
        }
    }
    
}

- (void)setIsFinishLogin:(BOOL)isFinishLogin
{
    _isFinishLogin = isFinishLogin;
    
    if (isFinishLogin && _is3sDelay) {
        if (self.removeHandle) {
            self.removeHandle();
        }
    }
    
}


#pragma mark -LOAD
- (NSString *)picType
{
//    if (!_picType) {
//        if (is_iPhone4_4s) {
//            _picType = @"1";
//        }else if (is_iPhone5){
//            _picType = @"2";
//        }else if (is_iPhone6){
//            _picType = @"3";
//        }else if (is_iPhone6_plus){
//            _picType = @"4";
//        }else{
//            _picType = @"3";
//        }
//
//    }
//    return _picType;
    return @"3";
}

- (NSString *)placeholderImageName
{
//    if (!_placeholderImageName) {
//        if (is_iPhone4_4s) {
//            _placeholderImageName = @"LaunchImage-700@2x";
//        }else if (is_iPhone5){
//            _placeholderImageName = @"LaunchImage-700-568h@2x";
//        }else if (is_iPhone6){
//            _placeholderImageName = @"LaunchImage-800-667h@2x";
//        }else if (is_iPhone6_plus){
//            _placeholderImageName = @"LaunchImage-800-Portrait-736h@3x";
//        }
//    }
//    return _placeholderImageName;
    return @"LaunchImage-800-667h@2x";
}



@end
