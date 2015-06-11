//
//  GridCell.h
//  GridProject
//
//  Created by Bharath Kumar Devaraj on 7/25/13.
//  Copyright (c) 2013 Bharath Kumar Devaraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridCell : UITableViewCell

//@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UITextField *column1;
@property (nonatomic,strong) UITextField *column2;
@property (nonatomic,strong) UITextField *column3;
@property (nonatomic,strong) UITextField *column4;
@property (nonatomic,strong) UITextField *column5;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UITextField *buttonHoldLabel;

@end
