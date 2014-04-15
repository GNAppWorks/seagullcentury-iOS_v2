//
//  SidebarSettingsTableViewController.m
//  seagullcentury_iOS_v2
//
//  Created by Brandon Altvater on 4/10/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//
static NSString *CellIdentifier = @"SettingsList";

#import "SidebarSettingsTableViewController.h"

@interface SidebarSettingsTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property NSUserDefaults *masterSettings;
@property NSArray *settingsList;

-(void)buildView;
@end

@implementation SidebarSettingsTableViewController
@synthesize  settingsList;
@synthesize masterSettings;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    masterSettings =[NSUserDefaults standardUserDefaults];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
    // Configure the cell...
    if (indexPath.section == 0) {
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",[settingsList objectAtIndex:indexPath.row]];
        
        UISwitch *settingsSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        settingsSwitch.onTintColor = [UIColor colorWithRed:143/255.0f green:17/255.0f blue:17/255.0f alpha:1];
        [cell addSubview:settingsSwitch];
        cell.accessoryView = settingsSwitch;
        
        [(UISwitch *) cell.accessoryView setOn:[masterSettings boolForKey:[settingsList objectAtIndex:indexPath.row]]];
        
        [(UISwitch *) cell.accessoryView addTarget:self action:@selector(eventSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView.tag = [settingsList indexOfObject:[settingsList objectAtIndex:indexPath.row]];
        
        
    } if (indexPath.section == 1 ){
        
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",[settingsList objectAtIndex:indexPath.row + 3]];
        
        
    }
    
    return cell;
    
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)buildView
{
    settingsList = [NSArray arrayWithObjects:@"Speed", @"Vendors", @"Waypoints", nil];
    
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
    
    masterSettings = [NSUserDefaults standardUserDefaults];
    UISwitch * theSwitch = (UISwitch *) sender;
    long number = ((UISwitch*) sender).tag;
    
    switch (number) {
        case 0:
            [masterSettings setBool:theSwitch.isOn forKey:@"Speed"];
            break;
        case 1:
            [masterSettings setBool:theSwitch.isOn forKey:@"Vendors"];
            break;
        case 2:
            [masterSettings setBool:theSwitch.isOn forKey:@"Waypoints"];
            break;
        default:
            break;
    }
    
}
@end
