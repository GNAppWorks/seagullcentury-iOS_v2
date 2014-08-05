//
//  RouteMapViewController.m
//  seagullcentury_iOS_v2
//
//  Created by Brandon Altvater on 4/10/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import "RouteMapViewController.h"
#import "SeaGullRouteManager.h"
#import "AFNetworking.h"

@interface RouteMapViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (copy, nonatomic) NSArray *routeToolbar;
@property (copy, nonatomic) NSArray *webToolbar;

@end

@implementation RouteMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [self isReachable];
    
    [self.webView loadRequest:self.urlObject];
    [self setupBottomToolbar];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    [[SeaGullRouteManager sharedInstance]checkLocation];
    
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.routeBool) {
        [self.navigationController.toolbar setItems:self.routeToolbar];
    } else {
        [self.navigationController.toolbar setItems:self.webToolbar];
    }
}

-(void)isReachable {
    
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
            if (![AFNetworkReachabilityManager sharedManager].isReachable) {
               
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Change", nil)
                                                                message:NSLocalizedString(@"Limited Connection", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                [alert show];
            }
        }];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

-(void) setupBottomToolbar {
    if (self.routeBool) {
        self.routeToolbar = [[SeaGullRouteManager sharedInstance] showRouteBottomToolBar];
    } else {
        self.webToolbar = [[SeaGullRouteManager sharedInstance] showWebBottomToolBar:self.webView];
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
    if([error code] == NSURLErrorCancelled) {
        return;
    } else {
        [self informError:error];
    }
    [self updateButtons];
    
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
