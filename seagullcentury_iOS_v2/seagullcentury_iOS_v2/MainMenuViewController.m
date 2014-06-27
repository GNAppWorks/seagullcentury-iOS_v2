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

#import "SeaGullCenturyEvent.h"

@interface MainMenuViewController () <SWRevealViewControllerDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSURLRequest *urlObject;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (strong, nonatomic) SeaGullCenturyEvent *seaGullEvent;

- (IBAction)facebookShare:(UIBarButtonItem *)sender;
- (IBAction)twitterShare:(UIBarButtonItem *)sender;
- (IBAction)routeSelectMethod:(UIButton *)sender;

- (void) initalSetup;
- (void) checkLocation;

@property NSUserDefaults *masterSettings;


@end

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.revealViewController.delegate = self;

    [self initalSetup];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkLocation];
    [self.mainView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    
    if (position == FrontViewPositionRight) {
        [self.scrollView setUserInteractionEnabled:NO];
        [self.navigationController.toolbar setUserInteractionEnabled:NO];
    } else {
        [self.scrollView setUserInteractionEnabled:YES];
        [self.navigationController.toolbar setUserInteractionEnabled:YES];
        
    }
    
}


#pragma mark - Design Setup
- (void) initalSetup
{
    self.scrollView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    self.sidebarButton.target = self.revealViewController;
    self.sidebarButton.action = @selector(revealToggle:);
    
    self.title = @"Seagull Century";
    
    self.seaGullEvent = [[SeaGullCenturyEvent alloc]init];
    self.urlObject = [[NSURLRequest alloc]init];
    
    
}

- (void) checkLocation
{
    
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
            alert = nil;
        }
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"toMap"]){
        if ([segue.destinationViewController isKindOfClass:[RouteMapViewController class]]) {
            self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
                                                                                  target:nil action:nil];
            RouteMapViewController *controller = (RouteMapViewController *) [segue destinationViewController];
            controller.urlObject = self.urlObject;
            
            if (self.seaGullEvent.displayRouteBool) {
                controller.routeBool = YES;
            }else {
                controller.routeBool = NO;
            }
            
        }
    }
    
}

- (IBAction)routeSelectMethod:(UIButton *)sender
{
    UIButton *button = (UIButton*)sender;
    
    switch (button.tag) {
        case 1:
            self.urlObject = self.seaGullEvent.selectRoute[(button.tag - 1)];
            break;
        case 2:
            self.urlObject = self.seaGullEvent.selectRoute[(button.tag - 1)];
            break;
        case 3:
            self.urlObject = self.seaGullEvent.selectRoute[(button.tag - 1)];
            break;
        case 4:
            self.urlObject = self.seaGullEvent.selectRoute[(button.tag - 1)];
            self.seaGullEvent.displayRouteBool = NO;
            NSLog(@"NSURLRequest Object: %@", self.urlObject);
            break;
        default:
            break;
    }
    
    [self performSegueWithIdentifier:@"toMap" sender:self];
    
    
}

- (IBAction)facebookShare:(UIBarButtonItem *)sender
{
    
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        
        [FBDialogs presentOSIntegratedShareDialogModallyFrom:self initialText:@"" image:nil url:[NSURL URLWithString:@"http://www.seagullcentury.org"] handler:^(FBOSIntegratedShareDialogResult result, NSError *error){
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

- (IBAction)twitterShare:(UIBarButtonItem *)sender
{
    
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
@end
