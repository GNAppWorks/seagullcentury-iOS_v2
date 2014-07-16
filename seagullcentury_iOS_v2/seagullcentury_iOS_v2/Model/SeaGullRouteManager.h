//
//  SeaGullRouteManager.h
//  SGC
//
//  Created by Brandon Altvater on 7/14/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface SeaGullRouteManager : NSObject

+ (SeaGullRouteManager*) sharedInstance;

-(NSArray *) showRouteBottomToolBar;
-(NSArray *) showWebBottomToolBar:(UIWebView*)webView;
-(void) checkLocation;

@end
