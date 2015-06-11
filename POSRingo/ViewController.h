//
//  ViewController.h
//  POSRingo
//
//  Created by hanoimacmini on 125//15.
//  Copyright (c) 2015年 strawberryjam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
@interface ViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    
    IBOutlet UITextField *txtUsername;
    
    IBOutlet UITextField *txtPass;
    
    IBOutlet UITextField *txtShopCode;
}
@property (nonatomic,strong) IBOutlet UITableView *gridTablePopup;
@property (nonatomic,strong) NSMutableArray *tableData;
@property (nonatomic,strong) UISearchBar *searchBar;
- (IBAction)touchLogin:(id)sender;
- (IBAction)touchCancel:(id)sender;

@end

