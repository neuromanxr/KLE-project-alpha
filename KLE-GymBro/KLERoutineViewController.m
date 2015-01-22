//
//  KLERoutineViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/8/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "CoreDataHelper.h"
#import "KLEAppDelegate.h"
#import "KLERoutine.h"

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
//    KLERoutines *routines = (KLERoutines *)[self.frc.managedObjectContext existingObjectWithID:self.routinesID error:nil];
//    KLERoutines *routines = (KLERoutines *)[self.frc.managedObjectContext objectWithID:self.routinesID];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"routines == %@", routines];
//    [request setPredicate:predicate];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"routinename" cacheName:nil];
    self.frc.delegate = self;
//    NSLog(@"routines %@", routines);
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        // title for rvc
        navItem.title = @"Routines";
        
        // button to add exercises
//        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewRoutine)];
        
        // button to edit routine
//        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:nil];
        
        // set bar button to toggle editing mode
//        editButton = self.editButtonItem;
        
        // set the button to be the right nav button of the nav item
//        navItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:addButton, editButton, nil];
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // create an instance of UITableViewCell, with default appearance
    self.routineViewCell = [tableView dequeueReusableCellWithIdentifier:@"KLERoutineViewCell" forIndexPath:indexPath];
    
    KLERoutine *routine = [self.frc objectAtIndexPath:indexPath];
//    self.routineViewCell.routineNameField.delegate = self;
//    self.routineViewCell.routineNameField.tag = indexPath.row;
    self.routineViewCell.nameLabel.text = routine.routinename;
    self.routineViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    KLERoutineExercisesViewController *revc = [[KLERoutineExercisesViewController alloc] init];
    
    // pass selected routine ID from routine view controller to routine exercise view controller
    KLERoutine *selectedRoutine = [self.frc objectAtIndexPath:indexPath];
    NSLog(@"selected routine ID %@", selectedRoutine.routinename);
    revc.selectedRoutineID = selectedRoutine.objectID;
    
    [self.navigationController pushViewController:revc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *statStoreArray = [[KLERoutinesStore sharedStore] allStatStores];
//    KLEStatStore *routine = statStoreArray[indexPath.row];
    NSManagedObjectID *routineID = [[self.frc objectAtIndexPath:indexPath] objectID];
    if (self.delegate) {
        [self.delegate selectedRoutineID:routineID];
        NSLog(@"##DELEGATE %@", self.delegate);
    }
    
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
        UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Delete routine" message:@"This will also delete the routine in Daily" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [deleteAlert show];
        
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

- (void)addNewRoutine:(NSString *)name
{
    KLERoutine *newRoutine = [NSEntityDescription insertNewObjectForEntityForName:@"KLERoutine" inManagedObjectContext:self.frc.managedObjectContext];
    
    newRoutine.routinename = name;

    NSLog(@"new routine %@", newRoutine.routinename);
}

- (void)showRoutineNameAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Routine Name" message:@"Enter Routine Name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeDefault;
    
    [alertView show];
}

- (BOOL)validateText:(NSString *)routineName
{
    NSError *error = NULL;
    NSString *regexPatternUnlimited = @"^[0-9]+$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPatternUnlimited options:NSRegularExpressionCaseInsensitive error:&error];
    if ([regex numberOfMatchesInString:routineName options:0 range:NSMakeRange(0, routineName.length)]) {
        NSLog(@"Success Match");
        return YES;
    }
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *routineName = [[alertView textFieldAtIndex:0] text];
    if (buttonIndex == 0) {
        NSLog(@"CANCELLED");
    } else {
        NSLog(@"OK %@", routineName);
        [self addNewRoutine:routineName];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *routineName = [[alertView textFieldAtIndex:0] text];
    if ([self validateText:routineName]) {
        NSLog(@"INPUT OK");
        [alertView textFieldAtIndex:0].textColor = [UIColor blueColor];
        return YES;
    } else {
        NSLog(@"INVALID INPUT");
        [alertView textFieldAtIndex:0].textColor = [UIColor redColor];
    }
    return NO;
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

    routine.daynumber = self.dayNumber;
    routine.inworkout = [NSNumber numberWithBool:YES];
    routine.exercisecount = @([routine.exercisegoal count]);
    
    NSLog(@"routine inworkout %@ day %@", routine.inworkout, routine.daynumber);
    
    NSLog(@"Save button tapped");
    
    // dismiss the container view controller
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
    
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
    NSLog(@"Text field begin editing tag %lu", textField.tag);
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    // the textfield that is done editing should match with the routine in the routine store
    // using the textfield tags
    NSLog(@"endediting textfield tag %lu", textField.tag);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    KLERoutine *routine = [self.frc objectAtIndexPath:indexPath];
    
    // assign the routine name with the text in the text field
    routine.routinename = textField.text;
    
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
    
    // button to add exercises
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showRoutineNameAlert)];
    
    self.navigationItem.leftBarButtonItem = addButton;
    // button to edit routine
//    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:nil];
    
    // set bar button to toggle editing mode
//    editButton = self.editButtonItem;
    // add a toolbar with a save button for routines selection
//    UIBarButtonItem *select = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSelections)];
//    UIBarButtonItem *spacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    [self.navigationController setToolbarHidden:NO animated:YES];
//    self.toolbarItems = [[NSArray alloc] initWithObjects:select, spacing,addButton, nil];
    
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
