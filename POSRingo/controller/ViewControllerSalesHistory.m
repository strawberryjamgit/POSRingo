//
//  ViewControllerSalesHistory.m
//  POSRingo
//
//  Created by jam on 2015/05/21.
//  Copyright (c) 2015年 strawberryjam. All rights reserved.
//

#import "ViewControllerSalesHistory.h"
#import "SalesHistoryTableViewCell.h"
#import "jam_Sync.h"
#import "db_sqlite.h"
#import "Utility.h"
#define BgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ViewControllerSalesHistory ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *grayStyleActivityIndicatorView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *datePickerToolbar;
@end

@implementation ViewControllerSalesHistory
@synthesize tblSalesHistory = _tblSalesHistory;

NSMutableArray *arrURL;
NSMutableArray *arrThumbnails;
NSMutableArray *arrGoodsCode;
NSMutableArray *arrGoodsName;
NSMutableArray *arrQuantity;
NSMutableArray *arrPrice;
NSMutableArray *arrInvoiceDate;
NSMutableArray *arrColorCode;
NSMutableArray *arrColorName;
NSMutableArray *arrSizeCode;
NSMutableArray *arrSizeName;
NSMutableArray *arrBrandCode;
NSMutableArray *arrBrandName;
NSMutableArray *arrItemCode;
NSMutableArray *arrItemName;
NSMutableArray *arrStaffCode;
NSMutableArray *arrStaffName;

NSMutableArray *arrURLP;
NSMutableArray *arrThumbnailsP;
NSMutableArray *arrGoodsCodeP;
NSMutableArray *arrGoodsNameP;
NSMutableArray *arrQuantityP;
NSMutableArray *arrPriceP;
NSMutableArray *arrInvoiceDateP;
NSMutableArray *arrColorCodeP;
NSMutableArray *arrColorNameP;
NSMutableArray *arrSizeCodeP;
NSMutableArray *arrSizeNameP;
NSMutableArray *arrBrandCodeP;
NSMutableArray *arrBrandNameP;
NSMutableArray *arrItemCodeP;
NSMutableArray *arrItemNameP;
NSMutableArray *arrStaffCodeP;
NSMutableArray *arrStaffNameP;

NSString *tmpDate;
int iCurrPage, iPages;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_tblSalesHistory setDelegate:self];
    [_tblSalesHistory setDataSource:self];
    [self initialDefaultData];
    _vsCustomerCode = @"taka005";
    _vsCustomerName = @"kokyaku05";
    
    
    NSDate *selectedDate = [NSDate date];
    txtStartDate.delegate=self;
    txtStartDate.inputView = self.datePicker;
    txtStartDate.inputAccessoryView = self.datePickerToolbar;
    txtStartDate.text=@"0000/00/00";
    
    txtEndDate.delegate=self;
    txtEndDate.inputView = self.datePicker;
    txtEndDate.inputAccessoryView = self.datePickerToolbar;
    txtEndDate.text=[Utility formatDate:selectedDate];
    
    _vsStartDate = txtStartDate.text;
    _vsEndDate = txtEndDate.text;
    
    txtCustomerCode.text = _vsCustomerCode;
    txtCustomerName.text = _vsCustomerName;
    iCurrPage = 1;
    iPages = 1;
    self.grayStyleActivityIndicatorView.hidden = YES;
    [self.grayStyleActivityIndicatorView stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startStatistic {
    db_sqlite *sqlite=[db_sqlite alloc];
    NSMutableArray * arrRecords = [sqlite getClientID];
    if ([arrRecords count]>=2) {
        NSString *serversocket = [arrRecords objectAtIndex:1];
        serversocket = [serversocket stringByAppendingString:@"/StrawberryJamSync/services/StrawberryJamService.StrawberryJamServiceHttpSoap11Endpoint/StatisticsOfSaleHistory_POSRingo"];
        serversocket = [serversocket stringByAppendingString:@"?aiTerID="];
        serversocket = [serversocket stringByAppendingString:[arrRecords objectAtIndex:0]];
        serversocket = [serversocket stringByAppendingString:@"&astrConds="];
        NSString *vsConditions =[NSString stringWithFormat:@"%@д%@д%@",_vsCustomerCode,_vsStartDate,_vsEndDate];
        serversocket = [serversocket stringByAppendingString:vsConditions];
        
        jam_Sync *sync=[jam_Sync alloc];
        NSString *vsResult = [sync statisticOfSalesHistory:serversocket];
        
        if ([vsResult  isEqual: @""]) {
            [self initialDefaultData];
        } else {
            NSArray *arrData=[vsResult componentsSeparatedByString:@"\n"];
            if ([arrData count]>=15) {
                arrQuantityP = [NSMutableArray arrayWithArray:[[arrData objectAtIndex:0] componentsSeparatedByString:@"\t"]];
                arrPriceP = [NSMutableArray arrayWithArray:[[arrData objectAtIndex:1] componentsSeparatedByString:@"\t"]];
                arrInvoiceDateP = [NSMutableArray arrayWithArray:[[arrData objectAtIndex:2] componentsSeparatedByString:@"\t"]];
                arrGoodsCodeP = [NSMutableArray arrayWithArray:[[arrData objectAtIndex:3] componentsSeparatedByString:@"\t"]];
                arrGoodsNameP = [NSMutableArray arrayWithArray:[[arrData objectAtIndex:4] componentsSeparatedByString:@"\t"]];
                arrColorCodeP = [NSMutableArray arrayWithArray:[[arrData objectAtIndex:5] componentsSeparatedByString:@"\t"]];
                arrColorNameP = [NSMutableArray arrayWithArray:[[arrData objectAtIndex:6] componentsSeparatedByString:@"\t"]];
                arrSizeCodeP = [NSMutableArray arrayWithArray:[[arrData objectAtIndex:7] componentsSeparatedByString:@"\t"]];
                arrSizeNameP = [NSMutableArray arrayWithArray:[[arrData objectAtIndex:8] componentsSeparatedByString:@"\t"]];
                arrBrandCodeP = [NSMutableArray arrayWithArray:[[arrData objectAtIndex:9] componentsSeparatedByString:@"\t"]];
                arrBrandNameP = [NSMutableArray arrayWithArray:[[arrData objectAtIndex:10] componentsSeparatedByString:@"\t"]];
                arrItemCodeP = [NSMutableArray arrayWithArray:[[arrData objectAtIndex:11] componentsSeparatedByString:@"\t"]];
                arrItemNameP = [NSMutableArray arrayWithArray:[[arrData objectAtIndex:12] componentsSeparatedByString:@"\t"]];
                arrStaffCodeP = [NSMutableArray arrayWithArray:[[arrData objectAtIndex:13] componentsSeparatedByString:@"\t"]];
                arrStaffNameP = [NSMutableArray arrayWithArray:[[arrData objectAtIndex:14] componentsSeparatedByString:@"\t"]];
                
                if ([arrQuantityP count]!=[arrStaffNameP count]) {
                    [self initialDefaultData];
                }else{
                    [arrURLP removeAllObjects];
                    [arrThumbnailsP removeAllObjects];
                    NSString *url = @"";
                    for (int i=0; i<=[arrGoodsCodeP count]-1; i++) {
                        url =[arrRecords objectAtIndex:1];
                        url = [url stringByAppendingString:@"/POSRingo/PICs/"];
                        url = [url stringByAppendingString:[arrGoodsCodeP objectAtIndex:i]];
                        url = [url stringByAppendingString:@".jpg"];
                        [arrURLP addObject:url];
                        [arrThumbnailsP addObject:[NSNull null]];
                    }
                    iPages = (int)([arrGoodsCodeP count]/15);
                    if (([arrGoodsCodeP count]%15)>0) {
                        iPages++;
                    }
                    iCurrPage = 1;
                    [self paging];
                }
                [self stopActivityIndicatorView];
                btnStatistic.enabled = YES;
                btnNext.enabled = YES;
                btnPrevious.enabled = YES;
                [_tblSalesHistory reloadData];
                
            }else{
                [self initialDefaultData];
            }
        }
    }
}

- (void)startActivityIndicatorView {
    //self.grayStyleActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.grayStyleActivityIndicatorView.hidden = NO;
    [self.grayStyleActivityIndicatorView startAnimating];
}

- (void)stopActivityIndicatorView {
    //self.grayStyleActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
     self.grayStyleActivityIndicatorView.hidden = YES;
    [self.grayStyleActivityIndicatorView stopAnimating];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==txtStartDate||textField==txtEndDate) {
        textField.text=tmpDate;
    }
    _vsStartDate = txtStartDate.text;
    _vsEndDate = txtEndDate.text;
}

- (UIView*)datePickerToolbar {
    if (!_datePickerToolbar) {
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolbar.barStyle = UIBarStyleBlack;
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(datePickerCanceled:)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(datePickerDone:)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [toolbar setItems:[NSArray arrayWithObjects:cancelButton, space, doneButton, nil] animated:NO];
        
        _datePickerToolbar = toolbar;
    }
    return _datePickerToolbar;
}

- (UIDatePicker*)datePicker {
    if (!_datePicker) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.date = [NSDate date];
        _datePicker = datePicker;
    }
    return _datePicker;
}

- (void)datePickerCanceled:(id)sender {
    [txtTmp becomeFirstResponder];
}

- (void)datePickerDone:(id)sender {
    NSDate *selectedDate = self.datePicker.date;
    // format date into string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    // format overall string
    NSString *dateString = [dateFormatter stringFromDate:selectedDate];
    dateString=[Utility formatDate:selectedDate];
    tmpDate = dateString;
    [txtTmp becomeFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SalesHistoryTableViewCell";
    
    SalesHistoryTableViewCell *cell = (SalesHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SalesHistoryTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (([arrGoodsCode count]-1)>=(indexPath.row*5)) {
        //cell.imgGoods.image = [UIImage imageNamed:[arrThumbnails objectAtIndex:indexPath.row*5]];
        if ([arrThumbnails objectAtIndex:indexPath.row*5]!=[NSNull null]) {
            cell.imgGoods.image = [arrThumbnails objectAtIndex:indexPath.row*5];
        }
        else{
            cell.imgGoods.image = nil;
        }
        
        cell.lbGoodsCode.text = [arrGoodsCode objectAtIndex:indexPath.row*5];
        cell.lbGoodsName.text = [arrGoodsName objectAtIndex:indexPath.row*5];
        cell.lbColor.text = [arrColorName objectAtIndex:indexPath.row*5];
        cell.lbSize.text = [arrSizeName objectAtIndex:indexPath.row*5];
        cell.lbBrand.text = [arrBrandName objectAtIndex:indexPath.row*5];
        cell.lbItem.text = [arrItemName objectAtIndex:indexPath.row*5];
        cell.lbStaff.text = [arrStaffName objectAtIndex:indexPath.row*5];
        cell.lbDate.text = [arrInvoiceDate objectAtIndex:indexPath.row*5];
        cell.lbQuantity.text = [arrQuantity objectAtIndex:indexPath.row*5];
        cell.lbPrice.text = [arrPrice objectAtIndex:indexPath.row*5];
    }else{
        cell.imgGoods.image = nil;
        cell.lbGoodsCode.text = @"";
        cell.lbGoodsName.text = @"";
        cell.lbColor.text = @"";
        cell.lbSize.text = @"";
        cell.lbBrand.text = @"";
        cell.lbItem.text = @"";
        cell.lbStaff.text = @"";
        cell.lbDate.text = @"";
        cell.lbQuantity.text = @"";
        cell.lbPrice.text = @"";
    }
    
    if (([arrGoodsCode count]-1)>=(indexPath.row*5+1)) {
        //cell.imgGoods2.image = [UIImage imageNamed:[arrThumbnails objectAtIndex:indexPath.row*5+1]];
        if ([arrThumbnails objectAtIndex:indexPath.row*5+1]!=[NSNull null]) {
            cell.imgGoods2.image = [arrThumbnails objectAtIndex:indexPath.row*5+1];
        }
        else{
            cell.imgGoods2.image = nil;
        }
        
        cell.lbGoodsCode2.text = [arrGoodsCode objectAtIndex:indexPath.row*5+1];
        cell.lbGoodsName2.text = [arrGoodsName objectAtIndex:indexPath.row*5+1];
        cell.lbColor2.text = [arrColorName objectAtIndex:indexPath.row*5+1];
        cell.lbSize2.text = [arrSizeName objectAtIndex:indexPath.row*5+1];
        cell.lbBrand2.text = [arrBrandName objectAtIndex:indexPath.row*5+1];
        cell.lbItem2.text = [arrItemName objectAtIndex:indexPath.row*5+1];
        cell.lbStaff2.text = [arrStaffName objectAtIndex:indexPath.row*5+1];
        cell.lbDate2.text = [arrInvoiceDate objectAtIndex:indexPath.row*5+1];
        cell.lbQuantity2.text = [arrQuantity objectAtIndex:indexPath.row*5+1];
        cell.lbPrice2.text = [arrPrice objectAtIndex:indexPath.row*5+1];
    }else{
        cell.imgGoods2.image = nil;
        cell.lbGoodsCode2.text = @"";
        cell.lbGoodsName2.text = @"";
        cell.lbColor2.text = @"";
        cell.lbSize2.text = @"";
        cell.lbBrand2.text = @"";
        cell.lbItem2.text = @"";
        cell.lbStaff2.text = @"";
        cell.lbDate2.text = @"";
        cell.lbQuantity2.text = @"";
        cell.lbPrice2.text = @"";
    }
    
    if (([arrGoodsCode count]-1)>=(indexPath.row*5+2)) {
        //cell.imgGoods3.image = [UIImage imageNamed:[arrThumbnails objectAtIndex:indexPath.row*5+2]];
        if ([arrThumbnails objectAtIndex:indexPath.row*5+2]!=[NSNull null]) {
            cell.imgGoods3.image = [arrThumbnails objectAtIndex:indexPath.row*5+2];
        }
        else{
            cell.imgGoods3.image = nil;
        }
        
        cell.lbGoodsCode3.text = [arrGoodsCode objectAtIndex:indexPath.row*5+2];
        cell.lbGoodsName3.text = [arrGoodsName objectAtIndex:indexPath.row*5+2];
        cell.lbColor3.text = [arrColorName objectAtIndex:indexPath.row*5+2];
        cell.lbSize3.text = [arrSizeName objectAtIndex:indexPath.row*5+2];
        cell.lbBrand3.text = [arrBrandName objectAtIndex:indexPath.row*5+2];
        cell.lbItem3.text = [arrItemName objectAtIndex:indexPath.row*5+2];
        cell.lbStaff3.text = [arrStaffName objectAtIndex:indexPath.row*5+2];
        cell.lbDate3.text = [arrInvoiceDate objectAtIndex:indexPath.row*5+2];
        cell.lbQuantity3.text = [arrQuantity objectAtIndex:indexPath.row*5+2];
        cell.lbPrice3.text = [arrPrice objectAtIndex:indexPath.row*5+2];
    }else{
        cell.imgGoods3.image = nil;
        cell.lbGoodsCode3.text = @"";
        cell.lbGoodsName3.text = @"";
        cell.lbColor3.text = @"";
        cell.lbSize3.text = @"";
        cell.lbBrand3.text = @"";
        cell.lbItem3.text = @"";
        cell.lbStaff3.text = @"";
        cell.lbDate3.text = @"";
        cell.lbQuantity3.text = @"";
        cell.lbPrice3.text = @"";
    }
    
    if (([arrGoodsCode count]-1)>=(indexPath.row*5+3)) {
        //cell.imgGoods4.image = [UIImage imageNamed:[arrThumbnails objectAtIndex:indexPath.row*5+3]];
        if ([arrThumbnails objectAtIndex:indexPath.row*5+3]!=[NSNull null]) {
            cell.imgGoods4.image = [arrThumbnails objectAtIndex:indexPath.row*5+3];
        }
        else{
            cell.imgGoods4.image = nil;
        }
        
        cell.lbGoodsCode4.text = [arrGoodsCode objectAtIndex:indexPath.row*5+3];
        cell.lbGoodsName4.text = [arrGoodsName objectAtIndex:indexPath.row*5+3];
        cell.lbColor4.text = [arrColorName objectAtIndex:indexPath.row*5+3];
        cell.lbSize4.text = [arrSizeName objectAtIndex:indexPath.row*5+3];
        cell.lbBrand4.text = [arrBrandName objectAtIndex:indexPath.row*5+3];
        cell.lbItem4.text = [arrItemName objectAtIndex:indexPath.row*5+3];
        cell.lbStaff4.text = [arrStaffName objectAtIndex:indexPath.row*5+3];
        cell.lbDate4.text = [arrInvoiceDate objectAtIndex:indexPath.row*5+3];
        cell.lbQuantity4.text = [arrQuantity objectAtIndex:indexPath.row*5+3];
        cell.lbPrice4.text = [arrPrice objectAtIndex:indexPath.row*5+3];
    }else{
        cell.imgGoods4.image = nil;
        cell.lbGoodsCode4.text = @"";
        cell.lbGoodsName4.text = @"";
        cell.lbColor4.text = @"";
        cell.lbSize4.text = @"";
        cell.lbBrand4.text = @"";
        cell.lbItem4.text = @"";
        cell.lbStaff4.text = @"";
        cell.lbDate4.text = @"";
        cell.lbQuantity4.text = @"";
        cell.lbPrice4.text = @"";
    }
    
    if (([arrGoodsCode count]-1)>=(indexPath.row*5+4)) {
        //cell.imgGoods5.image = [UIImage imageNamed:[arrThumbnails objectAtIndex:indexPath.row*5+4]];
        if ([arrThumbnails objectAtIndex:indexPath.row*5+4]!=[NSNull null]) {
            cell.imgGoods5.image = [arrThumbnails objectAtIndex:indexPath.row*5+4];
        }
        else{
            cell.imgGoods5.image = nil;
        }
        
        cell.lbGoodsCode5.text = [arrGoodsCode objectAtIndex:indexPath.row*5+4];
        cell.lbGoodsName5.text = [arrGoodsName objectAtIndex:indexPath.row*5+4];
        cell.lbColor5.text = [arrColorName objectAtIndex:indexPath.row*5+4];
        cell.lbSize5.text = [arrSizeName objectAtIndex:indexPath.row*5+4];
        cell.lbBrand5.text = [arrBrandName objectAtIndex:indexPath.row*5+4];
        cell.lbItem5.text = [arrItemName objectAtIndex:indexPath.row*5+4];
        cell.lbStaff5.text = [arrStaffName objectAtIndex:indexPath.row*5+4];
        cell.lbDate5.text = [arrInvoiceDate objectAtIndex:indexPath.row*5+4];
        cell.lbQuantity5.text = [arrQuantity objectAtIndex:indexPath.row*5+4];
        cell.lbPrice5.text = [arrPrice objectAtIndex:indexPath.row*5+4];
    }else{
        cell.imgGoods5.image = nil;
        cell.lbGoodsCode5.text = @"";
        cell.lbGoodsName5.text = @"";
        cell.lbColor5.text = @"";
        cell.lbSize5.text = @"";
        cell.lbBrand5.text = @"";
        cell.lbItem5.text = @"";
        cell.lbStaff5.text = @"";
        cell.lbDate5.text = @"";
        cell.lbQuantity5.text = @"";
        cell.lbPrice5.text = @"";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 265;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    int iRows = (int)([arrGoodsCode count]/5);
    if (([arrGoodsCode count]%5)>0) {
        iRows++;
    }
    return iRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (IBAction)touch_btnSalesHistory:(id)sender {
    // Bat dau thong ke
    dispatch_async(BgQueue, ^{
        [self performSelectorOnMainThread:@selector(startStatistic) withObject:nil waitUntilDone:YES];
    });
    [self startActivityIndicatorView];
    btnStatistic.enabled = NO;
    btnNext.enabled = NO;
    btnPrevious.enabled = NO;
}

- (IBAction)touch_btnPrevious:(id)sender {
    if (iCurrPage>1) {
        iCurrPage--;
        [self paging];
        [_tblSalesHistory reloadData];
    }
}

- (IBAction)touch_btnNext:(id)sender {
    if (iCurrPage<iPages) {
        iCurrPage++;
        [self paging];
        [_tblSalesHistory reloadData];
    }
}

- (void)initialDefaultData{
    arrURL = [[NSMutableArray alloc ] init];
    arrThumbnails = [[NSMutableArray alloc ] init];
    arrGoodsCode = [[NSMutableArray alloc ] init];
    arrGoodsName = [[NSMutableArray alloc ] init];
    arrQuantity = [[NSMutableArray alloc ] init];
    arrPrice = [[NSMutableArray alloc ] init];
    arrInvoiceDate = [[NSMutableArray alloc ] init];
    arrColorCode = [[NSMutableArray alloc ] init];
    arrColorName = [[NSMutableArray alloc ] init];
    arrSizeCode = [[NSMutableArray alloc ] init];
    arrSizeName = [[NSMutableArray alloc ] init];
    arrBrandCode = [[NSMutableArray alloc ] init];
    arrBrandName = [[NSMutableArray alloc ] init];
    arrItemCode = [[NSMutableArray alloc ] init];
    arrItemName = [[NSMutableArray alloc ] init];
    arrStaffCode = [[NSMutableArray alloc ] init];
    arrStaffName = [[NSMutableArray alloc ] init];
    
    arrURLP = [[NSMutableArray alloc ] init];
    arrThumbnailsP = [[NSMutableArray alloc ] init];
    arrGoodsCodeP = [[NSMutableArray alloc ] init];
    arrGoodsNameP = [[NSMutableArray alloc ] init];
    arrQuantityP = [[NSMutableArray alloc ] init];
    arrPriceP = [[NSMutableArray alloc ] init];
    arrInvoiceDateP = [[NSMutableArray alloc ] init];
    arrColorCodeP = [[NSMutableArray alloc ] init];
    arrColorNameP = [[NSMutableArray alloc ] init];
    arrSizeCodeP = [[NSMutableArray alloc ] init];
    arrSizeNameP = [[NSMutableArray alloc ] init];
    arrBrandCodeP = [[NSMutableArray alloc ] init];
    arrBrandNameP = [[NSMutableArray alloc ] init];
    arrItemCodeP = [[NSMutableArray alloc ] init];
    arrItemNameP = [[NSMutableArray alloc ] init];
    arrStaffCodeP = [[NSMutableArray alloc ] init];
    arrStaffNameP = [[NSMutableArray alloc ] init];
    
    for (int i=0; i<=14; i++) {
        [arrURL addObject:@""];
        [arrThumbnails addObject:[NSNull null]];
        [arrGoodsCode addObject:@""];
        [arrGoodsName addObject:@""];
        [arrQuantity addObject:@""];
        [arrPrice addObject:@""];
        [arrInvoiceDate addObject:@""];
        [arrColorCode addObject:@""];
        [arrColorName addObject:@""];
        [arrSizeCode addObject:@""];
        [arrSizeName addObject:@""];
        [arrBrandCode addObject:@""];
        [arrBrandName addObject:@""];
        [arrItemCode addObject:@""];
        [arrItemName addObject:@""];
        [arrStaffCode addObject:@""];
        [arrStaffName addObject:@""];
    }
}

- (void)paging{
    [arrURL removeAllObjects];
    [arrThumbnails removeAllObjects];
    [arrGoodsCode removeAllObjects];
    [arrGoodsName removeAllObjects];
    [arrQuantity removeAllObjects];
    [arrPrice removeAllObjects];
    [arrInvoiceDate removeAllObjects];
    [arrColorCode removeAllObjects];
    [arrColorName removeAllObjects];
    [arrSizeCode removeAllObjects];
    [arrSizeName removeAllObjects];
    [arrBrandCode removeAllObjects];
    [arrBrandName removeAllObjects];
    [arrItemCode removeAllObjects];
    [arrItemName removeAllObjects];
    [arrStaffCode removeAllObjects];
    [arrStaffName removeAllObjects];
    
    NSURL *imageURL = nil;
    NSString *vsTmp = @"";
    double dTmp = 0;
    NSDateFormatter* inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter* outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yy/MM/dd"];
    
    for (int i=15*(iCurrPage-1); i<=15*iCurrPage-1; i++) {
        if ([arrGoodsCodeP count]-1>=i) {
            [arrURL addObject:[arrURLP objectAtIndex:i]];
            imageURL = [NSURL URLWithString:[arrURLP objectAtIndex:i]];
            if ([arrThumbnailsP objectAtIndex:i]==[NSNull null]) {
                [arrThumbnailsP setObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]] atIndexedSubscript:i];
            }
            [arrThumbnails addObject:[arrThumbnailsP objectAtIndex:i]];
            
            [arrGoodsCode addObject:[arrGoodsCodeP objectAtIndex:i]];
            [arrGoodsName addObject:[arrGoodsNameP objectAtIndex:i]];
            
            dTmp = [[arrQuantityP objectAtIndex:i] doubleValue];
            vsTmp = [NSString stringWithFormat:@"数量: %.0lf", dTmp];
            [arrQuantity addObject:vsTmp];
            
            dTmp = [[arrPriceP objectAtIndex:i] doubleValue];
            vsTmp = [NSString stringWithFormat:@"¥%.0lf", dTmp];
            [arrPrice addObject:vsTmp];
            
            [arrInvoiceDate addObject:[outputFormatter stringFromDate:[inputFormatter dateFromString:[arrInvoiceDateP objectAtIndex:i]]]];
            [arrColorCode addObject:[arrColorCodeP objectAtIndex:i]];
            [arrColorName addObject:[arrColorNameP objectAtIndex:i]];
            [arrSizeCode addObject:[arrSizeCodeP objectAtIndex:i]];
            [arrSizeName addObject:[arrSizeNameP objectAtIndex:i]];
            [arrBrandCode addObject:[arrBrandCodeP objectAtIndex:i]];
            [arrBrandName addObject:[arrBrandNameP objectAtIndex:i]];
            [arrItemCode addObject:[arrItemCodeP objectAtIndex:i]];
            [arrItemName addObject:[arrItemNameP objectAtIndex:i]];
            [arrStaffCode addObject:[arrStaffCodeP objectAtIndex:i]];
            [arrStaffName addObject:[arrStaffNameP objectAtIndex:i]];
        }else{
            [arrURL addObject:@""];
            [arrThumbnails addObject:[NSNull null]];
            [arrGoodsCode addObject:@""];
            [arrGoodsName addObject:@""];
            [arrQuantity addObject:@""];
            [arrPrice addObject:@""];
            [arrInvoiceDate addObject:@""];
            [arrColorCode addObject:@""];
            [arrColorName addObject:@""];
            [arrSizeCode addObject:@""];
            [arrSizeName addObject:@""];
            [arrBrandCode addObject:@""];
            [arrBrandName addObject:@""];
            [arrItemCode addObject:@""];
            [arrItemName addObject:@""];
            [arrStaffCode addObject:@""];
            [arrStaffName addObject:@""];
        }
    }
}

@end
