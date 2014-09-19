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

#import "SeaGullRouteManager.h"
#import "FacebookTwitterHelper.h"

@interface MainMenuViewController () <SWRevealViewControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (nonatomic) NSInteger selectedRouteNumber;
@property (copy, nonatomic) NSURLRequest *urlObject;

- (IBAction)facebookShare:(UIBarButtonItem *)sender;
- (IBAction)twitterShare:(UIBarButtonItem *)sender;
- (IBAction)routeSelectMethod:(UIButton *)sender;

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
    
    self.title = NSLocalizedString(@"Sea Gull Century", nil);
    self.urlObject = [[NSURLRequest alloc]init];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"toMap"]){
        if ([segue.destinationViewController isKindOfClass:[RouteMapViewController class]]) {
            self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
                                                                                  target:nil action:nil];
            RouteMapViewController *controller = (RouteMapViewController *) [segue destinationViewController];
            controller.urlObject = self.urlObject;
            controller.routeBool = [[SeaGullRouteManager sharedInstance]showCorrectToolbar:self.selectedRouteNumber];
            
        }
    }
    
}

- (IBAction)routeSelectMethod:(UIButton *)sender
{
    UIButton *button = (UIButton*)sender;
    self.selectedRouteNumber = button.tag;
    self.urlObject = [[SeaGullRouteManager sharedInstance]determineCorrectRoute:(button.tag)];
    [self performSegueWithIdentifier:@"toMap" sender:self];
}

- (IBAction)facebookShare:(UIBarButtonItem *)sender
{
    [[FacebookTwitterHelper sharedInstance] facebookEasyShare:@"http://www.seagullcentury.org"];
}

- (IBAction)twitterShare:(UIBarButtonItem *)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@" #SGC"];
        [tweetSheet addImage:[UIImage imageNamed:@"SGC_Logo.png"]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"Sorry", nil)
                                  message:NSLocalizedString(@"Can't Tweet", nil)
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}
@end
