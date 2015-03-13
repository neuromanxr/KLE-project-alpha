//
//  KLESettingsTableViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/12/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLESettingsTableViewController.h"

@interface KLESettingsTableViewController ()

@end

@implementation KLESettingsTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        
        navItem.title = @"Settings";
        
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0)
    {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLESettingsTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

@end
