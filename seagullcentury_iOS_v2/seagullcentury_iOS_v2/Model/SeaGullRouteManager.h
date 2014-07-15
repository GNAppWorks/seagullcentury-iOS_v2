//
//  SeaGullRouteManager.h
//  SGC
//
//  Created by Brandon Altvater on 7/14/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeaGullRouteManager : NSObject

+ (SeaGullRouteManager*) sharedInstance;

-(NSArray *)showRouteBottomToolBar;

@end
