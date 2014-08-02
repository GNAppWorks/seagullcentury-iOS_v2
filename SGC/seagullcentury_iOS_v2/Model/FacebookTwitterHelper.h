//
//  FacebookHelperManager.h
//  SGC
//
//  Created by Brandon Altvater on 8/1/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>


@interface FacebookTwitterHelper : NSObject

+ (FacebookTwitterHelper*)sharedInstance;

- (void)facebookShare:(NSString*)urlToShare;

@end
