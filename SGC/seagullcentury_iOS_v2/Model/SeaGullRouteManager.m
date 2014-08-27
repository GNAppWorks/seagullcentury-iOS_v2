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

-(NSUserDefaults*)masterSettings{
    if (!_masterSettings){
        _masterSettings = [NSUserDefaults standardUserDefaults];
        [_masterSettings setBool:YES forKey:@"Speed"];
        [_masterSettings setBool:NO forKey:@"Vendors"];
        [_masterSettings setBool:YES forKey:@"Rest Stops"];
    }
    return _masterSettings;
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
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"SAG Number", nil)]];
    }
}

- (void) checkLocation {
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userWasAskedForLocationOnce"]) {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Location Denied", nil)
                                                          message:NSLocalizedString(@"re-enable", nil)
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
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
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Notice", nil)
                                                       message:NSLocalizedString(@"SAG Button", nil)
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                             otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
        [alert show];
        
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", nil)
                                                        message:NSLocalizedString(@"Not an iPhone", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}
@end
