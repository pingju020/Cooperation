//
//  DES3Util.h
//

#import <Foundation/Foundation.h>

#define gkey                            @"EDUCLOUDEDUCLOUDEDUCLOUD" //秘钥
#define AH_ClassSpace_gkey			@"JQRjlsHPDVv9x7Se" //秘钥
#define gIv                         @"01234567"                 // 向量
#define gdq             @"njxtqgjyptfromlianchuang"
#define gdkey           @"EDUCLOUDEDUCLOUDEDUCLOUD"

#define gAdsKey			@"cb0727d1fa9a7b24cec24f72" //秘钥


@interface DES3Util : NSObject {
    
}

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;

// 加密方法
+ (NSString*)encryptForClassSpace:(NSString*)plainText;

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText;

+(NSString*)decryptData:(NSData *)encryptData;

+ (NSString*)decryptTimeError:(NSString*)encryptText;

#pragma mark - 广告加密
// 加密方法
+ (NSString*)encryptWithAds:(NSString*)plainText;
// 解密方法
+ (NSString*)decryptWithAds:(NSString*)encryptText;

@end

