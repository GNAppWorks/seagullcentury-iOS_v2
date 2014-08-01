//
//  SeaGullRouteManager.m
//  SGC
//
//  Created by Brandon Altvater on 7/14/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import "SeaGullRouteManager.h"
#import "SeaGullRouteModel.h"

@interface SeaGullRouteManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) SeaGullRouteModel *seaGullEvent;

@end

@implementation SeaGullRouteManager

+ (SeaGullRouteManager*) sharedInstance {
    static SeaGullRouteManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SeaGullRouteManager alloc]init];
    });
    return _sharedInstance;
    
}

-(id)init {
    self = [super init];
    
    return self;
}

-(SeaGullRouteModel *)seaGullEvent {
    if (!_seaGullEvent) {
        _seaGullEvent = [[SeaGullRouteModel alloc]init];
    }
    return _seaGullEvent;
}


-(NSURLRequest*) determineCorrectRoute:(NSInteger)number {
    
    return self.seaGullEvent.selectRoute[number - 1];
}

-(BOOL) showCorrectToolbar:(NSInteger)number {
  
    return number != 4 ? YES : NO;
}

- (NSArray*)showRouteBottomToolBar {
    
    NSArray *toolbar = [[NSArray alloc]init];
    UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:self action:nil];
    
    UIBarButtonItem *sagWagon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sagWagon25"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(callWagon:)];
    
    toolbar = [NSArray arrayWithObjects: flexiableItem, sagWagon, flexiableItem, nil];
    
    return toolbar;
}

- (NSArray *)showWebBottomToolBar:(UIWebView*)webView {
    
    UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:self
                                                                                  action:nil];
    
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                               target:webView
                                                                               action:@selector(stopLoading)];
    
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                 target:webView
                                                                                 action:@selector(reload)];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
                                                                               target:webView
                                                                               action:@selector(goBack)];
    
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                                  target:webView
                                                                                  action:@selector(goForward)];
    
    
    
    return [NSArray arrayWithObjects:backButton, flexiableItem, stopButton, flexiableItem, reloadButton, flexiableItem,forwardButton, nil];}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4105436342"]];
    }
}

- (void) checkLocation {
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userWasAskedForLocationOnce"]) {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Location Services Denied"
                                                          message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                         delegate:nil
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
            [alert show];
            alert = nil;
        }
    }
}

#pragma mark - Special Methods
- (IBAction)callWagon:(UIBarButtonItem *)sender {
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notice"
                                                       message:@"Please take note of how close you are to the nearest rest stop.\n\nIf you are having a medical emergency, please call 911.\nIf you have an urgent need and cannot continue, please contact SAG services by clicking continue.\n\nPLEASE NOTE: Due to the size of the course, it may take a SAG vehicle over an hour to reach you. Your patience is appreciated."
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Continue", nil];
        [alert show];
        
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@" This is not an iPhone and cannot make calls"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
@end
