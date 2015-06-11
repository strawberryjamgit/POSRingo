//
//  Goods.h
//  starprint
//
//  Created by hanoimacmini on 93//15.
//  Copyright (c) 2015 hanoimacmini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goods : NSObject
@property (nonatomic,strong) NSString *GoodsCode;
@property (nonatomic,strong) NSString *GoodsName;
@property (nonatomic,strong) NSString *Units;
@property  double Price;//StanderdPriceNoTax
@property (nonatomic,strong) NSString *ColorCode;
@property (nonatomic,strong) NSString *ColorName;
@property (nonatomic,strong) NSString *SizeCode;
@property (nonatomic,strong) NSString *SizeName;
@property (nonatomic,strong) NSString *BarCode;

@end
