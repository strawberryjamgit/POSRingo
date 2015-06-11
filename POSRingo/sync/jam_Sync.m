//
//  jam_Sync.m
//  starprint
//
//  Created by hanoimacmini on 272//15.
//  Copyright (c) 2015 hanoimacmini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jam_Sync.h"
#include "db_sqlite.h"

@implementation jam_Sync
@synthesize xmlParser;

- (int) registerClient:(NSString *)serversocket{
    int iRel = 1, iCount = 1;
    
    @try
    {
        db_sqlite *sqlite=[db_sqlite alloc];
        NSString *dbpath=[sqlite getDbFilePath];
        
        //Kiem tra da dang ky chua
        NSString *strSQL=@"SELECT count(*) FROM clientid";
        iCount = [sqlite countRecords:dbpath :strSQL];
        
        if (iCount==0) {
            NSString* result;
            NSData * resultXML;
            
            NSString *utfurl=[serversocket stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
            [request setTimeoutInterval:60];
            [request setHTTPMethod:@"GET"];
            [request setURL:[NSURL URLWithString:utfurl]];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *responseCode = nil;
            
            NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
            
            if([responseCode statusCode] != 200){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"ウェブサービスがエラーです。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                return 0;
            }
            
            result= [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
            resultXML=[result dataUsingEncoding:NSUnicodeStringEncoding];
            xmlParser = [[NSXMLParser alloc] initWithData: resultXML];
            [xmlParser setDelegate: self];
            [xmlParser setShouldResolveExternalEntities: YES];
            [xmlParser parse];
            NSString *strresult=soapResults;
            NSArray *arrData=[strresult componentsSeparatedByString:@"д"];
            
            if ([arrData count]>=5) {
                //Dang ky moi
                strSQL=@" INSERT INTO clientid (SeqNo,TerminalID,ShopID,ShopType,ServerSocket,TerminalName) VALUES (";
                strSQL=[strSQL stringByAppendingString:@"1,'"]; //SeqNo
                strSQL=[strSQL stringByAppendingString:[arrData objectAtIndex:0]]; //TerminalID
                strSQL=[strSQL stringByAppendingString:@"','"];
                strSQL=[strSQL stringByAppendingString:[arrData objectAtIndex:2]]; //ShopID
                strSQL=[strSQL stringByAppendingString:@"',"];
                strSQL=[strSQL stringByAppendingString:[arrData objectAtIndex:4]]; //ShopType
                strSQL=[strSQL stringByAppendingString:@",'"];
                strSQL=[strSQL stringByAppendingString:@"http://192.168.1.67:2011','"]; //ServerSocket, tam thoi fix co dinh
                strSQL=[strSQL stringByAppendingString:[arrData objectAtIndex:1]]; //TerminalName
                strSQL=[strSQL stringByAppendingString:@"')"];
                if([sqlite insertRecords:dbpath :strSQL] != 0)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"ウェブサービスがエラーです。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    return 0;
                }
            }
        }
    }
    
    @catch (NSException *ex) {
        iRel = 0;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:[NSString stringWithFormat:@"%@",ex] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    return iRel;
}

- (NSString*) statisticOfSalesHistory:(NSString *)serversocket{
    NSString *result;
    NSData *resultXML;
    NSString *vsResult = @"";
    
    @try {
        NSString *utfurl=[serversocket stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setTimeoutInterval:30*60];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:utfurl]];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *responseCode = nil;
        
        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
        
        if([responseCode statusCode] != 200){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"サーバーに接続できませんでした。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }else{
            result= [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
            resultXML=[result dataUsingEncoding:NSUnicodeStringEncoding];
            xmlParser = [[NSXMLParser alloc] initWithData: resultXML];
            [xmlParser setDelegate: self];
            [xmlParser setShouldResolveExternalEntities: YES];
            [xmlParser parse];
            vsResult = soapResults;
        }
    }
    @catch (NSException *ex) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:[NSString stringWithFormat:@"%@",ex] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
       
    return vsResult;
}

-(void)syncFromServer:(NSString *)url{
    NSString* result;
    NSData * resultXML;
    db_sqlite *sqlite=[db_sqlite alloc];
    NSString *dbpath=[sqlite getDbFilePath];
    NSString *utfurl=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:utfurl]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %li", utfurl, (long)[responseCode statusCode]);
        //return nil;
    }
    
    result= [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    resultXML=[result dataUsingEncoding:NSUnicodeStringEncoding];
    xmlParser = [[NSXMLParser alloc] initWithData: resultXML];
    //  NSDictionary *xmlDic=[XMLReader dictionaryForXMLString:result error:&parseError];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
    NSString *strresult=soapResults;// day la chuoi du lieu
    //дгдг
    //gio la luc insert du lieu
    NSArray *arrGoods=[strresult componentsSeparatedByString:@"дгдг"];
    NSString *strRecord;
    NSArray *arrField=nil;
    NSUInteger count;
    NSUInteger TableNum;
    NSUInteger fieldNum;
    NSString *strObjectID;
    NSUInteger TableDetailNum;
    NSUInteger fieldDetailNum;
    NSString *strObjectDetailID;
    NSString *strDataMaster;
    NSString *strDataDetail;
    strDataDetail=@"";
    strDataMaster=@"";
    double maxseqno=0;
    NSString *strSQL=@"";
    double dbmaxseqno;
    int j=0;
    int sqlNumFiled=0;
    int operationtype=1;
    count=[arrGoods count];
    for (int i=0;i<count-1;i++) {
        // lay tung record
        //operation type,tablenum,fieldnum,data,(detail).......
        //detail=tablenum,fieldnum,data
        strRecord=[arrGoods objectAtIndex:i];
        arrField=[strRecord componentsSeparatedByString:@"д"];
        maxseqno=[[arrField objectAtIndex:0] doubleValue];
        //operation type
        operationtype=[[arrField objectAtIndex:1] integerValue];
        //tablenum
        TableNum=[[arrField objectAtIndex:2] integerValue];
        fieldNum=[[arrField objectAtIndex:3] integerValue];
        strObjectID=[arrField objectAtIndex:4];
        switch (TableNum) {
            case 37:
                //goods
                //parse record master
                if (operationtype==1) {
                sqlNumFiled=[sqlite countFieldTable:dbpath :@" PRAGMA  table_info(goods) "];
                strDataMaster=@"(";
                    if (fieldNum<sqlNumFiled) {
                        for (j=4;j<=fieldNum+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            if ((j<75)&(j!=40)&(j!=56)) {
                                strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            }
                            if (j==fieldNum+3) {
                                //bu them du lieu
                                for (int cut=fieldNum; cut<sqlNumFiled; cut++) {
                                    strDataMaster=[strDataMaster stringByAppendingString:@"','"];
                                }
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                    }else if (fieldNum>sqlNumFiled){
                        for (j=4;j<=sqlNumFiled+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                             if ((j<75)&(j!=40)&(j!=56)) {
                                strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            }
                            if (j==sqlNumFiled+3) {
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                        j=j+fieldNum-sqlNumFiled;
                        
                    }else{
                        for (j=4;j<=fieldNum+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                             if ((j<75)&(j!=40)&(j!=56)) {
                                strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            }
                            if (j==fieldNum+3) {
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                    }
                //lam tiep detail neu co (cai nsy moi kho vkl)
                if (j<([arrField count])) {
                    //co detail
                    strDataDetail=@"(";
                    sqlNumFiled=[sqlite countFieldTable:dbpath :@" PRAGMA  table_info(goods_detail) "];
                    for (int k=j; k<([arrField count]); k++) {
                        TableDetailNum=[[arrField objectAtIndex:k] integerValue];
                        fieldDetailNum=[[arrField objectAtIndex:k+1] integerValue];
                        strObjectDetailID=[arrField objectAtIndex:k+2];
                        //xoa record (chua lam)
                        // insert
                        if (TableDetailNum==38) {
                              k=k+2;
                            int countk=k;
                            if (fieldDetailNum<sqlNumFiled) {
                                for (int n=k; n<fieldDetailNum+countk; n++) {
                                    //dong goi
                                    strDataDetail=[strDataDetail stringByAppendingString:@"'"];
                                    strDataDetail=[strDataDetail stringByAppendingString:[arrField objectAtIndex:n]];
                                    if (n==fieldDetailNum+countk-1) {
                                        for (int cut=fieldDetailNum; cut<sqlNumFiled; cut++) {
                                            strDataDetail=[strDataDetail stringByAppendingString:@"','"];
                                        }
                                        strDataDetail=[strDataDetail stringByAppendingString:@"')"];
                                    } else {
                                        strDataDetail=[strDataDetail stringByAppendingString:@"',"];
                                    }
                                    k=k+1;
                                }

                                
                            }else if(fieldDetailNum>sqlNumFiled){
                                for (int n=k; n<sqlNumFiled+countk; n++) {
                                    //dong goi
                                    strDataDetail=[strDataDetail stringByAppendingString:@"'"];
                                    strDataDetail=[strDataDetail stringByAppendingString:[arrField objectAtIndex:n]];
                                    if (n==fieldDetailNum+countk-1) {
                                        strDataDetail=[strDataDetail stringByAppendingString:@"')"];
                                    } else {
                                        strDataDetail=[strDataDetail stringByAppendingString:@"',"];
                                    }
                                    k=k+1;
                                }
                                k=k+fieldDetailNum-sqlNumFiled;
                                
                            }else{
                                for (int n=k; n<fieldDetailNum+countk; n++) {
                                    //dong goi
                                    strDataDetail=[strDataDetail stringByAppendingString:@"'"];
                                    strDataDetail=[strDataDetail stringByAppendingString:[arrField objectAtIndex:n]];
                                    if (n==fieldDetailNum+countk-1) {
                                        strDataDetail=[strDataDetail stringByAppendingString:@"')"];
                                    } else {
                                        strDataDetail=[strDataDetail stringByAppendingString:@"',"];
                                    }
                                    k=k+1;
                                }

                            }                                                       //
                            strDataDetail=[strDataDetail stringByAppendingString:@",("];
                        }
                        else{
                            k=k+2+(int)fieldDetailNum;
                        }
                         k=k-1;
                        if (k>=([arrField count])) {
                            break;
                        }
                        
                    }
                }
                if (![strDataDetail isEqual:@"("]) {
                    strDataDetail=[strDataDetail substringToIndex:strDataDetail.length-2];
                }
                
                //xoa record cu (chua lam)
                //delete thang goods
                if (![strObjectID isEqual:@""]) {
                strSQL=@" delete from goods where seqno='";
                strSQL=[strSQL stringByAppendingString:strObjectID];
                strSQL=[strSQL stringByAppendingString:@"'"];
                [sqlite deleteRecords:dbpath :strSQL];
                    //xoa detail
                strSQL=@" delete from goods_detail where rseqno='";
                strSQL=[strSQL stringByAppendingString:strObjectID];
                strSQL=[strSQL stringByAppendingString:@"'"];
                [sqlite deleteRecords:dbpath :strSQL];
                }
                
                //insert data o day
                //insert goods
                if (![strDataMaster isEqual:@"("]) {
                 strSQL=@" INSERT INTO goods  VALUES ";
                strSQL=[strSQL stringByAppendingString:strDataMaster];
                [sqlite insertRecords:dbpath :strSQL];
                }
                //insert goods_detail
                if (![strDataDetail isEqual:@"("]) {
                strSQL=@" INSERT INTO goods_detail  VALUES ";
                strSQL=[strSQL stringByAppendingString:strDataDetail];
                [sqlite insertRecords:dbpath :strSQL];
                }
                }
                else{
                    // xoa sp
                    //xoa record cu (chua lam)
                    //delete thang goods
                    if (![strObjectID isEqual:@""]) {
                        strSQL=@" delete from goods where seqno='";
                        strSQL=[strSQL stringByAppendingString:strObjectID];
                        strSQL=[strSQL stringByAppendingString:@"'"];
                        [sqlite deleteRecords:dbpath :strSQL];
                        //xoa detail
                        strSQL=@" delete from goods_detail where rseqno='";
                        strSQL=[strSQL stringByAppendingString:strObjectID];
                        strSQL=[strSQL stringByAppendingString:@"'"];
                        [sqlite deleteRecords:dbpath :strSQL];
                    }
                    

                }
                break;
            case 65:
                //retialcustomer
                //parse record master
                
                if (operationtype==1) {
                sqlNumFiled=[sqlite countFieldTable:dbpath :@" PRAGMA  table_info(retailcustomer) "];
                strDataMaster=@"(";
                if (fieldNum<sqlNumFiled) {
                    for (j=4;j<=fieldNum+3;j++) {
                        strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                        if (j==fieldNum+3) {
                            //bu them du lieu
                            for (int cut=fieldNum; cut<sqlNumFiled; cut++) {
                                strDataMaster=[strDataMaster stringByAppendingString:@"','"];
                            }
                            strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                        } else {
                            strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                        }
                        
                    }
                }else if (fieldNum>sqlNumFiled){
                    for (j=4;j<=sqlNumFiled+3;j++) {
                        strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                        if (j==sqlNumFiled+3) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                        } else {
                            strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                        }
                        
                    }
                    j=j+fieldNum-sqlNumFiled;
                    
                }else{
                    for (j=4;j<=fieldNum+3;j++) {
                        strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                        if (j==fieldNum+3) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                        } else {
                            strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                        }
                        
                    }
                }

                //xoa record cu (chua lam)
                //delete thang retailcustomer
                if (![strObjectID isEqual:@""]) {
                    strSQL=@" delete from retailcustomer where seqno='";
                    strSQL=[strSQL stringByAppendingString:strObjectID];
                    strSQL=[strSQL stringByAppendingString:@"'"];
                    [sqlite deleteRecords:dbpath :strSQL];
                }
                
                //insert data o day
                //insert retailcustomer
                if (![strDataMaster isEqual:@"("]) {
                    strSQL=@" INSERT INTO retailcustomer  VALUES ";
                    strSQL=[strSQL stringByAppendingString:strDataMaster];
                    [sqlite insertRecords:dbpath :strSQL];
                }
                }else{
                    //delete thang retailcustomer
                    if (![strObjectID isEqual:@""]) {
                        strSQL=@" delete from retailcustomer where seqno='";
                        strSQL=[strSQL stringByAppendingString:strObjectID];
                        strSQL=[strSQL stringByAppendingString:@"'"];
                        [sqlite deleteRecords:dbpath :strSQL];
                    }
                }
                break;
            case 11:
                //staff
                //parse record master
                if (operationtype==1) {
                    sqlNumFiled=[sqlite countFieldTable:dbpath :@" PRAGMA  table_info(staff) "];
                    strDataMaster=@"(";
                    if (fieldNum<sqlNumFiled) {
                        for (j=4;j<=fieldNum+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            if (j==fieldNum+3) {
                                //bu them du lieu
                                for (int cut=fieldNum; cut<sqlNumFiled; cut++) {
                                    strDataMaster=[strDataMaster stringByAppendingString:@"','"];
                                }
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                    }else if (fieldNum>sqlNumFiled){
                        for (j=4;j<=sqlNumFiled+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            if (j==sqlNumFiled+3) {
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                        j=j+fieldNum-sqlNumFiled;
                        
                    }else{
                        for (j=4;j<=fieldNum+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            if (j==fieldNum+3) {
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                    }
                    
                    //xoa record cu (chua lam)
                    //delete thang retailcustomer
                    if (![strObjectID isEqual:@""]) {
                        strSQL=@" delete from staff where seqno='";
                        strSQL=[strSQL stringByAppendingString:strObjectID];
                        strSQL=[strSQL stringByAppendingString:@"'"];
                        [sqlite deleteRecords:dbpath :strSQL];
                    }
                    
                    //insert data o day
                    //insert retailcustomer
                    if (![strDataMaster isEqual:@"("]) {
                        strSQL=@" INSERT INTO staff  VALUES ";
                        strSQL=[strSQL stringByAppendingString:strDataMaster];
                        [sqlite insertRecords:dbpath :strSQL];
                    }
                }else{
                    //delete thang retailcustomer
                    if (![strObjectID isEqual:@""]) {
                        strSQL=@" delete from staff where seqno='";
                        strSQL=[strSQL stringByAppendingString:strObjectID];
                        strSQL=[strSQL stringByAppendingString:@"'"];
                        [sqlite deleteRecords:dbpath :strSQL];
                    }
                }

                
                break;

            case 12:
                //shop
                //parse record master
                if (operationtype==1) {
                    sqlNumFiled=[sqlite countFieldTable:dbpath :@" PRAGMA  table_info(shop) "];
                    strDataMaster=@"(";
                    if (fieldNum<sqlNumFiled) {
                        for (j=4;j<=fieldNum+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            if (j==fieldNum+3) {
                                //bu them du lieu
                                for (int cut=fieldNum; cut<sqlNumFiled; cut++) {
                                    strDataMaster=[strDataMaster stringByAppendingString:@"','"];
                                }
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                    }else if (fieldNum>sqlNumFiled){
                        for (j=4;j<=sqlNumFiled+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            if (j==sqlNumFiled+3) {
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                        j=j+fieldNum-sqlNumFiled;
                        
                    }else{
                        for (j=4;j<=fieldNum+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            if (j==fieldNum+3) {
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                    }
                    
                    //xoa record cu (chua lam)
                    //delete thang retailcustomer
                    if (![strObjectID isEqual:@""]) {
                        strSQL=@" delete from shop where seqno='";
                        strSQL=[strSQL stringByAppendingString:strObjectID];
                        strSQL=[strSQL stringByAppendingString:@"'"];
                        [sqlite deleteRecords:dbpath :strSQL];
                    }
                    
                    //insert data o day
                    //insert retailcustomer
                    if (![strDataMaster isEqual:@"("]) {
                        strSQL=@" INSERT INTO shop  VALUES ";
                        strSQL=[strSQL stringByAppendingString:strDataMaster];
                        [sqlite insertRecords:dbpath :strSQL];
                    }
                }else{
                    //delete thang retailcustomer
                    if (![strObjectID isEqual:@""]) {
                        strSQL=@" delete from shop where seqno='";
                        strSQL=[strSQL stringByAppendingString:strObjectID];
                        strSQL=[strSQL stringByAppendingString:@"'"];
                        [sqlite deleteRecords:dbpath :strSQL];
                    }
                }
                break;
            case 30:
                //credit
                //parse record master
                if (operationtype==1) {
                    sqlNumFiled=[sqlite countFieldTable:dbpath :@" PRAGMA  table_info(credit) "];
                    strDataMaster=@"(";
                    if (fieldNum<sqlNumFiled) {
                        for (j=4;j<=fieldNum+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            if (j==fieldNum+3) {
                                //bu them du lieu
                                for (int cut=fieldNum; cut<sqlNumFiled; cut++) {
                                    strDataMaster=[strDataMaster stringByAppendingString:@"','"];
                                }
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                    }else if (fieldNum>sqlNumFiled){
                        for (j=4;j<=sqlNumFiled+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            if (j==sqlNumFiled+3) {
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                        j=j+fieldNum-sqlNumFiled;
                        
                    }else{
                        for (j=4;j<=fieldNum+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            if (j==fieldNum+3) {
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                    }
                    
                    //xoa record cu (chua lam)
                    //delete thang retailcustomer
                    if (![strObjectID isEqual:@""]) {
                        strSQL=@" delete from credit where seqno='";
                        strSQL=[strSQL stringByAppendingString:strObjectID];
                        strSQL=[strSQL stringByAppendingString:@"'"];
                        [sqlite deleteRecords:dbpath :strSQL];
                    }
                    
                    //insert data o day
                    //insert retailcustomer
                    if (![strDataMaster isEqual:@"("]) {
                        strSQL=@" INSERT INTO credit  VALUES ";
                        strSQL=[strSQL stringByAppendingString:strDataMaster];
                        [sqlite insertRecords:dbpath :strSQL];
                    }
                }else{
                    //delete thang retailcustomer
                    if (![strObjectID isEqual:@""]) {
                        strSQL=@" delete from credit where seqno='";
                        strSQL=[strSQL stringByAppendingString:strObjectID];
                        strSQL=[strSQL stringByAppendingString:@"'"];
                        [sqlite deleteRecords:dbpath :strSQL];
                    }
                }
                break;
            case 26:
                //user
                //parse record master
                if (operationtype==1) {
                    sqlNumFiled=[sqlite countFieldTable:dbpath :@" PRAGMA  table_info(user) "];
                    strDataMaster=@"(";
                    if (fieldNum<sqlNumFiled) {
                        for (j=4;j<=fieldNum+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            if (j==fieldNum+3) {
                                //bu them du lieu
                                for (int cut=fieldNum; cut<sqlNumFiled; cut++) {
                                    strDataMaster=[strDataMaster stringByAppendingString:@"','"];
                                }
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                    }else if (fieldNum>sqlNumFiled){
                        for (j=4;j<=sqlNumFiled+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            if (j==sqlNumFiled+3) {
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                        j=j+fieldNum-sqlNumFiled;
                        
                    }else{
                        for (j=4;j<=fieldNum+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            if (j==fieldNum+3) {
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                    }
                    
                    //xoa record cu (chua lam)
                    //delete thang retailcustomer
                    if (![strObjectID isEqual:@""]) {
                        strSQL=@" delete from user where seqno='";
                        strSQL=[strSQL stringByAppendingString:strObjectID];
                        strSQL=[strSQL stringByAppendingString:@"'"];
                        [sqlite deleteRecords:dbpath :strSQL];
                    }
                    
                    //insert data o day
                    //insert retailcustomer
                    if (![strDataMaster isEqual:@"("]) {
                        strSQL=@" INSERT INTO user  VALUES ";
                        strSQL=[strSQL stringByAppendingString:strDataMaster];
                        [sqlite insertRecords:dbpath :strSQL];
                    }
                }else{
                    //delete thang retailcustomer
                    if (![strObjectID isEqual:@""]) {
                        strSQL=@" delete from user where seqno='";
                        strSQL=[strSQL stringByAppendingString:strObjectID];
                        strSQL=[strSQL stringByAppendingString:@"'"];
                        [sqlite deleteRecords:dbpath :strSQL];
                    }
                }

                break;
            case 1:
                //preference
                if (operationtype==1) {
                    sqlNumFiled=[sqlite countFieldTable:dbpath :@" PRAGMA  table_info(preferences) "];
                    strDataMaster=@"(";
                    if (fieldNum<sqlNumFiled) {
                        for (j=4;j<=fieldNum+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            if (j==fieldNum+3) {
                                //bu them du lieu
                                for (int cut=fieldNum; cut<sqlNumFiled; cut++) {
                                    strDataMaster=[strDataMaster stringByAppendingString:@"','"];
                                }
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                    }else if (fieldNum>sqlNumFiled){
                        for (j=4;j<=sqlNumFiled+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            if (j==sqlNumFiled+3) {
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                        j=j+fieldNum-sqlNumFiled;
                        
                    }else{
                        for (j=4;j<=fieldNum+3;j++) {
                            strDataMaster=[strDataMaster stringByAppendingString:@"'"];
                            strDataMaster=[strDataMaster stringByAppendingString:[arrField objectAtIndex:j]];
                            if (j==fieldNum+3) {
                                strDataMaster=[strDataMaster stringByAppendingString:@"')"];
                            } else {
                                strDataMaster=[strDataMaster stringByAppendingString:@"',"];
                            }
                            
                        }
                    }
                    //lam tiep detail neu co (cai nsy moi kho vkl)
                    if (j<([arrField count])) {
                        //co detail
                        strDataDetail=@"(";
                        sqlNumFiled=[sqlite countFieldTable:dbpath :@" PRAGMA  table_info(taxrates) "];
                        for (int k=j; k<([arrField count]); k++) {
                            TableDetailNum=[[arrField objectAtIndex:k] integerValue];
                            fieldDetailNum=[[arrField objectAtIndex:k+1] integerValue];
                            strObjectDetailID=[arrField objectAtIndex:k+2];
                            //xoa record (chua lam)
                            // insert
                            if (TableDetailNum==2) {
                                k=k+2;
                                int countk=k;
                                if (fieldDetailNum<sqlNumFiled) {
                                    for (int n=k; n<fieldDetailNum+countk; n++) {
                                        //dong goi
                                        strDataDetail=[strDataDetail stringByAppendingString:@"'"];
                                        strDataDetail=[strDataDetail stringByAppendingString:[arrField objectAtIndex:n]];
                                        if (n==fieldDetailNum+countk-1) {
                                            for (int cut=fieldDetailNum; cut<sqlNumFiled; cut++) {
                                                strDataDetail=[strDataDetail stringByAppendingString:@"','"];
                                            }
                                            strDataDetail=[strDataDetail stringByAppendingString:@"')"];
                                        } else {
                                            strDataDetail=[strDataDetail stringByAppendingString:@"',"];
                                        }
                                        k=k+1;
                                    }
                                    
                                    
                                }else if(fieldDetailNum>sqlNumFiled){
                                    for (int n=k; n<sqlNumFiled+countk; n++) {
                                        //dong goi
                                        strDataDetail=[strDataDetail stringByAppendingString:@"'"];
                                        strDataDetail=[strDataDetail stringByAppendingString:[arrField objectAtIndex:n]];
                                        if (n==fieldDetailNum+countk-1) {
                                            strDataDetail=[strDataDetail stringByAppendingString:@"')"];
                                        } else {
                                            strDataDetail=[strDataDetail stringByAppendingString:@"',"];
                                        }
                                        k=k+1;
                                    }
                                    k=k+fieldDetailNum-sqlNumFiled;
                                    
                                }else{
                                    for (int n=k; n<fieldDetailNum+countk; n++) {
                                        //dong goi
                                        strDataDetail=[strDataDetail stringByAppendingString:@"'"];
                                        strDataDetail=[strDataDetail stringByAppendingString:[arrField objectAtIndex:n]];
                                        if (n==fieldDetailNum+countk-1) {
                                            strDataDetail=[strDataDetail stringByAppendingString:@"')"];
                                        } else {
                                            strDataDetail=[strDataDetail stringByAppendingString:@"',"];
                                        }
                                        k=k+1;
                                    }
                                    
                                }                                                       //
                                strDataDetail=[strDataDetail stringByAppendingString:@",("];
                            }
                            else{
                                k=k+2+(int)fieldDetailNum;
                            }
                            k=k-1;
                            if (k>=([arrField count])) {
                                break;
                            }
                            
                        }
                    }
                    if (![strDataDetail isEqual:@"("]) {
                        strDataDetail=[strDataDetail substringToIndex:strDataDetail.length-2];
                    }
                    
                    //xoa record cu (chua lam)
                    if (![strObjectID isEqual:@""]) {
                        strSQL=@" delete from preferences where seqno='";
                        strSQL=[strSQL stringByAppendingString:strObjectID];
                        strSQL=[strSQL stringByAppendingString:@"'"];
                        [sqlite deleteRecords:dbpath :strSQL];
                        //xoa detail
                        strSQL=@" delete from taxrates where rseqno='";
                        strSQL=[strSQL stringByAppendingString:strObjectID];
                        strSQL=[strSQL stringByAppendingString:@"'"];
                        [sqlite deleteRecords:dbpath :strSQL];
                    }
                    
                    //insert data o day
                    //insert goods
                    if (![strDataMaster isEqual:@"("]) {
                        strSQL=@" INSERT INTO preferences  VALUES ";
                        strSQL=[strSQL stringByAppendingString:strDataMaster];
                        [sqlite insertRecords:dbpath :strSQL];
                    }
                    //insert goods_detail
                    if (![strDataDetail isEqual:@"("]) {
                        strSQL=@" INSERT INTO taxrates  VALUES ";
                        strSQL=[strSQL stringByAppendingString:strDataDetail];
                        [sqlite insertRecords:dbpath :strSQL];
                    }
                }
                else{
                    // xoa sp
                    //xoa record cu (chua lam)
                    if (![strObjectID isEqual:@""]) {
                        strSQL=@" delete from preferences where seqno='";
                        strSQL=[strSQL stringByAppendingString:strObjectID];
                        strSQL=[strSQL stringByAppendingString:@"'"];
                        [sqlite deleteRecords:dbpath :strSQL];
                        //xoa detail
                        strSQL=@" delete from taxrates where rseqno='";
                        strSQL=[strSQL stringByAppendingString:strObjectID];
                        strSQL=[strSQL stringByAppendingString:@"'"];
                        [sqlite deleteRecords:dbpath :strSQL];
                    }
                    
                }

                break;

            default:
                break;
        }
        // update maxseqno
        strSQL=@"select * from TrackingUpdateMaster limit 1 ";
         dbmaxseqno=[sqlite getMaxseqno:dbpath :strSQL];
        if (maxseqno>dbmaxseqno) {
            strSQL=@"update TrackingUpdateMaster set Maxseqno='";
            strSQL=[strSQL stringByAppendingString:[NSString stringWithFormat:@"%f",maxseqno]];
            strSQL=[strSQL stringByAppendingString:@"'"];
            [sqlite updateRecord:dbpath :strSQL];

        }
        
    }
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
    if( [elementName isEqualToString:@"ns:return"])
    {
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        xmlResults = YES;
        
    }
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if( xmlResults )
    {
        [soapResults appendString: string];
    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if( [elementName isEqualToString:@"ns:return"])
    {
        xmlResults = FALSE;
        //monLabel.text = soapResults;
        //[soapResults release];
        //soapResults = nil;
    }
}

@end
