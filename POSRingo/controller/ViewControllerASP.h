//
//  ViewControllerASP.h
//  POSRingo
//
//  Created by hanoimacmini on 155//15.
//  Copyright (c) 2015年 strawberryjam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerASP : UIViewController<UIWebViewDelegate>{
    
    IBOutlet UIWebView *aspWebView;
    
    IBOutlet UIActivityIndicatorView *aspSpinner;
}
- (IBAction)touchSafari:(id)sender;

@end
