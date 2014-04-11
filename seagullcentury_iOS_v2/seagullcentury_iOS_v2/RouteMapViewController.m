//
//  RouteMapViewController.m
//  seagullcentury_iOS_v2
//
//  Created by Brandon Altvater on 4/10/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import "RouteMapViewController.h"


//static const CGFloat kNavBarHeight = 52.0f;
static const CGFloat kLabelHeight = 20.0f;
static const CGFloat kMargin = 10.0f;
static const CGFloat kSpacer = 9.0f;
//static const CGFloat kLabelFontSize = 12.0f;
//static const CGFloat kAddressHeight = 24.0f;

@interface RouteMapViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) UILabel *pageTitle;

- (void)buildPageTitle;
- (void)loadRequestFromString:(NSString*)urlString;
- (void)informError:(NSError*)error;

@end

@implementation RouteMapViewController
@synthesize webView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView.delegate = self;
    
    [self buildPageTitle];
    [self loadRequestFromString:@"http://apps.esrgc.org/maps/seagullcentury/index.html?route=0"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma Design Methods
- (void)buildPageTitle
{
    UINavigationBar *navBar = self.navigationController.navigationBar;
    CGRect labelFrame = CGRectMake(kMargin, kSpacer, navBar.bounds.size.width - 2 * kMargin, kLabelHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [navBar addSubview:label];
    self.pageTitle = label;
}

- (void)loadRequestFromString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url.scheme) {
        NSString* modifiedURLString = [NSString stringWithFormat:@"http://%@",urlString];
        url = [NSURL URLWithString:modifiedURLString];
    }
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Error Handling
- (void)informError:(NSError *)error
{
    NSString* localizedDescription = [error localizedDescription];
    UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Error", @"Title for error alert.")
                              message:localizedDescription delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK button in error alert.")
                              otherButtonTitles:nil];
    [alertView show];
}

@end
