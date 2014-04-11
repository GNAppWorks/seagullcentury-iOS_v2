//
//  ViewController.m
//  seagullcentury_iOS_v2
//
//  Created by Brandon Altvater on 4/9/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import "MainMenuView.h"
#import "SWRevealViewController.h"

@interface MainMenuView () <SWRevealViewControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation MainMenuView
@synthesize mainView;

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
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
