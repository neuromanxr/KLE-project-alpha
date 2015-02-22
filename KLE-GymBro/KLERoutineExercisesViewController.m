//
//  KLERoutineExercisesViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/15/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//
//#import "KLE_GymBro-Swift.h"
#import "Pickers/ActionSheetStringPicker.h"
#import "KLEAppDelegate.h"
#import "KLERoutine.h"
#import "KLEExercise.h"
#import "KLEExerciseGoal.h"
#import "KLEDailyViewController.h"

#import "KLEExercises.h"
#import "KLEStat.h"
#import "KLEStatStore.h"
#import "KLERoutinesStore.h"
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
    
//    self.tableHeaderView.totalWeight.text = @"TEST";
//    self.tableHeaderView.routineNameTextField.text = selectedRoutine.routinename;
    [self.tableHeaderView.dayButton setTitle:selectedRoutine.dayname forState:UIControlStateNormal];
//    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
    
    // pop off the exercise detail view controller when there's a new routine selection
    if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[KLERoutineExerciseDetailViewController class]]) {
        NSLog(@"EXERCISE DETAIL VC PRESENT");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode
{
    if (displayMode == UISplitViewControllerDisplayModeAllVisible) {
        NSLog(@"ALL VISIBLE");
    }
    NSLog(@"DISPLAY MODE CHANGED REVC");
}

//- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
//{
//    return YES;
//}

//- (UISplitViewControllerDisplayMode)targetDisplayModeForActionInSplitViewController:(UISplitViewController *)svc
//{
//    return UISplitViewControllerDisplayModePrimaryHidden;
//}

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
        
        // button to add exercises
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewExercise)];
        self.routineTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 26)];
        self.routineTextField.backgroundColor = [UIColor clearColor];
        self.routineTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.routineTextField.text = @"Routine Name";
        self.routineTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.routineTextField.translatesAutoresizingMaskIntoConstraints = YES;
        self.routineTextField.textAlignment = NSTextAlignmentCenter;
        UIBarButtonItem *textFieldBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.routineTextField];

        // button to edit routine
//        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:nil];
        
        // set bar button to toggle editing mode
//        editButton = self.editButtonItem;
        
        // set the button to be the right nav button of the nav item
        self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:addButton, textFieldBarButton, nil];
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create an instance of UITableViewCell, with default appearance
    KLERoutineExercisesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLERoutineExercisesViewCell" forIndexPath:indexPath];
    
    KLEExerciseGoal *exerciseGoal = [self.frc objectAtIndexPath:indexPath];
    KLEExercise *exercise = exerciseGoal.exercise;
//    NSLog(@"cell for row frc %@", exercise);
    cell.exerciseNameLabel.text = exercise.exercisename;
    cell.setsLabel.text = [NSString stringWithFormat:@"%@", exerciseGoal.sets];
    cell.weightLabel.text = [NSString stringWithFormat:@"%@", exerciseGoal.weight];
    
    // access the stat store using the selected index path row
    // then assign the exercise name property to the cell label
//    NSArray *statStoreArray = [[NSArray alloc] initWithArray:self.statStore.allStats];
//    KLEStat *stat = statStoreArray[indexPath.row];
//    cell.exerciseNameLabel.text = stat.exercise;
//    cell.setsLabel.text = [NSString stringWithFormat:@"%d", stat.sets];
//    cell.repsLabel.text = [NSString stringWithFormat:@"%d", stat.reps];
//    cell.weightLabel.text = [NSString stringWithFormat:@"%f", stat.weight];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    KLEExerciseListViewController *elvc = [[KLEExerciseListViewController alloc] initForNewExercise:NO];
    
    
//    KLEExerciseGoal *exerciseObject = (KLEExerciseGoal *)[self.frc objectAtIndexPath:indexPath];
//    NSLog(@"exercise %@", exerciseObject);
    // pass the selected exercise object to elvc
    
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
    
    // if the table view is asking to commit a delete command
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        KLEStatStore *statStore = self.statStore;
//        NSLog(@"revc statStore array %@", statStore);
//        NSArray *routineExercises = [statStore allStats];
//        KLEStat *exercise = routineExercises[indexPath.row];
//        [statStore removeStat:exercise];
    
        // also remove that row from the table view with animation
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
//    [self.statStore moveStatAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"BEGAN EDITING");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"END EDITING");
    KLERoutine *selectedRoutine = (KLERoutine *)[self.frc.managedObjectContext existingObjectWithID:self.selectedRoutineID error:nil];
//    selectedRoutine.routinename = self.tableHeaderView.routineNameTextField.text;
    selectedRoutine.routinename = self.routineTextField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

//- (UIView *)customHeaderView
//{
//    if (!_tableHeaderView) {
////        _tableHeaderView = [[KLETableHeaderView alloc] init];
//        [[NSBundle mainBundle] loadNibNamed:@"KLETableHeaderView"
//                                      owner:self
//                                    options:nil];
//        _tableHeaderView.nameTextField.placeholder = @"Routine name";
//    }
//    return _tableHeaderView;
//}

//- (void)showTableViewForHeader
//{
//    KLETableHeaderView *tableHeaderView = [KLETableHeaderView customView];
//    [self.tableView setTableHeaderView:tableHeaderView];
//    
//    [UIView animateWithDuration:.5f animations:^{
//        CGRect theFrame = CGRectMake(0, 0, 320, 128);
//        tableHeaderView.frame = theFrame;
//    }];
//}

//- (void)hideTableViewForHeader
//{
//    
//}

- (void)showActionSheet
{
    NSArray *days = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    [ActionSheetStringPicker showPickerWithTitle:@"Select a Day" rows:days initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        NSError *error = nil;
        KLERoutine *routine = (KLERoutine *)[self.frc.managedObjectContext existingObjectWithID:self.selectedRoutineID error:&error];
        routine.daynumber = [NSNumber numberWithInteger:selectedIndex];
        routine.dayname = [days objectAtIndex:selectedIndex];
        routine.inworkout = [NSNumber numberWithBool:YES];
        NSLog(@"Header Day %@", self.tableHeaderView.dayButton.titleLabel.text);
        NSLog(@"Picker: %@", picker);
        NSLog(@"Selected index %lu", selectedIndex);
        NSLog(@"Selected value %@", selectedValue);
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Cancelled");
    } origin:self.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self configureFetch];
//    [self performFetch];
    NSLog(@"frc managedObjectContext %@", self.frc);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLERoutineExercisesViewCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLERoutineExercisesViewCell"];
    
//    [self showTableViewForHeader];
    self.tableHeaderView = [KLETableHeaderView customView];
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    [self.tableHeaderView.dayButton addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
    
    // set the delegate for textfield to this view controller
//    self.tableHeaderView.routineNameTextField.delegate = self;
    self.routineTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

@end
