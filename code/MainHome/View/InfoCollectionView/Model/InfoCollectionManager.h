//
//  InfoCollectionManager.h
//  anhui
//
//  Created by yangjuanping on 16/3/11.
//  Copyright © 2016年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoItem.h"

@interface InfoCollectionManager : NSObject

@property (nonatomic, copy) NSString *infoSectionTitle;

@property (nonatomic, copy) NSString *infoSectionRightBtnName;

/**
 *  InfoItem的数据源
 */
@property (nonatomic, strong) NSMutableArray *infoItems;

@end
