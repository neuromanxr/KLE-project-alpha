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

#import "KLERoutineViewController.h"
#import "KLERoutineExercisesViewController.h"
#import "KLEExerciseListViewController.h"

@interface KLERoutineViewController () <UITextFieldDelegate>

//@property (nonatomic, weak) KLERoutineViewCell *routineViewCell;

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
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"dayname" ascending:YES], nil];
//    KLERoutines *routines = (KLERoutines *)[self.frc.managedObjectContext existingObjectWithID:self.routinesID error:nil];
//    KLERoutines *routines = (KLERoutines *)[self.frc.managedObjectContext objectWithID:self.routinesID];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"routines == %@", routines];
//    [request setPredicate:predicate];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"dayname" cacheName:nil];
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
    KLERoutineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLERoutineViewCell" forIndexPath:indexPath];
    
    KLERoutine *routine = [self.frc objectAtIndexPath:indexPath];

    cell.nameLabel.text = routine.routinename;
    
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectID *routineID = [[self.frc objectAtIndexPath:indexPath] objectID];
    
    if (self.delegate) {
        
        [self.delegate selectedRoutineID:routineID];
        NSLog(@"##DELEGATE %@", self.delegate);
    }
    
    KLERoutine *routine = (KLERoutine *)[self.frc.managedObjectContext existingObjectWithID:routineID error:nil];
    
    NSLog(@"Cell selected %@", routine);
    
    
    KLERoutineExercisesViewController *revc = (KLERoutineExercisesViewController *)self.delegate;
    
//    KLEAppDelegate *appDelegate = (KLEAppDelegate *)[[UIApplication sharedApplication] delegate];
//    KLERoutineExercisesViewController *revc = appDelegate.routineExercisesViewController;
    
    revc.selectedRoutineID = routineID;
    
    UINavigationController *revcNav = revc.navigationController;
    
    [self showDetailViewController:revcNav sender:self];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    // if the table view is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // test
        KLERoutine *deleteTarget = [self.frc objectAtIndexPath:indexPath];
        [self.frc.managedObjectContext deleteObject:deleteTarget];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // alert the user about deletion
        UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Delete routine" message:@"This will also delete the routine in Daily" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [deleteAlert show];
        
    }
}

- (void)addNewRoutine:(NSString *)name
{
    KLERoutine *newRoutine = [NSEntityDescription insertNewObjectForEntityForName:@"KLERoutine" inManagedObjectContext:self.frc.managedObjectContext];
    
    newRoutine.routinename = name;
    newRoutine.dayname = @"Day";

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
    NSString *regexPatternUnlimited = @"^[a-z]+$";
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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
