//
//  RouteMapViewController.m
//  seagullcentury_iOS_v2
//
//  Created by Brandon Altvater on 4/10/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import "RouteMapViewController.h"
#import "Reachability.h"

@interface RouteMapViewController () <UIWebViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSArray *routeToolbar;
@property (strong, nonatomic) NSArray *webToolbar;

- (void)loadRequestFromString:(NSString*)urlString;
- (void)informError:(NSError*)error;

@property (nonatomic, strong) Reachability *reach;
@property NetworkStatus network;
@property (nonatomic, strong) NSURLRequest *finalRequest;

@end

@implementation RouteMapViewController

- (NSArray *) routeToolbar
{
    if (!_routeToolbar)
    {
        _routeToolbar = [[NSArray alloc]init];
    }
    return _routeToolbar;
}

- (NSArray *) webToolbar
{
    if (!_webToolbar)
    {
        _webToolbar = [[NSArray alloc]init];
    }
    return _webToolbar;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    self.webView.delegate = self;
    
    [self loadRequestFromString:self.urlRoute];
    [self setupBottomToolbar];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.reach = [Reachability reachabilityForInternetConnection];
    [self.reach startNotifier];
    self.network = [self.reach currentReachabilityStatus];
    
    if (self.routeBool) {
        [self.navigationController.toolbar setItems:self.routeToolbar];
    }else{
        [self.navigationController.toolbar setItems:self.webToolbar];
    }
    
}

-(void) setupBottomToolbar
{
    UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:self action:nil];
    if (self.routeBool) {
        
        
        UIBarButtonItem *sagWagon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sagWagon25"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(callWagon:)];
        
        self.routeToolbar = [NSArray arrayWithObjects:flexiableItem, sagWagon, flexiableItem, nil];
        
    }else {
        
        UIBarButtonItem *stopButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                   target:self.webView
                                                                                   action:@selector(stopLoading)];
        
        UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                     target:self.webView
                                                                                     action:@selector(reload)];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
                                                                                   target:self.webView
                                                                                   action:@selector(goBack)];
        
        UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                                      target:self.webView
                                                                                      action:@selector(goForward)];
        
        self.webToolbar = [NSArray arrayWithObjects:backButton, flexiableItem, stopButton, flexiableItem, reloadButton, flexiableItem,forwardButton, nil];
    }
    
}


- (void) reachabilityChanged:(NSNotification *) notification {
    
    if([self.reach isKindOfClass: [Reachability class]]) {
        
        self.network = [self.reach currentReachabilityStatus];

        
        if (self.network == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Connectivity Change"
                                                            message:@"Connectivity is limited in your area. Some features will not work on this application"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.webView loadRequest:self.finalRequest];
        }

    }
    
    [self checkLocation];
}



- (void) checkLocation{
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userWasAskedForLocationOnce"])
    {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized)
        {
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Location Services Denied"
                                                          message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                         delegate:nil
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
            [alert show];
            alert= nil;
        }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES]
                                                  forKey:@"userWasAskedForLocationOnce"];
        
        if ([CLLocationManager locationServicesEnabled]) //this will trigger the system prompt
        {
            [locationManager startUpdatingLocation];
        }
    }
    
}

#pragma Design Methods
- (void)loadRequestFromString:(NSString *)urlString
{
    if (self.routeBool)
    {
        NSString *path = [[NSBundle mainBundle]
                          pathForResource:@"index"
                          ofType:@"html"
                          inDirectory:@"seagullcentury-leaflet"];
        
        NSURL *url = [NSURL fileURLWithPath:path];
        
        NSString *theAbsoluteURLString = [url absoluteString];
        
        NSString *absoluteURLwithQueryString = [theAbsoluteURLString stringByAppendingString: urlString];
        
        NSURL *finalURL = [NSURL URLWithString: absoluteURLwithQueryString];
        
        self.finalRequest = [NSURLRequest requestWithURL:finalURL];
        [self.webView loadRequest:self.finalRequest];
    }else
    {
        NSURL *url = [NSURL URLWithString:self.urlRoute];
        if (!url.scheme) {
            NSString* modifiedURLString = [NSString stringWithFormat:@"http://%@",self.urlRoute];
            url = [NSURL URLWithString:modifiedURLString];
        }
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        
        [self.webView loadRequest:urlRequest];
    }
    
}


#pragma mark - Updating the UI
- (void) updateButtons
{
    if (!self.routeBool)
    {
        [[self.webToolbar objectAtIndex:6] setEnabled:self.webView.canGoForward];
        [[self.webToolbar objectAtIndex:0] setEnabled:self.webView.canGoBack];
        [[self.webToolbar objectAtIndex:2] setEnabled:self.webView.loading];
    }
}

-(void)updateTitle:(UIWebView *)aWebView
{
    NSString* pageTitle = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = pageTitle;
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.webView.scalesPageToFit = YES;
    [self updateButtons];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    [self updateTitle:self.webView];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    [self informError:error];
}

#pragma mark - Error Handling
- (void)informError:(NSError *)error
{
    
    NSString* localizedDescription = [error localizedDescription];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Title for error alert.")
                                                        message:localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK button in error alert.")
                                              otherButtonTitles:nil];
    [alertView show];
     
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4105436342"]];
    }
}

#pragma mark - Special Methods
- (IBAction)callWagon:(UIBarButtonItem *)sender {
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notice"
                                                       message:@"Please take note of how close you are to the nearest rest stop.\n\nIf you are having a medical emergency, please call 911.\nIf you have an urgent need and cannot continue, please contact SAG services by clicking continue.\n\nPLEASE NOTE: Due to the size of the course, it may take a SAG vehicle over an hour to reach you. Your patience is appreciated."
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Continue", nil];
        [alert show];

        
    }else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@" This is not an iPhone and cannot make calls"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
