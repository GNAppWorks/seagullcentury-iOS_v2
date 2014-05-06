//
//  ViewController.m
//  seagullcentury_iOS_v2
//
//  Created by Brandon Altvater on 4/9/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import "MainMenuViewController.h"
#import "SWRevealViewController.h"
#import "RouteMapViewController.h"

@interface MainMenuViewController () <SWRevealViewControllerDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) NSString *urlString;

- (IBAction)facebookShare:(UIBarButtonItem *)sender;
- (IBAction)twitterShare:(UIBarButtonItem *)sender;
- (IBAction)routeSelectMethod:(UIButton *)sender;
- (IBAction)callWagon:(UIBarButtonItem *)sender;

- (void) initalSetup;
- (void) checkLocation;

@property NSUserDefaults *masterSettings;


@end

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initalSetup];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkLocation];
    
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    return YES;
}

#pragma mark - Design Setup
- (void) initalSetup{
    
    //add background
    /*
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SU_background.png"]];
    [myView addSubview:background];
    [myView sendSubviewToBack:background];
     
    myView.contentMode = UIViewContentModeScaleAspectFit;
    */
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    [self.mainView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.title = @"Home";
    
    self.masterSettings = [NSUserDefaults standardUserDefaults];
    [self.masterSettings setBool:YES forKey:@"Speed"];
    [self.masterSettings setBool:NO forKey:@"Vendors"];
    [self.masterSettings setBool:NO forKey:@"Waypoints"];
    
}

- (void) checkLocation{
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userWasAskedForLocationOnce"])
    {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized)
        {
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Location Services Denied"
                                                          message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                         delegate:nil
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
            [alert show];
            alert= nil;
        }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES]
                                                  forKey:@"userWasAskedForLocationOnce"];
        
        if ([CLLocationManager locationServicesEnabled]) //this will trigger the system prompt
        {
            [locationManager startUpdatingLocation];
        }
    }
    
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    // resize the layers based on the view’s new bounds
    [[[self.mainView.layer sublayers] objectAtIndex:0] setFrame:self.mainView.bounds];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
   
    if([segue.identifier isEqualToString:@"toMap"]){
        if ([segue.destinationViewController isKindOfClass:[RouteMapViewController class]]) {
            self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
                                                                                  target:nil action:nil];
            RouteMapViewController *controller = (RouteMapViewController *) [segue destinationViewController];
            controller.urlRoute = self.urlString;
        }
        
        
    }
    
}

- (IBAction)routeSelectMethod:(UIButton *)sender{
    
    UIButton *button = (UIButton*)sender;
    int speedSettings, vendorSetting, waypointSetting;
    speedSettings = (int)[self.masterSettings boolForKey:@"Speed"];
    vendorSetting = (int)[self.masterSettings boolForKey:@"Vendors"];
    waypointSetting = (int)[self.masterSettings boolForKey:@"Waypoints"];
    
    if (button.tag == 1) {
        self.urlString = [NSString stringWithFormat:@"%@&speed=%d&vendors=%d&waypoint=%d", @"http://oxford.esrgc.org/maps/seagullcentury/index.html?route=0", speedSettings, vendorSetting, waypointSetting ];
        
    } else if (button.tag == 2) {
        self.urlString = [NSString stringWithFormat:@"%@&speed=%d&vendors=%d&waypoint=%d", @"http://oxford.esrgc.org/maps/seagullcentury/index.html?route=1", speedSettings, vendorSetting, waypointSetting];
        
    } else if (button.tag == 3){
        self.urlString = [NSString stringWithFormat:@"%@&speed=%d&vendors=%d&waypoint=%d", @"http://oxford.esrgc.org/maps/seagullcentury/index.html?route=2", speedSettings, vendorSetting,waypointSetting];
        
    } else if (button.tag == 4){
        self.urlString = [NSString stringWithFormat:@"%@&speed=%d&vendors=%d&waypoint=%d", @"http://oxford.esrgc.org/maps/seagullcentury/index.html?route=-1", speedSettings, vendorSetting, waypointSetting];
        
    }
    [self performSegueWithIdentifier:@"toMap" sender:self];
    
}

- (IBAction)facebookShare:(UIBarButtonItem *)sender {
    /*
    // Check if the Facebook app is installed and we can present the share dialog
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:@"http://www.seagullcentury.org"];
    params.name = @"Seagull Century";
    params.caption = @"100 mile bike ride held in Salisbury, MD.";
    params.picture = [NSURL URLWithString:@"http://www.seagullcentury.org/template/images/sgc-logo08.jpg"];
    params.description = @"100 mile bike ride.";
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:params.caption
                                  description:params.description
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Seagull Century", @"name",
                                       @"100 mile bike ride held in Salisbury, MD.", @"caption",
                                       @"100 mile bike ride.", @"description",
                                       @"http://www.seagullcentury.org", @"link",
                                       @"http://www.seagullcentury.org/template/images/sgc-logo08.jpg", @"picture",
                                       nil];
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }

*/
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        /*
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:@"Seagull Century"];
        [self presentViewController:facebookSheet animated:YES completion:nil];
         
         */
        
        [FBDialogs presentOSIntegratedShareDialogModallyFrom:self initialText:@"" image:nil url:[NSURL URLWithString:@"http://www.google.com"] handler:^(FBOSIntegratedShareDialogResult result, NSError *error){
            if(error)
            {
                NSLog(@"Error: %@", error.description);
            }
        }];
         
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a Facebook posts right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
 
    
}

- (IBAction)twitterShare:(UIBarButtonItem *)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@" #SGC14"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                      // Here goes the code to handle the links
                                      // Use the links to show a relevant view of your app to the user
                                  }];
    
    return urlWasHandled;
}
 

- (IBAction)callWagon:(UIBarButtonItem *)sender {
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://2489908484"]];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@" This is not an iPhone and cannot make calls" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
