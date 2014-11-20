//
//  KLERoutineViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/8/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEDay.h"
#import "CoreDataHelper.h"
#import "KLEAppDelegate.h"
#import "KLERoutine.h"
#import "KLERoutines.h"

#import "KLERoutineViewCell.h"
#import "KLEStat.h"
#import "KLEStatStore.h"
#import "KLEDailyStore.h"
#import "KLERoutinesStore.h"
#import "KLERoutineViewController.h"
#import "KLERoutineExercisesViewController.h"
#import "KLEExerciseListViewController.h"

@interface KLERoutineViewController () <UITextFieldDelegate>

@property (nonatomic, weak) KLERoutineViewCell *routineViewCell;
@property (nonatomic, strong) KLEStatStore *statStore;

@end

@implementation KLERoutineViewController
#define debug 1

#pragma mark - DATA
- (void)configureFetch
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLERoutine"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"routinename" ascending:YES], nil];
    KLERoutines *routines = (KLERoutines *)[self.frc.managedObjectContext existingObjectWithID:self.routinesID error:nil];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"routines == %@", routines];
//    [request setPredicate:predicate];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"routinename" cacheName:nil];
    self.frc.delegate = self;
    NSLog(@"routines ID %@", self.routinesID);
}

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

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [[[KLERoutinesStore sharedStore] allStatStores] count];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // create an instance of UITableViewCell, with default appearance
    self.routineViewCell = [tableView dequeueReusableCellWithIdentifier:@"KLERoutineViewCell" forIndexPath:indexPath];
    
//    NSArray *statStoreArray = [[KLERoutinesStore sharedStore] allStatStores];
//    self.statStore = statStoreArray[indexPath.row];
//    
//    self.routineViewCell.exerciseLabel.text = [self.statStore description];
//    
//    self.routineViewCell.routineNameField.tag = indexPath.row;
//    self.routineViewCell.routineNameField.delegate = self;
//    
//    NSLog(@"routine name field tag %lu", self.routineViewCell.routineNameField.tag);
//
//    self.routineViewCell.routineNameField.text = self.statStore.routineName;
//    
//    self.routineViewCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    KLERoutine *routine = [self.frc objectAtIndexPath:indexPath];
    self.routineViewCell.routineNameField.tag = indexPath.row;
    self.routineViewCell.routineNameField.text = routine.routinename;
    self.routineViewCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//    NSLog(@"routine %@ fetched count %lu", fetchedObjects, [fetchedObjects count]);
    
    return self.routineViewCell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *statStores = [[KLERoutinesStore sharedStore] allStatStores];
//    KLEStatStore *selectedStatStore = statStores[indexPath.row];
    
    KLERoutineExercisesViewController *revc = [[KLERoutineExercisesViewController alloc] init];
    
    // pass selected statStore from routine view controller to routine exercise view controller
//    revc.statStore = selectedStatStore;
    
    // test
    revc.selectedRoutineID = [[self.frc objectAtIndexPath:indexPath] objectID];
    revc.frc = self.frc;
    
    KLERoutine *selectedRoutine = [self.frc objectAtIndexPath:indexPath];
    NSLog(@"selected routine ID %@", selectedRoutine.routinename);
    
    [self.navigationController pushViewController:revc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *statStoreArray = [[KLERoutinesStore sharedStore] allStatStores];
//    KLEStatStore *routine = statStoreArray[indexPath.row];
    NSManagedObjectID *routineID = [[self.frc objectAtIndexPath:indexPath] objectID];
    KLERoutine *routine = (KLERoutine *)[self.frc.managedObjectContext existingObjectWithID:routineID error:nil];
    
    NSLog(@"Cell selected %@", routine);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
//    KLEDailyStore *dailyStore = [KLEDailyStore sharedStore];
//    NSDictionary *dailyRoutines = [dailyStore allStatStores];
    
//    NSArray *routines = [[KLERoutinesStore sharedStore] allStatStores];
    
    // if the table view is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // test
        KLERoutine *deleteTarget = [self.frc objectAtIndexPath:indexPath];
        [self.frc.managedObjectContext deleteObject:deleteTarget];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // remove the selected routine from the routine store
//        KLEStatStore *routine = routines[indexPath.row];
//        [[KLERoutinesStore sharedStore] removeStatStore:routine];
        
        // also remove that row from the table view with animation
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // alert the user about deletion
//        UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Delete routine" message:@"This will also delete the routine in Daily" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
//        [deleteAlert show];
        
        // check to see if the routine being deleted is in the daily routines
        // if so, delete the routine in daily view too with a warning message
        // check each day also, routine can be in different days
//        for (NSString *key in dailyRoutines) {
//            
//            if ([[dailyRoutines objectForKey:key] containsObject:routine]) {
//                
//                NSMutableArray *routinesInDay = [dailyRoutines objectForKey:key];
//                [routinesInDay removeObjectIdenticalTo:routine];
//                
//                NSLog(@"This routine is in your daily. Day tag in delete %@", key);
        
                // get the index of the routine in daily view
//                NSInteger indexOfDailyRoutine = [[dailyRoutines objectForKey:key] indexOfObjectIdenticalTo:routine];
                
                // get the routine in daily view
//                KLEStatStore *routineInDaily = [[dailyRoutines objectForKey:key] objectAtIndex:indexOfDailyRoutine];
                
                // remove the routine in daily view
//                [dailyStore removeStatStoreFromDay:routineInDaily atIndex:indexOfDailyRoutine atKey:key];
//            }
//        }
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[KLERoutinesStore sharedStore] moveStatStoreAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
    
    // reload the table to update the tag numbers after re-ordering
    [self.tableView reloadData];
}

- (void)addNewRoutine
{
//    // create a new routine and add it to the routine store
//    KLEStatStore *newStatStore = [[KLERoutinesStore sharedStore] createStatStore];
//    
//    // where is this new routine in the array?
//    NSInteger lastRow = [[[KLERoutinesStore sharedStore] allStatStores] indexOfObject:newStatStore];
//    
//    // set the index path to be the last row added
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
//    
//    // give the routine a name
//    newStatStore.routineName = [NSString stringWithFormat:@"Routine %lu", indexPath.row + 1];
//    NSLog(@"Routine name %@", newStatStore.routineName);
    
    // test
    KLERoutine *newRoutine = [NSEntityDescription insertNewObjectForEntityForName:@"KLERoutine" inManagedObjectContext:self.frc.managedObjectContext];
    KLERoutines *routines = (KLERoutines *)[self.frc.managedObjectContext objectWithID:self.routinesID];
    newRoutine.routines = routines;
    
    newRoutine.routinename = [newRoutine description];

    NSLog(@"new routine %@", newRoutine.routinename);
    
//    NSLog(@"unique routine %@", newRoutine);
    
    
    // insert this new row into the table
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)editRoutines
{
    NSLog(@"Edit button tapped");
}

- (void)saveSelections
{
    // get the index path of selected routine
    NSIndexPath *selectedRoutine = [self.tableView indexPathForSelectedRow];
    // get the routine object from fetched results controller
    KLERoutine *routine = (KLERoutine *)[self.frc objectAtIndexPath:selectedRoutine];
    KLEDay *dayInstance = (KLEDay *)[self.frc.managedObjectContext existingObjectWithID:self.dayID error:nil];
    
    routine.day = dayInstance;
    routine.exercisecount = @([routine.exercisegoal count]);
    
    // daily routines entity passed from daily view controller
    [dayInstance addRoutineObject:routine];
    NSLog(@"routine %@ day %@", routine, routine.day);
    
    // don't save the arrays to daily store, instead save the index of the routine in the routine store
    // change daily store to save index
    
    NSLog(@"Save button tapped");
    
//    [cdh saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    // access the routines in routine store
//    NSArray *routinesArray = [[KLERoutinesStore sharedStore] allStatStores];
//    
//    NSLog(@"routines array %@", routinesArray);
//    // access the daily store
//    KLEDailyStore *dailyStore = [KLEDailyStore sharedStore];
//    
//    // access all the routines in daily store
//    NSDictionary *dailyRoutines = [dailyStore allStatStores];
//    
//    NSLog(@"daily store %@", dailyStore);
//    NSLog(@"daily Routines %@", dailyRoutines);
    
    // save the user selections
//    NSArray *selections = [self.tableView indexPathsForSelectedRows];
//    NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
    
//    NSLog(@"selected rows in routine store %@", selections);
    
//    for (NSIndexPath *index in selections) {
//        NSLog(@"Index %lu", index.row);
//        // add the selected routines to the daily store by day
//        [dailyStore addStatStoreToDay:[routinesArray objectAtIndex:index.row] atKey:self.dayTag];
//    }
    
//    // if there are no routines in daily then just add it to daily
//    if ([[dailyRoutines objectForKey:self.dayTag] count] == 0) {
//        [dailyStore addStatStoreToDay:[routinesArray objectAtIndex:selection.row] atKey:self.dayTag];
//        [self.navigationController popViewControllerAnimated:YES];
//    // if there's one or more routine, check if there's a duplicate and show alert if there is
//    // otherwise add the routine to daily
//    } else if ([[dailyRoutines objectForKey:self.dayTag] count] >= 1) {
//        NSLog(@"theres one or more routine");
//        if ([[dailyRoutines objectForKey:self.dayTag] containsObject:[routinesArray objectAtIndex:selection.row]]) {
//            NSLog(@"this is a duplicate");
//            UIAlertView *duplicateAlert = [[UIAlertView alloc] initWithTitle:@"Duplicate routine" message:@"This routine already exists" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//            
//            [duplicateAlert show];
//            [dailyStore addStatStoreToDay:[routinesArray objectAtIndex:selection.row] atKey:self.dayTag];
//            [self.navigationController popViewControllerAnimated:YES];
//        } else {
//            [dailyStore addStatStoreToDay:[routinesArray objectAtIndex:selection.row] atKey:self.dayTag];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
//    
//    NSLog(@"daily routine at key %@", [dailyRoutines objectForKey:self.dayTag]);
//    
//    NSLog(@"daily store after %@", dailyRoutines);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"Text field begin editing %@", textField);
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"textfield ended");
    NSLog(@"textfield ended statstore %@", self.statStore);
    
    NSArray *statStoreArray = [[KLERoutinesStore sharedStore] allStatStores];
    
    // the textfield that is done editing should match with the routine in the routine store
    // using the textfield tags
    self.statStore = statStoreArray[textField.tag];
    NSLog(@"statstore by tag %@", self.statStore);
    
    // assign the routine name with the text in the text field
    self.statStore.routineName = textField.text;
    
    return YES;
}

// hide the keyboard when done with input
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textfield return %@", textField);
    [textField resignFirstResponder];
    
    return YES;
}

- (void)viewDidLoad
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLERoutineViewCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLERoutineViewCell"];
    
    self.tableView.allowsMultipleSelection = NO;
    
    // add a toolbar with a save button for routines selection
    UIBarButtonItem *select = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSelections)];
    [self.navigationController setToolbarHidden:NO animated:YES];
    self.toolbarItems = [[NSArray alloc] initWithObjects:select, nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    // clear first responder
    [self.view endEditing:YES];
}

@end
