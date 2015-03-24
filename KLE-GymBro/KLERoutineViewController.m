//
//  KLERoutineViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/8/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEAppDelegate.h"
#import "KLERoutine.h"

#import "KLEUtility.h"
#import "KLERoutineViewCell.h"

#import "KLERoutineDetailTableViewController.h"
#import "KLERoutineViewController.h"
#import "KLERoutineExercisesViewController.h"
#import "KLEExerciseListViewController.h"

@interface KLERoutineViewController () <UITextFieldDelegate>

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
        
//        UINavigationItem *navItem = self.navigationItem;
        
        // button to add exercises
//        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewRoutine)];
        
        // button to edit routine
//        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:nil];
        
        // set bar button to toggle editing mode
//        editButton = self.editButtonItem;
        
        // set the button to be the right nav button of the nav item
//        navItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:addButton, editButton, nil];
        
        self.restorationIdentifier = NSStringFromClass([self class]);
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
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
    
    // restoration ID for tableView
    self.tableView.restorationIdentifier = self.restorationIdentifier;
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
    //    [self.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
//{
//    return [[self alloc] init];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // create an instance of UITableViewCell, with default appearance
    KLERoutineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLERoutineViewCell" forIndexPath:indexPath];
    
    KLERoutine *routine = [self.frc objectAtIndexPath:indexPath];

    cell.nameLabel.text = routine.routinename;
    [cell.routineDetailButton addTarget:self action:@selector(showRoutineDetails:event:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *selectedColorView = [[UIView alloc] init];
    [selectedColorView setBackgroundColor:[UIColor kPrimaryColor]];
    [cell setSelectedBackgroundView:selectedColorView];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    [headerView.backgroundView setBackgroundColor:[UIColor kPrimaryColor]];
    [headerView.backgroundView setAlpha:0.7];
    [headerView.textLabel setTextColor:[UIColor whiteColor]];
    [headerView.textLabel setFont:[KLEUtility getFontFromFontFamilyWithSize:16.0]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (void)showRoutineDetails:(UIButton *)button event:(id)event
{
    KLERoutineViewCell *routineViewCell;
    if ([button.superview.superview isKindOfClass:[KLERoutineViewCell class]]) {
        
        routineViewCell = (KLERoutineViewCell *)button.superview.superview;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:routineViewCell];
    
    NSLog(@"BUTTON SUPERVIEW %@", button.superview.superview);
    
    if (indexPath != nil) {
        
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{

    KLERoutineViewCell *routineCell = (KLERoutineViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [routineCell.nameLabel setTextColor:[UIColor whiteColor]];
    [routineCell.routineDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLERoutineViewCell *routineCell = (KLERoutineViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [routineCell.nameLabel setTextColor:[UIColor kPrimaryColor]];
    [routineCell.routineDetailButton setTitleColor:[UIColor kPrimaryColor] forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"KLEStoryBoard" bundle:nil];
    KLERoutineDetailTableViewController *routineDetailTableViewController = [storyBoard instantiateViewControllerWithIdentifier:@"RoutineDetail"];
    routineDetailTableViewController.selectedRoutine = [self.frc objectAtIndexPath:indexPath];
    
    [self.navigationController pushViewController:routineDetailTableViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectID *routineID = [[self.frc objectAtIndexPath:indexPath] objectID];
    
//    if (self.delegate) {
//        [self.delegate selectedRoutineID:routineID];
//        NSLog(@"##DELEGATE %@", self.delegate);
//    }
    
    KLERoutine *routine = (KLERoutine *)[self.frc.managedObjectContext existingObjectWithID:routineID error:nil];
    
    NSLog(@"Cell selected %@", routine);
    
    /* for split views
    // need a pointer to routine exercises view for showDetailViewController
    KLERoutineExercisesViewController *revc = (KLERoutineExercisesViewController *)self.delegate;
    revc.selectedRoutineID = routineID;
    UINavigationController *revcNav = revc.navigationController;
    
    [self showDetailViewController:revcNav sender:self];
     */
    
    KLERoutineExercisesViewController *routineExercisesView = [KLERoutineExercisesViewController new];
    routineExercisesView.selectedRoutineID = routineID;
    
    [self.navigationController pushViewController:routineExercisesView animated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    // if the table view is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // delete row
        KLERoutine *deleteTarget = [self.frc objectAtIndexPath:indexPath];
        [self.frc.managedObjectContext deleteObject:deleteTarget];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
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
    UIAlertController *routineNameAlert = [UIAlertController alertControllerWithTitle:@"Routine Name" message:@"Enter Routine Name" preferredStyle:UIAlertControllerStyleAlert];
    UITextField *routineNameTextField = routineNameAlert.textFields[0];
    [routineNameTextField setKeyboardType:UIKeyboardTypeDefault];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSString *routineName = [routineNameAlert.textFields[0] text];
        NSLog(@"OK %@", routineName);
        [self addNewRoutine:routineName];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        NSLog(@"CANCELLED");
    }];
    
    [routineNameAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Routine Name";
        textField.delegate = self;
    }];
    
    [routineNameAlert addAction:okAction];
    [routineNameAlert addAction:cancelAction];
    
    [self presentViewController:routineNameAlert animated:YES completion:nil];
    
}

//- (BOOL)validateText:(NSString *)routineName
//{
//    NSError *error = NULL;
//    NSString *regexPatternUnlimited = @"^[a-zA-Z0-9 ]{1,20}+$";
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPatternUnlimited options:NSRegularExpressionCaseInsensitive error:&error];
//    if ([regex numberOfMatchesInString:routineName options:0 range:NSMakeRange(0, routineName.length)]) {
//        NSLog(@"Success Match");
//        return YES;
//    }
//    return NO;
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"TEXTFIELD IN ROUTINE CS");
    if (textField.text.length >= 18 && range.length == 0) {
        return NO;
    }
    return YES;
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



@end
