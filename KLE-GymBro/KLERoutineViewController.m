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
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:nil];
        
        // set bar button to toggle editing mode
        editButton = self.editButtonItem;
        
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if the table view is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *routines = [[KLERoutinesStore sharedStore] allStatStores];
        KLEStatStore *routine = routines[indexPath.row];
        [[KLERoutinesStore sharedStore] removeStatStore:routine];
        
        // also remove that row from the table view with animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[KLERoutinesStore sharedStore] moveStatStoreAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (void)addNewRoutine
{
    // create a new routine and add it to the routine store
    KLEStatStore *newStatStore = [[KLERoutinesStore sharedStore] createStatStore];
    
    // where is this new routine in the array?
    NSInteger lastRow = [[[KLERoutinesStore sharedStore] allStatStores] indexOfObject:newStatStore];
    
    // set the index path to be the last row added
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // insert this new row into the table
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
//    KLERoutineExercisesViewController *revc = [[KLERoutineExercisesViewController alloc] init];
//    [self.navigationController pushViewController:revc animated:YES];
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

@end
