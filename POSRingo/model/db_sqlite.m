//
//  db_sqlite.m
//  starprint
//
//  Created by hanoimacmini on 272//15.
//  Copyright (c) 2015 hanoimacmini. All rights reserved.
//

#import "db_sqlite.h"
#import <sqlite3.h>
#import "Goods.h"
@implementation db_sqlite

-(NSMutableArray *) getClientID
{
    NSString *filePath=[self getDbFilePath];
    NSString *strSQL=@"SELECT TerminalID,ServerSocket from clientid limit 1";
    
    NSMutableArray * arrRecords =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        rc =sqlite3_prepare_v2(db, [strSQL UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            if (sqlite3_step(stmt) == SQLITE_ROW)
            {
                NSString * TerminalID =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
                NSString * ServerSocket =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                [arrRecords addObject:TerminalID];
                [arrRecords addObject:ServerSocket];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return arrRecords;
    
}

-(int) insertRecords:(NSString *)filePath :(NSString *)strSQL{
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        // NSString * query  = [NSString
        //                    stringWithFormat:@"INSERT INTO goods (SeqNo,GoodsCode,GoodsName) VALUES (\"%@\",\"%@\",\"%@\")",seqno,goodscode,goodsname];
        char * errMsg;
        rc = sqlite3_exec(db, [strSQL UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}
-(int) deleteRecords:(NSString*) filePath :(NSString *)strSQL
{
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        //NSString * query  = [NSString
         //                    stringWithFormat:@"DELETE FROM students where name=\"%@\"",name];
        char * errMsg;
        rc = sqlite3_exec(db, [strSQL UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
}
-(NSMutableArray *) getRecords:(NSString*) filePath :(NSString *)strSQL
{
    NSMutableArray * arrRecords =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        rc =sqlite3_prepare_v2(db, [strSQL UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                //tuy vao tung table ma parse lai doan nay
                NSString * Code =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
                NSString * Name =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                //NSNumber * price =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
               // NSInteger price =  sqlite3_column_int(stmt, 2);
                
               // NSDictionary *retailcustomer =[NSDictionary dictionaryWithObjectsAndKeys:CustomerCode,@"RCustomerCode",
               //                        [NSString stringWithString:CustomerName],@"RCustomerName",nil];
                Code=[Code stringByAppendingString:@"_"];
                Code=[Code stringByAppendingString:Name];
                [arrRecords addObject:Code];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return arrRecords;
    
}
-(NSMutableArray *) getArrayRecords:(NSString*) filePath :(NSString *)strSQL
{
    NSMutableArray * arrRecords =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        rc =sqlite3_prepare_v2(db, [strSQL UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                //tuy vao tung table ma parse lai doan nay
                NSString * Code =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
                NSString * Name =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSArray *data=[NSArray arrayWithObjects:Code,Name,nil];
                [arrRecords addObject:data];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return arrRecords;
    
}

-(int) updateRecord:(NSString*) filePath :(NSString *)strSQL
{
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        //NSString * query  = [NSString
        //                    stringWithFormat:@"DELETE FROM students where name=\"%@\"",name];
        char * errMsg;
        rc = sqlite3_exec(db, [strSQL UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to update record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
}
-(NSString *) getDbFilePath
{
    NSString* dataPath;
    NSString *docdir;
    docdir=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)[0];
    dataPath=[[NSString alloc] initWithString:[docdir stringByAppendingString:@"POSRIngo.sqlite"]];
    NSFileManager *filemanager=[NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:dataPath]==NO) {
        NSString *databasePathFromApp=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"POSRIngo.sqlite"];
        [filemanager copyItemAtPath:databasePathFromApp toPath:dataPath error:nil];
    }
    return dataPath;
}
-(double) getMaxseqno:(NSString*) filePath :(NSString *)strSQL
{
    double maxseqno=0;
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        rc =sqlite3_prepare_v2(db, [strSQL UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            if(sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                maxseqno =  sqlite3_column_int(stmt, 1);
               //maxseqno=(double)[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(stmt, 1)];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return maxseqno;
    
}
-(int) countRecords:(NSString*) filePath :(NSString *)strSQL
{
    int cnt=0;
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        rc =sqlite3_prepare_v2(db, [strSQL UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            if(sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                cnt =  sqlite3_column_int(stmt, 0);
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return cnt;
    
}
-(int) countFieldTable:(NSString*) filePath :(NSString *)strSQL
{
    int cnt=0;
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        rc =sqlite3_prepare_v2(db, [strSQL UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                cnt=cnt+1;
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return cnt;
    
}

-(Goods*) getOneGoodsByBarCode:(NSString*) filePath :(NSString *)BarCode
{
    NSString *strSQL;
    strSQL=@" select g.goodscode,g.goodsname,g.unit,g.standardpricenotax,gd.colorcode,gd.colorname,gd.sizecode,gd.sizename,gd.barcode ";
    strSQL=[strSQL stringByAppendingString:@" from goods as g,goods_detail as gd "];
    strSQL=[strSQL stringByAppendingString:@" where g.seqno=gd.rseqno and gd.barcode= '"];
    strSQL=[strSQL stringByAppendingString:BarCode];
    strSQL=[strSQL stringByAppendingString:@"' limit 1 "];
    Goods *goods=[[Goods alloc] init];

    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        rc =sqlite3_prepare_v2(db, [strSQL UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            if(sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                goods.GoodsCode=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
                goods.GoodsName=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                goods.Units=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                goods.Price=sqlite3_column_double(stmt, 3);
                goods.ColorCode=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                goods.ColorName=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
                goods.SizeCode=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
                goods.SizeName=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
                goods.BarCode=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
                //maxseqno =  sqlite3_column_int(stmt, 1);
                //maxseqno=(double)[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(stmt, 1)];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return goods;
    
}


/*
-(int) insert{
    int rc=0;
    dbpath=[dataPath UTF8String];
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        NSString * query  = [NSString
                             stringWithFormat:@"INSERT INTO denso (so,dem) VALUES ('7','bay'),('8','tam')"];
        char * errMsg;
        rc = sqlite3_exec(contactDB, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(contactDB);
    }
    
    return rc;
}*/
@end
