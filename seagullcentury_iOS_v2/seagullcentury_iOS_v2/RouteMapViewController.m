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

- (void)loadRequestFromString:(NSString*)urlString;
- (void)informError:(NSError*)error;
- (IBAction)callWagon:(UIBarButtonItem *)sender;

@property (nonatomic, strong) Reachability *reach;
@property NetworkStatus network;
@property (nonatomic, strong) NSURLRequest *finalRequest;

@end

@implementation RouteMapViewController

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
    

    
    
    
    
}


-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.reach = [Reachability reachabilityForInternetConnection];
    [self.reach startNotifier];
    self.network = [self.reach currentReachabilityStatus];
    NSLog(@"this is what Network Flag is after viewDidAppear %ld", self.network);
    
    UIScreenEdgePanGestureRecognizer *leftEdge = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:nil];
    leftEdge.edges = UIRectEdgeLeft;
    leftEdge.delegate = self;
    
    [self.view removeGestureRecognizer:leftEdge];
    [self setupBottomToolbar];
    
}

-(void) setupBottomToolbar
{
    UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *sagWagon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"towTruck"] style:UIBarButtonItemStylePlain target:self action:@selector(callWagon:)];
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:sagWagon, flexiableItem, nil];

   
    [self.navigationController.toolbar setItems:toolbarItems];
   
    
    
    
}

- (void) reachabilityChanged:(NSNotification *) notification {
    
    if( [self.reach isKindOfClass: [Reachability class]]) {
        
        self.network = [self.reach currentReachabilityStatus];
        
        NSLog(@"this is what Network Flag it %ld", self.network);
        /*
        if (self.network == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Connectivity Change"
                                                            message:@"Connectivity is limited in your area. Some features will not work on this application"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.webView loadRequest:self.finalRequest];
        }
        */
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
    NSString *path = [[NSBundle mainBundle]
                      pathForResource:@"index"
                      ofType:@"html"
                      inDirectory:@"seagullcentury-leaflet" ];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSString *theAbsoluteURLString = [url absoluteString];
    
    NSString *absoluteURLwithQueryString = [theAbsoluteURLString stringByAppendingString: urlString];
    
    NSURL *finalURL = [NSURL URLWithString: absoluteURLwithQueryString];
    
    self.finalRequest = [NSURLRequest requestWithURL:finalURL];
    
    [self.webView loadRequest:self.finalRequest];
}


#pragma mark - Updating the UI
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
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateTitle:self.webView];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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

- (IBAction)callWagon:(UIBarButtonItem *)sender {
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notice"
                                                       message:@"Please take note of how close you are to the nearest rest stop.\n\nIf you are having a medical emergency, please call 911.\nIf you have an urgent need and cannot continue, please contact SAG services by clicking continue.\n\nPLEASE NOTE: Due to the size of the course, it may take a SAG vehicle over an hour to reach you. Your patience is appreciated."
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Continue", nil];
        [alert show];
        
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://2489908484"]];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@" This is not an iPhone and cannot make calls"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"Clicked YESS");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://2489908484"]];
    }else{
        NSLog(@"Clicked NOOO");
    }
}

@end
