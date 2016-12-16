//
//  SparkSetupWebViewController.m
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 12/12/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import "SparkSetupWebViewController.h"
#import "SparkSetupCustomization.h"
#import <UIKit/UIKit.h>
#import "SparkSetupUIElements.h"
#ifdef ANALYTICS
#import <SEGAnalytics.h>
#endif

//#import "UIViewController+SparkSetupMainController.h"

@interface SparkSetupWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet SparkSetupUISpinner *spinner;

@end

@implementation SparkSetupWebViewController



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return ([SparkSetupCustomization sharedInstance].lightStatusAndNavBar) ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    if (self.link)
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.link cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0f]];
    }
    else
    {
        if (self.htmlFilename)
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:self.htmlFilename ofType:@"html" inDirectory:self.htmlFileDirectory];
            NSURL *baseURL = [NSURL fileURLWithPath:path];
            NSString* htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            [self.webView loadHTMLString:htmlString baseURL:baseURL];
        }
    }
    
    
    self.webView.scalesPageToFit = YES;
    self.navigationController.navigationBarHidden = NO;
    self.webView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonTouched:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    [self.spinner stopAnimating];
    // TODO: show a nice error static HTML
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.spinner startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinner stopAnimating];
    
    CGSize contentSize = self.webView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    self.webView.scrollView.minimumZoomScale = rw;
    self.webView.scrollView.maximumZoomScale = rw;
    self.webView.scrollView.zoomScale = rw;
    
    
    // experimenting
//    NSString *injectSrc = @"var i = document.createElement('div'); i.innerHTML = '%@';document.documentElement.appendChild(i);";
//    NSString *runToInject = [NSString stringWithFormat:injectSrc, @"<body style=\"background-color: transparent;\">"];
//    [self.webView stringByEvaluatingJavascriptFromString:runToInject];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
#ifdef ANALYTICS
    [[SEGAnalytics sharedAnalytics] track:@"Device Setup: Webview Screen"];
#endif
}


@end
