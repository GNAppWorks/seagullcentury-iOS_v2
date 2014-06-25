//
//  SeaGullCenturyRoutes.m
//  seagullcentury_iOS_v2
//
//  Created by Brandon Altvater on 5/12/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import "SeaGullCenturyEvent.h"

@interface SeaGullCenturyEvent ()

@property (strong, nonatomic) NSString *baseString;
@property (nonatomic) NSUInteger routeNumber;
@property (strong, nonatomic) NSArray *routesInEvent; // Array of route name.

@end


@implementation SeaGullCenturyEvent

- (NSArray *)routesInEvent
{
    if (!_routesInEvent) _routesInEvent = @[@"Assateague Century",@"Snow Hill Century", @"Princess Anne Metric"];
    return _routesInEvent;
}

-(NSString *) baseString
{
    if (!_baseString) _baseString = [[NSBundle mainBundle] pathForResource:@"index"
                                                                    ofType:@"html"
                                                               inDirectory:@"seagullcentury-leaflet"];
    return _baseString;
}

-(instancetype) initWithBaseURLString:(NSString *)baseURLString
{
    self = [super init];
    if (self) {
        self.baseString = baseURLString;
        
    }
    
    return self;
}

- (NSString *) contents
{
    NSUserDefaults *masterSettings = [NSUserDefaults standardUserDefaults];
    int speedSettings = (int)[masterSettings boolForKey:@"Speed"];
    int vendorSetting = (int)[masterSettings boolForKey:@"Vendors"];
    int waypointSetting = (int)[masterSettings boolForKey:@"Waypoints"];
    
    return [NSString stringWithFormat:@"%@?route=%lu&speed=%d&vendors=%d&watpoint=%d",self.baseString, (unsigned long)self.routeNumber, speedSettings, vendorSetting, waypointSetting];
}


@end
