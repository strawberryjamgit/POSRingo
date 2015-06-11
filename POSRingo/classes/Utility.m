//
//  Utility.m
//  POSRingo
//
//  Created by hanoimacmini on 155//15.
//  Copyright (c) 2015年 strawberryjam. All rights reserved.
//

#import "Utility.h"

@implementation Utility
+(BOOL) isValidateDOB:(NSString *) dateOfBirth
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    [format setDateFormat:@"yyyy/MM/dd"];
    NSDate *validateDOB = [format dateFromString:dateOfBirth];
    if (validateDOB != nil)
        return YES;
    else
        return NO;
}
+(NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy'/'MM'/'dd"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}
+(UILabel *)createLabel:(CGRect)rect
                    font:(NSString *)font
                    size:(int)size
                    text:(NSString *)text {
    UILabel *lbl = [[UILabel alloc] initWithFrame:rect];
    [lbl setFont:[UIFont fontWithName:font size:size]];
    [lbl setAdjustsFontSizeToFitWidth:YES];
    lbl.text = text;
    
    return lbl;
}
+(BOOL)ContainsString:(NSString*)rangeOfString :(NSString*)other {
    if ([rangeOfString rangeOfString:other].location != NSNotFound)
    {
        return YES;
    }else return NO;
}
-(NSString *)createSeqnoNum:(NSString *)tablename :(NSString*)ClientID :(int)len{
    int seqno;
    int cntZero=0;
    NSString *strCode=@"";
    NSString *strSQL;
    db_sqlite *sqlite=[db_sqlite alloc];
    NSString *dbpath=[sqlite getDbFilePath];
    strSQL=@" update createSeqno set seqnumber=seqnumber+1 where tablename='";
    strSQL=[strSQL stringByAppendingString:tablename];
    strSQL=[strSQL stringByAppendingString:@"'"];
    [sqlite updateRecord:dbpath :strSQL];
    //selcect seqno
    strSQL=@" select * from createSeqno where tablename='";
    strSQL=[strSQL stringByAppendingString:tablename];
    strSQL=[strSQL stringByAppendingString:@"'"];
    seqno=[sqlite getMaxseqno:dbpath :strSQL];
    strCode=ClientID;
    cntZero=len-3;
    NSString *paddingFormat=[NSString stringWithFormat:@"%%0%dd",cntZero];
    strCode=[strCode stringByAppendingString:[NSString stringWithFormat:paddingFormat,seqno]];
    return  strCode;
    
}
+(NSString*)getCurrentTime:(NSString*)formattime{
    NSString *time;
    NSDate *now=[NSDate date];
    NSDateFormatter *dateformater=[[NSDateFormatter alloc] init];
    dateformater.dateFormat=formattime;
    [dateformater setTimeZone:[NSTimeZone systemTimeZone]];
    time=[NSString stringWithFormat:@"%@",[dateformater stringFromDate:now]];
    return time;
}
-(int)getCusAccPoint:(NSString*)CustomerCode :(NSString*)InvoiceDate :(NSString*)Time{
    int point=0;
    return point;
}
@end
