//
//  ViewControllerASP.m
//  POSRingo
//
//  Created by hanoimacmini on 155//15.
//  Copyright (c) 2015年 strawberryjam. All rights reserved.
//

#import "ViewControllerASP.h"

@interface ViewControllerASP ()

@end

@implementation ViewControllerASP
NSString *url;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *passingValue = [NSUserDefaults standardUserDefaults];
    NSString *test = [passingValue stringForKey:@"lam"];
   // BOOL isEnglish = [[passingValue objectForKey:@"isEnglish"] boolValue];
    // Do any additional setup after loading the view.
    url = @"http://t003-nagoya.cloudapp.net:9997/stjamweb/index.jsp";
    //tải website lên giao diện WebView
    aspSpinner.hidesWhenStopped = YES;
    [self loadURL:url];
    aspWebView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [aspSpinner startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [aspSpinner stopAnimating];
    //Gán tiêu đề cho website
    NSString* title = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    self.navigationItem.title = title;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [aspSpinner stopAnimating];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)loadURL:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:url];
    [aspWebView loadRequest:myRequest];
}

- (IBAction)touchSafari:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
@end
