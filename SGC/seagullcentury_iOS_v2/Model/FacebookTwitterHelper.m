//
//  FacebookHelperManager.m
//  SGC
//
//  Created by Brandon Altvater on 8/1/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import "FacebookTwitterHelper.h"


@implementation FacebookTwitterHelper

+ (FacebookTwitterHelper*)sharedInstance {
    static FacebookTwitterHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FacebookTwitterHelper alloc]init];
    });
    return _sharedInstance;
    
}

-(id)init {
    self = [super init];
    
    return self;
}

- (void)facebookShare:(NSString *)urlToShare {
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:urlToShare];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present the share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              // NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              //NSLog(@"result %@", results);
                                          }
                                      }];
    } else {
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Sea Gull Century", @"name",
                                       @"http://www.seagullcentury.org", @"link",
                                       @"Among the largest and oldest ride on the east coast.", @"caption",
                                       @"http://www.seagullcentury.org/galleries/2013/pics/SGCgllry2013_58.jpg", @"picture",
                                       nil];
        // Present the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          //NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              // NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  // NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  //NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  // NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
    
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

@end
