//
//  ViewControllerPOS.m
//  POSRingo
//
//  Created by hanoimacmini on 155//15.
//  Copyright (c) 2015年 strawberryjam. All rights reserved.
//

#import "ViewControllerPOS.h"
#import "zoomPopup.h"
#import "ViewControllerSalesHistory.h"

@interface ViewControllerPOS (){
    
}

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *datePickerToolbar;
@end

UIActionSheet *pickerViewPopup;
@implementation ViewControllerPOS
@synthesize gridTablePopup;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    txtCustomerCode.delegate = self;
    txtInvoiceDate.inputView = self.datePicker;
    txtInvoiceDate.inputAccessoryView = self.datePickerToolbar;
    NSDate *selectedDate=[NSDate date];;
    txtInvoiceDate.text=[Utility formatDate:selectedDate];
    // khoi tao popup
    gridTablePopup= [[UITableView alloc] initWithFrame:CGRectMake(50, 50, 300, 200) style:UITableViewStyleGrouped];
    [zoomPopup initWithMainview:self.view andStartRect:CGRectMake(50, 50, 50, 50)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// cho nay la cua tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // if (tableView==gridTablePopup) {
        return 10;
    //}
   // return [tableData count];
   // return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (tableView==gridTablePopup) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        cell.textLabel.text = [NSString stringWithFormat: @"Zeile %li", (long)indexPath.row];
        return cell;
   // }else{
        /*
        GridCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gridcell"];
        
        if(cell == nil)
        {
            cell = [[GridCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gridcell"];
            deletButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [deletButton setFrame:CGRectMake(5,0,37,37)];
            [deletButton setTitle:@"X" forState:UIControlStateNormal];
            [deletButton setTitle:@"X" forState:UIControlStateHighlighted];
            [deletButton addTarget:self action:@selector(deletButtonTapped:) forControlEvents:UIControlEventTouchDown];
            [deletButton setTag:[indexPath row]];
            [[cell buttonHoldLabel] addSubview:deletButton];
        }
        
        NSString *key = [tableDataKeys objectAtIndex:[indexPath row]];
        [[cell nameLabel] setText:key];
        [[cell nameLabel2] setText:key];
        [[cell markLabel] setText:[tableData objectForKey:key]];
        
        return (UITableViewCell *)cell;
         */
      //  return nil;
   // }
}

//end
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==txtInvoiceDate) {
        NSString *strDate=txtInvoiceDate.text;
        if (!([Utility isValidateDOB:strDate])) {
            NSLog(@"sai dinh dang");
        }
        
    }else if (textField==txtCustomerCode){
        gridTablePopup.dataSource=self;
        [zoomPopup showPopup:gridTablePopup];
    }
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
    // just resign focus and dismiss date picker
    [txtCustomerCode becomeFirstResponder];
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
    txtInvoiceDate.text = dateString;
    [txtCustomerCode becomeFirstResponder];
}
/*
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ViewControllerSalesHistory *vcSalesHistory = [[ViewControllerSalesHistory alloc] init];
    vcSalesHistory.vsCustomerCode = txtCustomerCode.text;
    vcSalesHistory.vsCustomerName = txtCustomerName.text;
    [self.navigationController pushViewController:vcSalesHistory animated:YES];
}



@end
