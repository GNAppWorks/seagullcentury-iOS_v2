//
//  RouteMapViewController.m
//  seagullcentury_iOS_v2
//
//  Created by Brandon Altvater on 4/10/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import "RouteMapViewController.h"
#import "Reachability.h"

@interface RouteMapViewController () <UIWebViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)loadRequestFromString:(NSString*)urlString;
- (void)informError:(NSError*)error;
- (IBAction)callWagon:(UIBarButtonItem *)sender;

@property (nonatomic, strong) Reachability *reach;
@property NetworkStatus network;

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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.reach = [Reachability reachabilityForInternetConnection];
    [self.reach startNotifier];
    
}

- (void) reachabilityChanged:(NSNotification *) notification {
    
    if( [self.reach isKindOfClass: [Reachability class]]) {
        
        self.network = [self.reach currentReachabilityStatus];
        
        NSLog(@"this is what Network Flag it %ld", self.network);
        
        if (self.network == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Connectivity Change"
                                                            message:@"Connectivity is limited in your area. Some features will not work on this application"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
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
    self.webView.scalesPageToFit = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Error", @"Title for error alert.")
                              message:localizedDescription delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK button in error alert.")
                              otherButtonTitles:nil];
    [alertView show];
     
}

- (IBAction)callWagon:(UIBarButtonItem *)sender {
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://2489908484"]];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@" This is not an iPhone and cannot make calls" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


@end
