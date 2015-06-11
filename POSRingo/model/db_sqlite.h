//
//  db_sqlite.h
//  starprint
//
//  Created by hanoimacmini on 272//15.
//  Copyright (c) 2015 hanoimacmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Goods.h"
@interface db_sqlite : NSObject
-(NSMutableArray *) getClientID;
-(int) insertRecords:(NSString *)filePath :(NSString *)strSQL ;
-(NSMutableArray *) getRecords:(NSString*) filePath :(NSString *)strSQL;
-(NSMutableArray *) getArrayRecords:(NSString*) filePath :(NSString *)strSQL;
-(int) deleteRecords:(NSString*) filePath :(NSString *)strSQL;
-(int) updateRecord:(NSString*) filePath :(NSString *)strSQL;
-(NSString *) getDbFilePath;
-(double) getMaxseqno:(NSString*) filePath :(NSString *)strSQL;
-(Goods*) getOneGoodsByBarCode:(NSString*) filePath :(NSString *)BarCode;
-(int) countRecords:(NSString*) filePath :(NSString *)strSQL;
-(int) countFieldTable:(NSString*) filePath :(NSString *)strSQL;
@end



