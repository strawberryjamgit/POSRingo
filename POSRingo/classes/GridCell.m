//
//  GridCell.m
//  GridProject
//
//  Created by Bharath Kumar Devaraj on 7/25/13.
//  Copyright (c) 2013 Bharath Kumar Devaraj. All rights reserved.
//

#import "GridCell.h"

@implementation GridCell
@synthesize column1;
@synthesize column2;
@synthesize column3;
@synthesize column4;
@synthesize column5;
@synthesize deleteButton;
@synthesize buttonHoldLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGRect contentViewRect = [[self contentView] bounds];
        CGFloat subCellWidth = contentViewRect.size.width / 6;
        CGFloat subCellHeight = contentViewRect.size.height;
        CGFloat subcellXPosition = contentViewRect.origin.x;
        CGFloat subcellYPoistion = contentViewRect.origin.y;
        
        //nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(subcellXPosition, subcellYPoistion, subCellWidth, subCellHeight)];
        //colum1
        column1 = [[UITextField alloc]initWithFrame:CGRectMake(subcellXPosition, subcellYPoistion, 210, 30)];
        column1.layer.borderColor=[[UIColor whiteColor]CGColor];
        column1.layer.borderWidth=0.5f;
        [column1 setTextColor:[UIColor whiteColor]];
        column1.layer.backgroundColor=[[UIColor blackColor]CGColor];
        [column1 setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:column1];
        /*
        column1 = [[UITextField alloc]initWithFrame:CGRectMake(subcellXPosition, subcellYPoistion+20, 210, 30)];
        column1.layer.borderColor=[[UIColor whiteColor]CGColor];
        column1.layer.borderWidth=0.5f;
        [column1 setTextColor:[UIColor whiteColor]];
        column1.layer.backgroundColor=[[UIColor blackColor]CGColor];
        [column1 setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:column1];
        */
        column2 = [[UITextField alloc]initWithFrame:CGRectMake(subcellXPosition + 209, subcellYPoistion, 116, 30)];
        column2.layer.borderColor=[[UIColor whiteColor]CGColor];
        column2.layer.borderWidth=0.5f;
          column2.layer.backgroundColor=[[UIColor blackColor]CGColor];
        [column2 setTextAlignment:NSTextAlignmentCenter];
        [column2 setTextColor:[UIColor whiteColor]];
        [self addSubview:column2];
        
        
        column3 = [[UITextField alloc]initWithFrame:CGRectMake(subcellXPosition +324, subcellYPoistion, 81, 30)];
        column3.layer.borderColor=[[UIColor whiteColor]CGColor];
        column3.layer.borderWidth=0.5f;
          column3.layer.backgroundColor=[[UIColor blackColor]CGColor];
        [column3 setTextColor:[UIColor whiteColor]];
        [column3 setTextAlignment:NSTextAlignmentCenter];
        //[column3 setUserInteractionEnabled:YES];
        [self addSubview:column3];
        
        column4 = [[UITextField alloc]initWithFrame:CGRectMake(subcellXPosition + 404, subcellYPoistion, 136, 30)];
        column4.layer.borderColor=[[UIColor whiteColor]CGColor];
        column4.layer.borderWidth=0.5f;
        column4.layer.backgroundColor=[[UIColor blackColor]CGColor];
        [column4 setTextAlignment:NSTextAlignmentCenter];
        [column4 setTextColor:[UIColor whiteColor]];
        [self addSubview:column4];
        
        column5 = [[UITextField alloc]initWithFrame:CGRectMake(subcellXPosition + 539, subcellYPoistion, 110, 30)];
        column5.layer.borderColor=[[UIColor whiteColor]CGColor];
        column5.layer.borderWidth=0.5f;
        column5.layer.backgroundColor=[[UIColor blackColor]CGColor];
        [column5 setTextAlignment:NSTextAlignmentCenter];
        [column5 setTextColor:[UIColor whiteColor]];
        [self addSubview:column5];
        
        buttonHoldLabel = [[UITextField alloc]initWithFrame:CGRectMake(subcellXPosition + 645, subcellYPoistion, 30, 30)];
        buttonHoldLabel.layer.borderColor=[[UIColor whiteColor]CGColor];
        buttonHoldLabel.layer.borderWidth=0.5f;
        buttonHoldLabel.layer.backgroundColor=[[UIColor grayColor]CGColor];
        [buttonHoldLabel setUserInteractionEnabled:YES];
        [self addSubview:buttonHoldLabel];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self setUserInteractionEnabled:YES];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
