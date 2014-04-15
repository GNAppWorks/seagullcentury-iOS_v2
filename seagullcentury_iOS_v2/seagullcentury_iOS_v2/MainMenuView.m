//
//  ViewController.m
//  seagullcentury_iOS_v2
//
//  Created by Brandon Altvater on 4/9/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import "MainMenuView.h"
#import "SWRevealViewController.h"
#import "RouteMapViewController.h"
#import "BackgroundLayer.h"


@interface MainMenuView () <SWRevealViewControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) NSString *urlString;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)routeSelectMethod:(UIButton *)sender;
- (IBAction)callWagon:(UIBarButtonItem *)sender;
- (void) checkLocation;

@property NSUserDefaults *masterSettings;


@end

@implementation MainMenuView

@synthesize mainView;
@synthesize urlString;
@synthesize masterSettings;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self backgroundSetup];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    return YES;
}

#pragma mark - Design Setup
- (void) backgroundSetup{
    
    //add background
    /*
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SU_background.png"]];
    [myView addSubview:background];
    [myView sendSubviewToBack:background];
     
    myView.contentMode = UIViewContentModeScaleAspectFit;
    */
    
    masterSettings = [NSUserDefaults standardUserDefaults];
    [masterSettings setBool:1 forKey:@"Speed"];
    [masterSettings setBool:0 forKey:@"Vendors"];
    [masterSettings setBool:1 forKey:@"Waypoints"];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    [mainView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.title = @"Route Selection";
    
    /*
    // This is just for cool purposes, When you remove this make sure you remove the header files
    CAGradientLayer *bgLayer = [BackgroundLayer greyGradient];
    bgLayer.frame = mainView.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
     */
    
    
    [self checkLocation];
    
    
}

- (void) checkLocation{
    
    if([CLLocationManager locationServicesEnabled]){
        
        //NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                            message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        NSLog(@"Location Services Disabled");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    // resize the layers based on the view’s new bounds
    [[[self.mainView.layer sublayers] objectAtIndex:0] setFrame:self.mainView.bounds];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"toMap"]){
        
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
                                                                              target:nil action:nil];
        RouteMapViewController *controller = (RouteMapViewController *) [segue destinationViewController];
        controller.urlRoute = urlString;
    }
    
}

-(void) viewDidLayoutSubviews{
    
    self.scrollView.contentSize = CGSizeMake(320,1000);
    
}

- (IBAction)routeSelectMethod:(UIButton *)sender{
    
    UIButton *button = (UIButton*)sender;
    masterSettings = [NSUserDefaults standardUserDefaults];
    
    if (button.tag == 1) {
        urlString = [NSString stringWithFormat:@"%@&speed=%d&vendor=%d&waypoint=%d", @"http://apps.esrgc.org/maps/seagullcentury/index.html?route=0", (int)[masterSettings boolForKey:@"Speed"],(int)[masterSettings boolForKey:@"Vendors"], (int)[masterSettings boolForKey:@"Waypoints"]];
        
    } else if (button.tag == 2) {
        urlString = [NSString stringWithFormat:@"%@&speed=%d&vendor=%d&waypoint=%d", @"http://apps.esrgc.org/maps/seagullcentury/index.html?route=1", (int)[masterSettings boolForKey:@"Speed"],(int)[masterSettings boolForKey:@"Vendors"], (int)[masterSettings boolForKey:@"Waypoints"]];
        
    } else if (button.tag == 3){
        urlString = [NSString stringWithFormat:@"%@&speed=%d&vendor=%d&waypoint=%d", @"http://apps.esrgc.org/maps/seagullcentury/index.html?route=2", (int)[masterSettings boolForKey:@"Speed"],(int)[masterSettings boolForKey:@"Vendors"], (int)[masterSettings boolForKey:@"Waypoints"]];
        
    } else if (button.tag == 4){
        urlString = [NSString stringWithFormat:@"%@&speed=%d&vendor=%d&waypoint=%d", @"http://apps.esrgc.org/maps/seagullcentury/index.html?route=9", (int)[masterSettings boolForKey:@"Speed"],(int)[masterSettings boolForKey:@"Vendors"], (int)[masterSettings boolForKey:@"Waypoints"]];
        
    }
    [self performSegueWithIdentifier:@"toMap" sender:self];
    
}
- (IBAction)share:(UIBarButtonItem *)sender {
    
    NSString *text = @"How to add Facebook and Twitter sharing to an iOS app";
    NSURL *url = [NSURL URLWithString:@"http://roadfiresoftware.com/2014/02/how-to-add-facebook-and-twitter-sharing-to-an-ios-app/"];
    //UIImage *image = [UIImage imageNamed:@"roadfire-icon-square-200"];
    
    UIActivityViewController *controller =[[UIActivityViewController alloc] initWithActivityItems:@[text, url] applicationActivities:nil];
    
    controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypeMessage,
                                         UIActivityTypeMail,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop];
     
    
    [self presentViewController:controller animated:YES completion:nil];
    
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
