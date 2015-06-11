//
//  Utility.h
//  POSRingo
//
//  Created by hanoimacmini on 155//15.
//  Copyright (c) 2015年 strawberryjam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "db_sqlite.h"
@interface Utility : NSObject{
    
}
+(BOOL) isValidateDOB:(NSString *) dateOfBirth;
+(BOOL)ContainsString:(NSString*)rangeOfString :(NSString*)other;
+(NSString *)formatDate:(NSDate *)date;
+(UILabel *)createLabel:(CGRect)rect
                   font:(NSString *)font
                   size:(int)size
                   text:(NSString *)text;
+(NSString*)getCurrentTime:(NSString*)formattime;
-(NSString *)createSeqnoNum:(NSString *)tablename :(NSString*)ClientID :(int)len;
@end
