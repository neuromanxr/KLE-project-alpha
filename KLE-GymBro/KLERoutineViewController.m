//
//  KLERoutineViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/8/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLERoutineViewCell.h"
#import "KLEStat.h"
#import "KLEStatStore.h"
#import "KLERoutinesStore.h"
#import "KLERoutineViewController.h"
#import "KLERoutineExercisesViewController.h"
#import "KLEExerciseListViewController.h"

@implementation KLERoutineViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        // title for rvc
        navItem.title = @"Your Routines";
        
        // button to add exercises
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewRoutine)];
        
        // button to edit routine
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editRoutines)];
        
        // set the button to be the right nav button of the nav item
        navItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:addButton, editButton, nil];
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[KLERoutinesStore sharedStore] allStatStores] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create an instance of UITableViewCell, with default appearance
    KLERoutineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLERoutineViewCell" forIndexPath:indexPath];
    
    NSArray *statStoreArray = [[KLERoutinesStore sharedStore] allStatStores];
    KLEStatStore *statStore = statStoreArray[indexPath.row];
    
    cell.exerciseLabel.text = [statStore description];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    KLERoutineExercisesViewController *revc = [[KLERoutineExercisesViewController alloc] init];
    
    [self.navigationController pushViewController:revc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Cell selected");
}

- (void)addNewRoutine
{
    // create a new KLEStatStore and add it to the routine store
    KLEStatStore *newStatStore = [[KLERoutinesStore sharedStore] createStatStore];
    
    [self.tableView reloadData];
    
    NSLog(@"new stat%@", newStatStore);
    
//    KLEExerciseListViewController *evc = [[KLEExerciseListViewController alloc] initForNewExercise:YES];
//    exerciseListViewController.exercise = newStat;
    
    // completion block that will reload the table
//    detailViewController.dismissBlock = ^{
//        [self.tableView reloadData];
//    };
    
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:evc];
//    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
//    self.navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self.navigationController pushViewController:evc animated:YES];
//    [self presentViewController:navController animated:YES completion:nil];
    NSLog(@"Add new routine");
}

- (void)editRoutines
{
    NSLog(@"Edit button tapped");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLERoutineViewCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLERoutineViewCell"];
    
}

@end
