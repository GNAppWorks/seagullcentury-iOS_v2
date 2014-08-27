//
//  SeaGullCenturyRoutes.m
//  seagullcentury_iOS_v2
//
//  Created by Brandon Altvater on 5/12/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import "SeaGullRouteModel.h"

@interface SeaGullRouteModel ()

@property (copy, nonatomic) NSString *internalPath;
@property (strong, nonatomic) NSMutableArray *routes;
@property (nonatomic) NSUInteger routeNumber;

@property (strong, nonatomic) NSUserDefaults *masterSettings;

@end

@implementation SeaGullRouteModel

-(NSUserDefaults *) masterSettings {
    if (!_masterSettings) _masterSettings = [NSUserDefaults standardUserDefaults];

    return _masterSettings;
}

-(NSString *) internalPath {
    if (!_internalPath) _internalPath = [[NSBundle mainBundle] pathForResource:@"index"
                                                                        ofType:@"html"
                                                                   inDirectory:@"seagullcentury-leaflet"];
    return _internalPath;
}
-(NSMutableArray *) routes {
    
    if(!_routes) _routes = [[NSMutableArray alloc]init];
    
    return _routes;
}

-(NSArray *) selectRoute {
    
    NSString *completeString = [[NSString alloc]init];
    NSURL *url = [NSURL fileURLWithPath:self.internalPath];
    NSString *theAbsoluteURLString = [url absoluteString];
    
    if (!_selectRoute) {
        
        for (int i = 0; i < 3; i++) {
            completeString = [NSString stringWithFormat:@"%@?route=%d&%@", theAbsoluteURLString , i, self.retrieveSettings];
            
            NSURLRequest *finalURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: completeString]];
            
            [self.routes addObject:finalURLRequest];
        }
        
    } else {
        [self.routes removeAllObjects];
        
        for (int i = 0; i < 3; i++) {
            completeString = [NSString stringWithFormat:@"%@?route=%d&%@",theAbsoluteURLString, i, self.retrieveSettings];
            
           NSURLRequest *finalURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: completeString]];
            
            [self.routes addObject:finalURLRequest];
        }
    }
    
    [self.routes addObject:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.seagullcentury.org"]]];
    
    _selectRoute = [NSArray arrayWithArray:self.routes];
    
    return _selectRoute;
}

-(NSString *) retrieveSettings {
    
    int speedSetting = (int)[self.masterSettings boolForKey:@"Speed"];
    int vendorSetting = (int)[self.masterSettings boolForKey:@"Vendors"];
    int restStopSettings = (int)[self.masterSettings boolForKey:@"Rest Stops"];
    
    NSString *userSettings = [[NSString alloc]init];
    
    userSettings = [NSString stringWithFormat:@"speed=%d&vendors=%d&waypoint=%d", speedSetting, vendorSetting, restStopSettings];
    return userSettings;
    
}


@end
