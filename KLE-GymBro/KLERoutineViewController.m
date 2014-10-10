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
#import "KLEDailyStore.h"
#import "KLERoutinesStore.h"
#import "KLERoutineViewController.h"
#import "KLERoutineExercisesViewController.h"
#import "KLEExerciseListViewController.h"

@interface KLERoutineViewController ()

@end

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
    statStore.routineName = cell.routineNameField.text;
    if (![cell.routineNameField hasText]) {
        NSLog(@"name field is empty");
        cell.routineNameField.text = statStore.routineName;
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSArray *statStores = [[KLERoutinesStore sharedStore] allStatStores];
    KLEStatStore *selectedStatStore = statStores[indexPath.row];
    
    KLERoutineExercisesViewController *revc = [[KLERoutineExercisesViewController alloc] init];
    
    // pass selected statStore from routine view controller to routine exercise view controller
    revc.statStore = selectedStatStore;
    
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
    
    // give the routine a name
    newStatStore.routineName = newStatStore.routineName;
    
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

- (void)saveSelections
{
    NSLog(@"Save button tapped");
    
    // access the routines in routine store
    NSArray *routinesArray = [[KLERoutinesStore sharedStore] allStatStores];
    
    NSLog(@"routines array %@", routinesArray);
    // access the daily store
    KLEDailyStore *dailyStore = [KLEDailyStore sharedStore];
    
    // access the all the routines in daily store
    NSDictionary *dailyRoutines = [dailyStore allStatStores];
    
    NSLog(@"daily store %@", dailyStore);
    NSLog(@"daily Routines %@", dailyRoutines);
    
    // save the user selections
    NSArray *selections = [self.tableView indexPathsForSelectedRows];
    
    NSLog(@"selected rows in routine store %@", selections);
    
    for (NSIndexPath *index in selections) {
        NSLog(@"Index %lu", index.row);
        // add the selected routines to the daily store by day
        [dailyStore addStatStoreToDay:[routinesArray objectAtIndex:index.row] atKey:self.dayTag];
    }
    
    NSLog(@"daily store after %@", dailyRoutines);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLERoutineViewCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLERoutineViewCell"];
    
    self.tableView.allowsMultipleSelection = YES;
    
    // add a toolbar with a save button for routines selection
    UIBarButtonItem *select = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSelections)];
    [self.navigationController setToolbarHidden:NO animated:YES];
    self.toolbarItems = [[NSArray alloc] initWithObjects:select, nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
}

@end
