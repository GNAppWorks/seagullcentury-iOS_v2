//
//  SeaGullCenturyRoutes.m
//  seagullcentury_iOS_v2
//
//  Created by Brandon Altvater on 5/12/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import "SeaGullCenturyEvent.h"

@interface SeaGullCenturyEvent ()

@property (strong, nonatomic) NSString *internalPath;
@property (strong, nonatomic) NSMutableArray *routes;
@property (nonatomic) NSUInteger routeNumber;

@property (strong, nonatomic) NSUserDefaults *masterSettings;

-(NSString *) getUserSettings;

@end

@implementation SeaGullCenturyEvent

-(NSUserDefaults *) masterSettings {
    if (!_masterSettings) {
        _masterSettings = [NSUserDefaults standardUserDefaults];
    }
    return _masterSettings;
}

-(NSString *) internalPath
{
    if (!_internalPath) _internalPath = [[NSBundle mainBundle] pathForResource:@"index"
                                                                        ofType:@"html"
                                                                   inDirectory:@"seagullcentury-leaflet"];
    return _internalPath;
}
-(NSMutableArray *) routes {
    
    if(!_routes) _routes = [[NSMutableArray alloc]init];
    
    return _routes;
}

- (NSArray *) selectRoute {
    
    NSString *completeString = [[NSString alloc]init];
    if (!_selectRoute) {
        
        for (int i = 0; i < 3; i++) {
            completeString = [NSString stringWithFormat:@"%@?route=%d&%@",self.internalPath, i, self.getUserSettings];
            
            [self.routes addObject:completeString];
        }
        
    } else {
        for (int i = 0; i < 3; i++) {
            completeString = [NSString stringWithFormat:@"%@?route=%d&%@",self.internalPath, i, self.getUserSettings];
            
            [self.routes removeAllObjects];
            [self.routes addObject:completeString];
        }
    }
    _selectRoute = [NSArray arrayWithArray:self.routes];
    return _selectRoute;
}

- (NSString *) getUserSettings {
    
    int speedSettings = (int)[self.masterSettings boolForKey:@"Speed"];
    int vendorSetting = (int)[self.masterSettings boolForKey:@"Vendors"];
    int waypointSetting = (int)[self.masterSettings boolForKey:@"Waypoints"];
    
    NSString *userSettings = [[NSString alloc]init];
    
    userSettings = [NSString stringWithFormat:@"speed=%d&vendors=%d&waypoint=%d", speedSettings, vendorSetting, waypointSetting];
    
    return userSettings;
    
}


@end
