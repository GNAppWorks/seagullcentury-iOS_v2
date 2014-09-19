//
//  AppDelegate.m
//  seagullcentury_iOS_v2
//
//  Created by Brandon Altvater on 4/9/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#define ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#import "AppDelegate.h"
#import "Harpy.h"
#import "iRate.h"
#import "SeaGullRouteManager.h"

@implementation AppDelegate

+ (void)initialize
{
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 5;
    [iRate sharedInstance].usesUntilPrompt = 15;
    [iRate sharedInstance].verboseLogging = NO;
    
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      //NSLog(@"Unhandled deep link: %@", url);
                                      // Here goes the code to handle the links
                                      // Use the links to show a relevant view of your app to the user
                                  }];
    
    return urlWasHandled;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBarTintColor:ColorFromRGB(0X800000)];
    [[UINavigationBar appearance] setTintColor:ColorFromRGB(0XF7C55A)];
    [[UIToolbar appearance] setBarTintColor:ColorFromRGB(0X800000)];
    [[UIToolbar appearance] setTintColor:ColorFromRGB(0XF7C55A)];

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Baskerville-SemiBold" size:22.0], NSFontAttributeName, nil]];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self.window makeKeyAndVisible];
    [[Harpy sharedInstance] setAppID:@"896362043"];
    [[Harpy sharedInstance] setAppName:@"Sea Gull Century"];
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeForce];
    [[Harpy sharedInstance] checkVersion];
    
    
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Save"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[SeaGullRouteManager sharedInstance] stopLocation];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
