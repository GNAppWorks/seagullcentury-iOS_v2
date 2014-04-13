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

@interface MainMenuView () <SWRevealViewControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) NSString *urlString;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)routeSelectMethod:(UIButton *)sender;


@end

@implementation MainMenuView

@synthesize mainView;
@synthesize urlString;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self backgroundSetup];
    
}



//*************PlayGround




//*****EndPlayground



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    return YES;
}

#pragma mark - Design Setup
- (void) backgroundSetup
{
    //add background
    /*
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SU_background.png"]];
    [myView addSubview:background];
    [myView sendSubviewToBack:background];
     
    //myView.contentMode = UIViewContentModeScaleAspectFit;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:143/255.0f green:17/255.0f blue:17/255.0f alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor yellowColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    */
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    
    [mainView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.title = @"Route Selection";
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"toMap"]){
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    RouteMapViewController *controller = (RouteMapViewController *) [segue destinationViewController];
    controller.urlRoute = urlString; 
    }
    
    
}

-(void) viewDidLayoutSubviews{
    self.scrollView.contentSize = CGSizeMake(320,1000);


}

- (IBAction)routeSelectMethod:(UIButton *)sender {
    UIButton *button = (UIButton*)sender;
    if (button.tag == 1) {
        urlString = @"http://apps.esrgc.org/maps/seagullcentury/index.html?route=0";
        NSLog(@"I Clicked the 100k");
    } else if (button.tag == 2) {
        urlString = @"http://apps.esrgc.org/maps/seagullcentury/index.html?route=1";
          NSLog(@"I Clicked the 50k");
    } else if (button.tag == 3){
        urlString = @"http://apps.esrgc.org/maps/seagullcentury/index.html?route=2";
          NSLog(@"I Clicked the 50m");
    } else if (button.tag == 4){
        urlString = @"http://apps.esrgc.org/maps/seagullcentury/index.html?route=9";        NSLog(@"I Clicked the vendor button");
    }
    [self performSegueWithIdentifier:@"toMap" sender:self];
    
}
@end
