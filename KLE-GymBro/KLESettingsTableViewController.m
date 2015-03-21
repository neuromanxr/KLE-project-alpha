//
//  KLESettingsTableViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/12/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
#import "KLESettingsTableViewController.h"

@interface KLESettingsTableViewController ()

- (IBAction)weightUnitSwitch:(UISwitch *)sender;
@property (strong, nonatomic) IBOutlet UISwitch *weightUnitSwitch;
@end

@implementation KLESettingsTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        
        
        
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLESettingsTableViewCell" bundle:nil];
    //    [[NSBundle mainBundle] loadNibNamed:@"KLESettingsTableViewCell" owner:self options:nil];
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLESettingsTableViewCell"];
    
    [self setupNavigationBar];
    
    [self setWeightSwitchState];
    
}

- (void)setupNavigationBar
{
    // custom title for navigation title
    NSArray *fontFamily = [UIFont fontNamesForFamilyName:@"Heiti TC"];
    UIFont *font = [UIFont fontWithName:[fontFamily firstObject] size:18.0];
    NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:@"Settings" attributes:@{ NSFontAttributeName : font, NSUnderlineStyleAttributeName : @0, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    // custom title for navigation title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 0;
    title.attributedText = attribString;
    [title sizeToFit];
    
    [self.navigationItem setTitleView:title];
}

- (void)setWeightSwitchState
{
    if ([[KLEUtility weightUnitType] isEqualToString:kUnitPounds])
    {
        [_weightUnitSwitch setOn:YES];
    }
    else
    {
        [_weightUnitSwitch setOn:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    
    [headerView.textLabel setFont:[KLEUtility getFontFromFontFamilyWithSize:17.0]];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    if (section == 0)
//    {
//        return 1;
//    }
//    return 2;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLESettingsTableViewCell" forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

- (IBAction)weightUnitSwitch:(UISwitch *)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (sender.isOn) {
        
        [userDefaults setObject:kUnitPounds forKey:kUnitWeightKey];
         NSLog(@"SWITCH ON to LBs, %@", [userDefaults stringForKey:kUnitWeightKey]);
        
    }
    else
    {
        
        [userDefaults setObject:kUnitKilograms forKey:kUnitWeightKey];
        NSLog(@"SWITCH OFF to KGs, %@", [userDefaults stringForKey:kUnitWeightKey]);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kWeightUnitChangedNote object:nil];
}
@end
