//
//  MainCollectionViewFlowLayout.h
//  ControlTest
//
//  Created by yangjuanping on 16/3/9.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCollectionManager.h"

@interface MainCollectionViewFlowLayout : UICollectionViewFlowLayout
-(id)initWithPerRowNum:(NSInteger)perRowNum;
@end
