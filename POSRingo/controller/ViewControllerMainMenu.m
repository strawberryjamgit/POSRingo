//
//  ViewControllerMainMenu.m
//  POSRingo
//
//  Created by hanoimacmini on 145//15.
//  Copyright (c) 2015年 strawberryjam. All rights reserved.
//

#import "ViewControllerMainMenu.h"

@interface ViewControllerMainMenu ()

@end

@implementation ViewControllerMainMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)touchQuit:(id)sender {
    /*
    db_sqlite *sqlite=[db_sqlite alloc];
    NSString *dbpath=[sqlite getDbFilePath];
    NSString *strSQL=@"";
    strSQL=@"INSERT INTO TrackingUpdateMaster  VALUES  (1,1) ";
    [sqlite insertRecords:dbpath :strSQL];*/
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @""
                                                   message: @"Are you quit?"
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"OK",nil];
    
    
    [alert show];

}

- (IBAction)syncFromServer:(id)sender {
    db_sqlite *sqlite=[db_sqlite alloc];
    NSString *dbpath=[sqlite getDbFilePath];
    NSString *strSQL=@"";
    double dbmaxseqno=0;
    int cntRecords=0;
    strSQL=@"select * from TrackingUpdateMaster limit 1 ";
    dbmaxseqno=[sqlite getMaxseqno:dbpath :strSQL];
    jam_Sync *sync=[jam_Sync alloc];
     NSString *socketserver=@"http://192.168.1.69:1212/StrawberryJamSync/services/StrawberryJamService.StrawberryJamServiceHttpSoap11Endpoint/RequestUpdateIos?aiTerID=100&aiMaxSeqNo=";
    socketserver=[socketserver stringByAppendingString:[NSString stringWithFormat:@"%f",dbmaxseqno]];
    [sync syncFromServer:socketserver];
    //check
    strSQL=@" SELECT count(*) from goods ";
    cntRecords=[sqlite countRecords:dbpath :strSQL];
    strSQL=@" SELECT count(*) from goods_detail ";
    cntRecords=[sqlite countRecords:dbpath :strSQL];
    strSQL=@" SELECT count(*) from user ";
    cntRecords=[sqlite countRecords:dbpath :strSQL];
    strSQL=@" SELECT count(*) from shop ";
    cntRecords=[sqlite countRecords:dbpath :strSQL];
    strSQL=@" SELECT count(*) from staff ";
    cntRecords=[sqlite countRecords:dbpath :strSQL];
    strSQL=@" SELECT count(*) from retailcustomer ";
    cntRecords=[sqlite countRecords:dbpath :strSQL];
    strSQL=@" SELECT count(*) from credit ";
    cntRecords=[sqlite countRecords:dbpath :strSQL];
    strSQL=@" SELECT count(*) from preferences ";
    cntRecords=[sqlite countRecords:dbpath :strSQL];
    strSQL=@" SELECT count(*) from taxrates ";
    cntRecords=[sqlite countRecords:dbpath :strSQL];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSUserDefaults *passingValue = [NSUserDefaults standardUserDefaults];
    [passingValue setValue:@"la phong lam" forKey:@"lam"];
     [passingValue setBool:NO forKey:@"isEnglish"];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
    }
    else
    {
        exit(0);
    }
}
@end
