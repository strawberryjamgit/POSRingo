//
//  ViewControllerSalesHistory.h
//  POSRingo
//
//  Created by jam on 2015/05/21.
//  Copyright (c) 2015年 strawberryjam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerSalesHistory : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    IBOutlet UILabel *lbCustomerCode;
    IBOutlet UILabel *lbCustomerName;
    IBOutlet UITextField *txtCustomerCode;
    IBOutlet UITextField *txtCustomerName;
    IBOutlet UIButton *btnStatistic;
    IBOutlet UIButton *btnPrevious;
    IBOutlet UIButton *btnNext;
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    IBOutlet UITextField *txtTmp;
}

@property (strong, nonatomic) IBOutlet UITableView *tblSalesHistory;
@property (nonatomic, retain) NSString *vsCustomerCode;
@property (nonatomic, retain) NSString *vsCustomerName;
@property (nonatomic, retain) NSString *vsStartDate;
@property (nonatomic, retain) NSString *vsEndDate;

- (IBAction)touch_btnSalesHistory:(id)sender;
- (IBAction)touch_btnPrevious:(id)sender;
- (IBAction)touch_btnNext:(id)sender;

@end
