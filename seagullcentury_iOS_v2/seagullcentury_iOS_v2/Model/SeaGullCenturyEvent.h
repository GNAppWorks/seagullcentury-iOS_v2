//
//  SeaGullCenturyRoutes.h
//  seagullcentury_iOS_v2
//
//  Created by Brandon Altvater on 5/12/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeaGullCenturyEvent : NSObject


@property (strong, nonatomic) NSString *contents;

- (instancetype) initWithBaseURLString: (NSString *)baseURLString;

@end
