//
//  SidebarSettingsTableViewController.m
//  seagullcentury_iOS_v2
//
//  Created by Brandon Altvater on 4/10/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString *CellIdentifier = @"SettingsList";

#import "SidebarSettingsTableViewController.h"

@interface SidebarSettingsTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property NSUserDefaults *masterSettings;
@property NSArray *settingsList;

-(void)buildView;
@end

@implementation SidebarSettingsTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self buildView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.masterSettings =[NSUserDefaults standardUserDefaults];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
    // Configure the cell...
    if (indexPath.section == 0) {
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",[self.settingsList objectAtIndex:indexPath.row]];
        
        UISwitch *settingsSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        settingsSwitch.onTintColor = UIColorFromRGB(0X800000);
        [cell addSubview:settingsSwitch];
        cell.accessoryView = settingsSwitch;
        
        [(UISwitch *) cell.accessoryView setOn:[self.masterSettings boolForKey:[self.settingsList objectAtIndex:indexPath.row]]];
        
        [(UISwitch *) cell.accessoryView addTarget:self action:@selector(eventSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView.tag = [self.settingsList indexOfObject:[self.settingsList objectAtIndex:indexPath.row]];
        
        
    } if (indexPath.section == 1 ){
        
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",[self.settingsList objectAtIndex:indexPath.row + 3]];
        
        
    }
    
    return cell;
    
    
}


- (void)buildView
{
    self.settingsList = [NSArray arrayWithObjects:@"Speed", @"Vendors", @"Checkpoints", nil];
    
    self.myTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 270, 500) style:UITableViewStyleGrouped];
    
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.myTableView.scrollEnabled = NO;
    self.myTableView.allowsSelection = NO;
    [self.view addSubview:self.myTableView];
     
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0){
        return 30.0f;
    }if (section == 1) {
        return 30.0f;
    }
    
    return 0.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0){
        return 45.0f;
    }if (section == 1) {
        return 45.0f;
    }
    
    return 0.0f;
    
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
        if (section == 0){
            return @"Map View Options";
        }if (section == 1) {
            return @"Social Media";
        }
    
    return nil;
    
}

- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    if (section == 0){
        return @"Select which default items you\nwish to see on the map";
    } if (section == 1){
        return @"Select which social media site\nyou wish to post to";
    }

    return nil;
}

-(void) eventSwitchChanged: (id)sender{
    
    UISwitch * theSwitch = (UISwitch *) sender;
    long number = ((UISwitch*) sender).tag;
    
    switch (number) {
        case 0:
            [self.masterSettings setBool:theSwitch.isOn forKey:@"Speed"];
            break;
        case 1:
            [self.masterSettings setBool:theSwitch.isOn forKey:@"Vendors"];
            break;
        case 2:
            [self.masterSettings setBool:theSwitch.isOn forKey:@"Waypoints"];
            break;
        default:
            break;
    }
    
}
@end
