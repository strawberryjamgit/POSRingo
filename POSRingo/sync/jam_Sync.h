//
//  jam_Sync.h
//  starprint
//
//  Created by hanoimacmini on 272//15.
//  Copyright (c) 2015 hanoimacmini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface jam_Sync : NSObject<NSXMLParserDelegate>{
    NSMutableString *soapResults;
    BOOL xmlResults;
}
@property (nonatomic,strong) NSXMLParser *xmlParser;
- (NSString*) statisticOfSalesHistory:(NSString *)serversocket;
- (int) registerClient:(NSString *)serversocket;
- (void)syncFromServer:(NSString *)serversocket;
@end
