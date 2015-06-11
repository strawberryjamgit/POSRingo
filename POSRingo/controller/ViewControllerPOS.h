//
//  ViewControllerPOS.h
//  POSRingo
//
//  Created by hanoimacmini on 155//15.
//  Copyright (c) 2015年 strawberryjam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface ViewControllerPOS : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UITextField *txtInvoiceCode;
    IBOutlet UITextField *txtInvoiceDate;
    IBOutlet UITextField *txtCustomerCode;
    IBOutlet UITextField *txtCustomerName;
    IBOutlet UITextField *txtShopCode;
    IBOutlet UILabel *txtShopName;
    IBOutlet UITextField *txtStaffCode1;
    IBOutlet UILabel *txtStaffName1;
    IBOutlet UITextField *txtStaffCode2;
    IBOutlet UILabel *txtStaffName2;
}
@property (nonatomic,strong) IBOutlet UITableView *gridTablePopup;
@end
