//
//  SeaGullRouteManager.m
//  SGC
//
//  Created by Brandon Altvater on 7/14/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import "SeaGullRouteManager.h"

@implementation SeaGullRouteManager

+ (SeaGullRouteManager*) sharedInstance {
    static SeaGullRouteManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SeaGullRouteManager alloc]init];
    });
    return sharedInstance;
    
}

-(id)init {

    return self;
}

//TODO: Fix this Method
- (NSArray*)showRouteBottomToolBar {
    
    NSArray *toolbar = [[NSArray alloc]init];
    UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:self action:nil];
    
    UIBarButtonItem *sagWagon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sagWagon25"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(callWagon:)];
    
    toolbar = [NSArray arrayWithObjects: flexiableItem, sagWagon, flexiableItem, nil];
    
    
    
    NSLog(@"I got called");
    return toolbar;
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
