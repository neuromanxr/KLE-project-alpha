//
//  KLERoutineExercisesViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/15/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "Pickers/ActionSheetStringPicker.h"
#import "KLEAppDelegate.h"
#import "KLERoutine.h"
#import "KLEExercise.h"
#import "KLEExerciseGoal.h"
#import "KLEDailyViewController.h"

#import "KLERoutineExercisesViewCell.h"
#import "KLEExerciseListViewController.h"
#import "KLERoutineExercisesViewController.h"
#import "KLERoutineExerciseDetailViewController.h"
#import "KLEWorkoutExerciseViewController.h"

@interface KLERoutineExercisesViewController () <ELVCDelegate, UITextFieldDelegate>

@property (nonatomic, copy) NSArray *routinesArray;

@property (nonatomic, strong) KLETableHeaderView *tableHeaderView;
@property (nonatomic, strong) UITextField *routineTextField;

@end

@implementation KLERoutineExercisesViewController
#define debug 1

+ (instancetype)routineExercisesViewControllerWithMode:(KLERoutineExercisesViewControllerMode)mode
{
    KLERoutineExercisesViewController *routineExercisesViewController = [[KLERoutineExercisesViewController alloc] init];
    [routineExercisesViewController setMode:mode];
    
    return routineExercisesViewController;
}

- (void)setMode:(KLERoutineExercisesViewControllerMode)mode
{
    _mode = mode;
    
    NSLog(@"CURRENT MODE %ld", _mode);
    
    switch (_mode)
    {
        case KLERoutineExercisesViewControllerModeNormal:
            
            break;
        case KLERoutineExercisesViewControllerModeWorkout:
            
            break;
            
        default:
            break;
    }
    
}

/* textfield in the navigation bar
 
- (UIBarButtonItem *)createRoutineTextFieldInNav
{
    self.routineTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.bounds.size.width / 2, 26)];
    self.routineTextField.backgroundColor = [UIColor clearColor];
    self.routineTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.routineTextField.text = @"Routine Name";
    self.routineTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.routineTextField.translatesAutoresizingMaskIntoConstraints = YES;
    self.routineTextField.textAlignment = NSTextAlignmentCenter;
    
    UIBarButtonItem *textFieldBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.routineTextField];
    
    return textFieldBarButton;
}
*/

- (void)createAddExerciseButton
{
    // button to add exercises
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewExercise)];
    
    
    // not used, supplement to display mode button, refer to appcoda split view tutorial
    
    //        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showRoutineViewController)];
    
    
    // set the button to be the right nav button of the nav item
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:addButton, nil];
    
    // don't enable add exercise button when in workout mode
    if (_mode == KLERoutineExercisesViewControllerModeWorkout) {
        
        addButton.enabled = NO;
    }
    else
    {
        addButton.enabled = YES;
    }
}

- (void)selectedRoutineID:(id)objectID
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    self.selectedRoutineID = objectID;
    NSLog(@"SELECTED ROUTINE ID %@", self.selectedRoutineID);
    
    [self configureFetch];
    [self performFetch];
    
    // get the selected routine in the current context
    KLERoutine *selectedRoutine = (KLERoutine *)[self.frc.managedObjectContext objectWithID:objectID];
    
    // custom title for navigation title
//    NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:selectedRoutine.routinename attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:13], NSUnderlineStyleAttributeName : @0, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    // custom title for navigation title
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
//    title.backgroundColor = [UIColor clearColor];
//    title.textColor = [UIColor blueColor];
//    title.numberOfLines = 0;
//    title.attributedText = attribString;
//    [title sizeToFit];
//    self.navigationItem.titleView = title;
    
    self.routineTextField.text = selectedRoutine.routinename;
    
    [self.tableHeaderView.dayButton setTitle:selectedRoutine.dayname forState:UIControlStateNormal];
    
    // hides routine view when routine selected
//    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
    
    
    /* for split view
     
    // pop off the exercise detail view controller when there's a new routine selection
    if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[KLERoutineExerciseDetailViewController class]]) {
        NSLog(@"EXERCISE DETAIL VC PRESENT");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    */
}

- (void)configureFetch
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSLog(@"object id from daily view %@", self.selectedRoutineID);
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    KLERoutine *selectedRoutine = (KLERoutine *)[cdh.context existingObjectWithID:self.selectedRoutineID error:nil];
//    KLERoutine *selectedRoutine = (KLERoutine *)[cdh.context objectWithID:self.selectedRoutineID];
    
    NSLog(@"configure fetch selected routine %@", selectedRoutine);
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLEExerciseGoal"];
    NSArray *fetchedObjects = [cdh.context executeFetchRequest:request error:nil];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY routine == %@", selectedRoutine];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"routine == %@", selectedRoutine];
    [request setPredicate:predicate];
    NSLog(@"configure fetch Objects %@", fetchedObjects);
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"exercise.exercisename" ascending:YES], nil];
//    NSLog(@"request object %@", request);
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"exercise.musclename" cacheName:nil];
    self.frc.delegate = self;
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

/* for additional button to display primary master when display mode button not present, refer to appcoda split view tutorial
 
- (void)showRoutineViewController
{
    NSLog(@"DISMISS VC IN REVC %@", [[[self.splitViewController viewControllers] lastObject] viewControllers]);
    
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;

}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create an instance of UITableViewCell, with default appearance
    KLERoutineExercisesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLERoutineExercisesViewCell" forIndexPath:indexPath];
    
    KLEExerciseGoal *exerciseGoal = [self.frc objectAtIndexPath:indexPath];
    KLEExercise *exercise = exerciseGoal.exercise;

    cell.exerciseNameLabel.text = exercise.exercisename;
    cell.setsLabel.text = [NSString stringWithFormat:@"%@", exerciseGoal.sets];
    cell.repsLabel.text = [NSString stringWithFormat:@"%@", exerciseGoal.reps];
    cell.weightLabel.text = [NSString stringWithFormat:@"%@", exerciseGoal.weight];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    KLEExerciseGoal *routineExercise = (KLEExerciseGoal *)[self.frc objectAtIndexPath:indexPath];
    
    if (self.mode == KLERoutineExercisesViewControllerModeWorkout) {
        NSLog(@"GOING TO WORKOUT MODE");
        KLEWorkoutExerciseViewController *wevc = [[KLEWorkoutExerciseViewController alloc] init];
        wevc.selectedRoutineExercise = routineExercise;
        [self.navigationController pushViewController:wevc animated:YES];
    }
    else
    {
        KLERoutineExerciseDetailViewController *redvc = [[KLERoutineExerciseDetailViewController alloc] init];
        redvc.selectedRoutineExercise = routineExercise;
        NSLog(@"ROUTINE EXERCISES VIEW CONTROLLER MODE %lu", self.mode);
        
        [self.navigationController pushViewController:redvc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return nil;
}

- (void)addNewExercise
{
    KLEExerciseListViewController *elvc = [[KLEExerciseListViewController alloc] initForNewExercise:YES];
    
    elvc.selectedRoutineID = self.selectedRoutineID;
    // pass the selected statStore to exercise list view controller
//    elvc.statStore = self.statStore;
//    elvc.frc = self.frc;
    
    // completion block that will reload the table
//    elvc.dismissBlock = ^{
//        NSLog(@"parent VC %@", [self.navigationController.viewControllers objectAtIndex:0]);
//        KLEDailyViewController *dvc = [self.navigationController.viewControllers objectAtIndex:0];
//        NSLog(@"current Action Row Paths %lu", [dvc.currentActionRowPaths count]);
//        if ([dvc.currentActionRowPaths count]) {
//            [dvc createActionRowPathsFromRoutineIndex:dvc.newRoutineIndex startIndex:dvc.newStartIndex atIndexPath:dvc.currentIndexPath];
//        }
//    };
    
//    [self.navigationController pushViewController:elvc animated:YES];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:elvc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        KLEExerciseGoal *deleteTarget = [self.frc objectAtIndexPath:indexPath];
        [self.frc.managedObjectContext deleteObject:deleteTarget];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"BEGAN EDITING");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"END EDITING");
    KLERoutine *selectedRoutine = (KLERoutine *)[self.frc.managedObjectContext existingObjectWithID:self.selectedRoutineID error:nil];
    
    selectedRoutine.routinename = self.tableHeaderView.renameRoutineTextField.text;
    self.tableHeaderView.renameRoutineTextField.placeholder = nil;
    
    
//    selectedRoutine.routinename = self.routineTextField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)selectionFromELVC:(KLEExerciseListViewController *)elvc thisSelection:(NSIndexPath *)selection
{
    NSLog(@"REVC delegate ELVCselection %lu", selection.row);

}

- (void)showActionSheet
{
    NSArray *days = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    [ActionSheetStringPicker showPickerWithTitle:@"Select a Day" rows:days initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        NSError *error = nil;
        KLERoutine *routine = (KLERoutine *)[self.frc.managedObjectContext existingObjectWithID:self.selectedRoutineID error:&error];
        routine.daynumber = [NSNumber numberWithInteger:selectedIndex];
        routine.dayname = [days objectAtIndex:selectedIndex];
        routine.inworkout = [NSNumber numberWithBool:YES];
        
        [self.tableHeaderView.dayButton setTitle:routine.dayname forState:UIControlStateNormal];
        
        NSLog(@"Header Day %@", self.tableHeaderView.dayButton.titleLabel.text);
        NSLog(@"Picker: %@", picker);
        NSLog(@"Selected index %lu", selectedIndex);
        NSLog(@"Selected value %@", selectedValue);
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
        NSLog(@"Cancelled");
        
    } origin:self.view];
}

/* for split view
 
- (void)handleDisplayModeChangeWithNotification:(NSNotification *)note
{
    // not used, for display mode button
    
    NSNumber *displayModeObject = [note object];
    NSUInteger displayMode = [displayModeObject integerValue];
    NSLog(@"DISPLAY MODE %lu", displayMode);
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    
    NSLog(@"frc managedObjectContext %@", self.frc);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLERoutineExercisesViewCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLERoutineExercisesViewCell"];
    
    // create KLETableHeaderView and set it as the table view header
    self.tableHeaderView = [KLETableHeaderView routineExercisesTableHeaderView];
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    [self.tableHeaderView.dayButton addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
    
    // set the delegate for textfield to this view controller
    self.tableHeaderView.renameRoutineTextField.delegate = self;
    
//    self.routineTextField.delegate = self;
    

    /* for split view, did the display mode change (all visible)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDisplayModeChangeWithNotification:) name:@"DisplayModeChangeNote" object:nil];
     */
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self createAddExerciseButton];
    
    KLERoutine *selectedRoutine = (KLERoutine *)[self.frc.managedObjectContext objectWithID:self.selectedRoutineID];
    
    [self.routineTextField setText:selectedRoutine.routinename];
    
    [self.tableHeaderView.dayButton setTitle:selectedRoutine.dayname forState:UIControlStateNormal];
    
}

@end
