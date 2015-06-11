//
//  ViewController.m
//  POSRingo
//
//  Created by hanoimacmini on 125//15.
//  Copyright (c) 2015年 strawberryjam. All rights reserved.
//

#import "ViewController.h"
#import "jam_Sync.h"
#import "db_sqlite.h"
#import "AppDelegate.h"
#import "zoomPopup.h"
@interface ViewController ()

@end

@implementation ViewController
NSMutableArray *arrSearchingResults;
@synthesize gridTablePopup;
@synthesize tableData;
@synthesize searchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Dang ky Client
    jam_Sync *sync=[jam_Sync alloc];
    NSString *serversocket=@"http://192.168.1.67:2011/StrawberryJamSync/services/StrawberryJamService.StrawberryJamServiceHttpSoap11Endpoint/AutoRegisterClient";
    [sync registerClient:serversocket];
    //-> cho nay can bo xung them dialog hien thong bao cac qua trinh dang chay
    
    
    // khoi tao popup
    tableData = [[NSMutableArray alloc] initWithCapacity:0];
    arrSearchingResults = [[NSMutableArray alloc] initWithCapacity:0];
    txtShopCode.delegate = self;
    gridTablePopup= [[UITableView alloc] initWithFrame:CGRectMake(50, 50, 300, 200) style:UITableViewStyleGrouped];
    [zoomPopup initWithMainview:self.view andStartRect:CGRectMake(50, 50, 50, 50)];
    tableData = [[NSMutableArray alloc]init];
    [self.gridTablePopup setDelegate:self];
    
    [self.gridTablePopup setDataSource:self];
    //get data shop
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchLogin:(id)sender {
    NSString *strSQL=@"";
    int cntRecords=0;
    if ([txtShopCode.text isEqual:@""]) {
        //user hoac pass sai
        UIAlertView *notifyAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Login"
                                    message:@"vui long nhan ma shop "
                                    delegate:self
                                    cancelButtonTitle:@"close"
                                    otherButtonTitles:nil, nil];
        [notifyAlert show];
    } else {
        db_sqlite *sqlite=[db_sqlite alloc];
        NSString *dbpath=[sqlite getDbFilePath];
        
        //check account
        // neu bang user k0 co record nao thi cho vao luon
        strSQL=@" SELECT count(*) from user ";
        cntRecords=[sqlite countRecords:dbpath :strSQL];
        // strSQL=@" PRAGMA  table_info(user) ";
        // cntRecords=[sqlite countFieldTable:dbpath :strSQL];
        //cntRecords=1;
        if (cntRecords==0) {
            //vao  luon
            AppDelegate *appDelegate;
            appDelegate=[UIApplication sharedApplication].delegate;
            appDelegate.ShopCode=txtShopCode.text;
            [self performSegueWithIdentifier:@"mainmenu" sender:nil];
        }else{
            strSQL=@" SELECT count(*) from user where UserID='";
            strSQL=[strSQL stringByAppendingString:txtUsername.text];
            strSQL=[strSQL stringByAppendingString:@"'"];
            strSQL=[strSQL stringByAppendingString:@" and Password='"];
            strSQL=[strSQL stringByAppendingString:txtPass.text];
            strSQL=[strSQL stringByAppendingString:@"'"];
            cntRecords=[sqlite countRecords:dbpath :strSQL];
            if (cntRecords!=0) {
                //vao luon
                AppDelegate *appDelegate;
                appDelegate=[UIApplication sharedApplication].delegate;
                appDelegate.ShopCode=txtShopCode.text;
                [self performSegueWithIdentifier:@"mainmenu" sender:nil];
            }else{
                //user hoac pass sai
                UIAlertView *notifyAlert = [[UIAlertView alloc]
                                            initWithTitle:@"Login"
                                            message:@"User hoac pass sai "
                                            delegate:self
                                            cancelButtonTitle:@"Đóng"
                                            otherButtonTitles:nil, nil];
                [notifyAlert show];
            }
        }

    }
   }
// cho nay la cua tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return [tableData count];
    //if (tableView == self.gridTablePopup) {
    //    return tableData.count;
    //} else {
        return [arrSearchingResults count];
    //}
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (tableView==gridTablePopup) {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    cell.clearsContextBeforeDrawing = YES;
    int row = (int)indexPath.row;
    NSArray *data ;//= [tableData objectAtIndex:row];
    //if (tableView == self.gridTablePopup) {
    //    data = [tableData objectAtIndex:row];
    //} else {
        data = arrSearchingResults[row];
   // }
    // Configure the cell...
    //Set name
    UILabel *lblName = [Utility createLabel:CGRectMake(20, 15, 110, 15) font:@"Arial" size:18 text:data[0]];
    [cell.contentView addSubview:lblName];
    UILabel *lblVicinity = [Utility createLabel:CGRectMake(120, 15, 110, 15) font:@"Arial" size:18 text:data[1]];
    [cell.contentView addSubview:lblVicinity];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr=[arrSearchingResults objectAtIndex:indexPath.row];
    txtShopCode.text=arr[0];
    [zoomPopup closePopup];
}
//end
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==txtShopCode){
        
        NSString *strSQL=@"";
        db_sqlite *sqlite=[db_sqlite alloc];
        NSString *dbpath=[sqlite getDbFilePath];
        
        if (![txtShopCode.text isEqual:@""]) {
            if ([txtShopCode.text containsString:@"@"]) {
                NSString *shopcode=[txtShopCode.text stringByReplacingOccurrencesOfString:@"@" withString:@"%"];
                strSQL=@" SELECT shopcode,shopname from shop where shopcode like '";
                strSQL=[strSQL stringByAppendingString:shopcode];
                strSQL=[strSQL stringByAppendingString:@"'"];
            } else {
                strSQL=@" SELECT shopcode,shopname from shop where shopcode = '";
                strSQL=[strSQL stringByAppendingString:txtShopCode.text];
                strSQL=[strSQL stringByAppendingString:@"'"];
            }
        }else strSQL=@" SELECT shopcode,shopname from shop ";
        tableData=[sqlite getArrayRecords:dbpath :strSQL];
        for (int i=0; i<tableData.count; i++) {
            [arrSearchingResults addObject:tableData[i]];
        }
        if ([tableData count]==0) {
            UIAlertView *notifyAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Login"
                                        message:@"khong ton tai shop nay "
                                        delegate:self
                                        cancelButtonTitle:@"Đóng"
                                        otherButtonTitles:nil, nil];
            [notifyAlert show];
        } else if ([tableData count]==1) {
            //txtShopCode.text=tableData[0][0];
        }else{
            gridTablePopup.dataSource=self;
            [zoomPopup showPopup:gridTablePopup];
            searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 7, 250, 30)];
            searchBar.delegate = self;
            [zoomPopup addSearchBar:searchBar];
            
            [gridTablePopup reloadData];
        }
        
    }
}
- (void)searchThroughData {
    arrSearchingResults = nil;
    NSPredicate *resultsPredicate;
    resultsPredicate = [NSPredicate predicateWithFormat:@"SELF.shopcode contains[cd] %@", searchBar.text];
    
    arrSearchingResults = [[tableData filteredArrayUsingPredicate:resultsPredicate] mutableCopy];
}
- (void)findLisDatatByStr:(NSString *)str
{
    NSString *name;
    [arrSearchingResults removeAllObjects];
    if ([str isEqual:@""]) {
        for (int i=0; i<tableData.count; i++) {
            [arrSearchingResults addObject:tableData[i]];
        }
        // mContentList=[mContentListData mutableCopy];
    }else{
        for (int j=0; j<tableData.count; j++) {
            name=tableData[j][0];
            if([name containsString:str])
            {
                // NSLog(@"String found ");
                [arrSearchingResults addObject:tableData[j]];
            }
        }
        
    }
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self findLisDatatByStr:searchText];
    [gridTablePopup reloadData];
}
- (IBAction)touchCancel:(id)sender {
    

}
@end
