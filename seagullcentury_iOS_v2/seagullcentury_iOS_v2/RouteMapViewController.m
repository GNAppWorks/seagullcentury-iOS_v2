//
//  RouteMapViewController.m
//  seagullcentury_iOS_v2
//
//  Created by Brandon Altvater on 4/10/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import "RouteMapViewController.h"
#import "Reachability.h"
#import "SeaGullRouteManager.h"

#import "SeaGullCenturyEvent.h"


@interface RouteMapViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSArray *routeToolbar;
@property (strong, nonatomic) NSArray *webToolbar;

- (void)informError:(NSError*)error;

@property (nonatomic, strong) Reachability *reach;
@property NetworkStatus network;
@property (nonatomic, strong) NSURLRequest *finalRequest;

@end

@implementation RouteMapViewController

- (NSArray *) routeToolbar {
    if (!_routeToolbar)
    {
        _routeToolbar = [[NSArray alloc]init];
    }
    return _routeToolbar;
}

- (NSArray *) webToolbar {
    if (!_webToolbar)
    {
        _webToolbar = [[NSArray alloc]init];
    }
    return _webToolbar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    self.webView.delegate = self;
    
    [self.webView loadRequest:self.urlObject];
    [self setupBottomToolbar];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    [[SeaGullRouteManager sharedInstance]checkLocation];
    
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.reach = [Reachability reachabilityForInternetConnection];
    [self.reach startNotifier];
    
    if (self.routeBool) {
        [self.navigationController.toolbar setItems:self.routeToolbar];
    } else {
        [self.navigationController.toolbar setItems:self.webToolbar];
    }
}

-(void) setupBottomToolbar {
    if (self.routeBool) {
        self.routeToolbar = [[SeaGullRouteManager sharedInstance] showRouteBottomToolBar];
    } else {
        self.webToolbar = [[SeaGullRouteManager sharedInstance] showWebBottomToolBar:self.webView];
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
}

#pragma mark - Updating the UI
- (void) updateButtons {
    if (!self.routeBool) {
        
        [[self.webToolbar objectAtIndex:6] setEnabled:self.webView.canGoForward];
        [[self.webToolbar objectAtIndex:0] setEnabled:self.webView.canGoBack];
        [[self.webToolbar objectAtIndex:2] setEnabled:self.webView.loading];
    }
}

-(void)updateTitle:(UIWebView *)aWebView {
    
    NSString* pageTitle = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = pageTitle;
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.webView.scalesPageToFit = YES;
    [self updateButtons];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    [self updateTitle:self.webView];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    [self informError:error];
}

#pragma mark - Error Handling
- (void)informError:(NSError *)error {
    
    NSString* localizedDescription = [error localizedDescription];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Title for error alert.")
                                                        message:localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK button in error alert.")
                                              otherButtonTitles:nil];
    [alertView show];
     
}

@end
