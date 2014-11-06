//
//  KLERoutineExercisesViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/15/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//
#import "KLEDailyViewController.h"

#import "KLEExercises.h"
#import "KLEStat.h"
#import "KLEStatStore.h"
#import "KLERoutinesStore.h"
#import "KLERoutineExercisesViewCell.h"
#import "KLEExerciseListViewController.h"
#import "KLERoutineExercisesViewController.h"

@interface KLERoutineExercisesViewController () <ELVCDelegate>

@property (nonatomic, copy) NSArray *routinesArray;

@end

@implementation KLERoutineExercisesViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        
        UINavigationItem *navItem = self.navigationItem;
        // title for rvc
        navItem.title = @"Routine Exercises";
        
        // button to add exercises
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewExercise)];
        
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
    return [[self.statStore allStats] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create an instance of UITableViewCell, with default appearance
    KLERoutineExercisesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLERoutineExercisesViewCell" forIndexPath:indexPath];
    
    // access the stat store using the selected index path row
    // then assign the exercise name property to the cell label
//    cell.exerciseNameLabel.text = [[[[KLERoutinesStore sharedStore] allStatStores] objectAtIndex:indexPath.row] exercise];
//    cell.setsLabel.text = [NSString stringWithFormat:@"%d", [[[[KLERoutinesStore sharedStore] allStatStores] objectAtIndex:indexPath.row] sets]];
//    cell.repsLabel.text = [NSString stringWithFormat:@"%d", [[[[KLERoutinesStore sharedStore] allStatStores] objectAtIndex:indexPath.row] reps]];
//    cell.weightLabel.text = [NSString stringWithFormat:@"%.2f", [[[[KLERoutinesStore sharedStore] allStatStores] objectAtIndex:indexPath.row] weight]];
    
    NSArray *statStoreArray = [[NSArray alloc] initWithArray:self.statStore.allStats];
    KLEStat *stat = statStoreArray[indexPath.row];
    cell.exerciseNameLabel.text = stat.exercise;
    cell.setsLabel.text = [NSString stringWithFormat:@"%d", stat.sets];
    cell.repsLabel.text = [NSString stringWithFormat:@"%d", stat.reps];
    cell.weightLabel.text = [NSString stringWithFormat:@"%f", stat.weight];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLEExerciseListViewController *elvc = [[KLEExerciseListViewController alloc] initForNewExercise:NO];
    
    NSArray *statStoreArray = [[NSArray alloc] initWithArray:self.statStore.allStats];
    KLEStat *stat = statStoreArray[indexPath.row];
    
    // pass the selected exercise object to elvc
    elvc.stat = stat;
    
    // delegate
    // not used
    elvc.delegate = self;
    
    [self.navigationController pushViewController:elvc animated:YES];
}

- (void)addNewExercise
{
    KLEExerciseListViewController *elvc = [[KLEExerciseListViewController alloc] initForNewExercise:YES];
    
    // pass the selected statStore to exercise list view controller
    elvc.statStore = self.statStore;
    
    // completion block that will reload the table
    elvc.dismissBlock = ^{
        NSLog(@"parent VC %@", [self.navigationController.viewControllers objectAtIndex:0]);
        KLEDailyViewController *dvc = [self.navigationController.viewControllers objectAtIndex:0];
        NSLog(@"current Action Row Paths %lu", [dvc.currentActionRowPaths count]);
        if ([dvc.currentActionRowPaths count]) {
            [dvc createActionRowPathsFromRoutineIndex:dvc.newRoutineIndex startIndex:dvc.newStartIndex atIndexPath:dvc.currentIndexPath];
        }
    };
    
//    [self.navigationController pushViewController:elvc animated:YES];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:elvc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if the table view is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        KLEStatStore *statStore = self.statStore;
        NSLog(@"revc statStore array %@", statStore);
        NSArray *routineExercises = [statStore allStats];
        KLEStat *exercise = routineExercises[indexPath.row];
        [statStore removeStat:exercise];
        
        // also remove that row from the table view with animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.statStore moveStatAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (void)save:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    // if the user cancelled, then remove the BNRItem from the store
    
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)editRoutines
{
    NSLog(@"Edit button tapped");
}

- (void)selectionFromELVC:(KLEExerciseListViewController *)elvc thisSelection:(NSIndexPath *)selection
{
    NSLog(@"REVC delegate ELVCselection %lu", selection.row);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLERoutineExercisesViewCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLERoutineExercisesViewCell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.tableView reloadData];
}

@end
