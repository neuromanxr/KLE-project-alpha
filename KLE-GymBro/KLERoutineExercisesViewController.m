//
//  KLERoutineExercisesViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/15/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
#import "Pickers/ActionSheetStringPicker.h"
#import "KLEAppDelegate.h"
#import "KLERoutine.h"
#import "KLEExercise.h"
#import "KLEExerciseGoal.h"
#import "KLEDailyViewController.h"

#import "KLERoutineViewController.h"
#import "KLERoutineExercisesViewCell.h"
#import "KLEExerciseListViewController.h"
#import "KLERoutineExercisesViewController.h"

#import "KLERoutineExerciseDetailTableViewController.h"
#import "KLEWorkoutExerciseViewController.h"

@interface KLERoutineExercisesViewController () <UIViewControllerRestoration>

@property (nonatomic, copy) NSArray *routinesArray;

@property (nonatomic, strong) KLETableHeaderView *tableHeaderView;

@end

@implementation KLERoutineExercisesViewController
#define debug 1


- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    NSLog(@"CURRENT MODE %lu", _mode);
    NSLog(@"SELECTED ROUTINE FROM VC %@", [self usingSelectedRoutine]);
    
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];

    
    // notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:kExercisesChangedNote object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDayButtonTitle) name:kDayInRoutineChangedNote object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWeightUnit) name:kWeightUnitChangedNote object:nil];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLERoutineExercisesViewCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLERoutineExercisesViewCell"];
    
    // create KLETableHeaderView and set it as the table view header
    self.tableHeaderView = [KLETableHeaderView routineExercisesTableHeaderView];
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    // day button
    [self.tableHeaderView.dayButton addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
    
    // day button, animate scale
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAutoreverse animations:^{
        _tableHeaderView.dayButton.transform = CGAffineTransformMakeScale(1.25f, 1.25f);
    } completion:^(BOOL finished) {
        _tableHeaderView.dayButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }];
    
    
    KLERoutine *selectedRoutine = [self usingSelectedRoutine];
    
    [self.tableHeaderView.dayButton setTitle:selectedRoutine.dayname forState:UIControlStateNormal];
    
    NSLog(@"ROUTINE NAME %@", selectedRoutine.routinename);
    
    // custom title for navigation title
    NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:selectedRoutine.routinename attributes:@{ NSFontAttributeName : [KLEUtility getFontFromFontFamilyWithSize:18.0], NSUnderlineStyleAttributeName : @0, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    // custom title for navigation title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 0;
    title.attributedText = attribString;
    title.adjustsFontSizeToFitWidth = YES;
    title.minimumScaleFactor = 0.5;
    [title sizeToFit];
    [self.navigationItem setTitleView:title];
    
    [self createAddExerciseButton];
    
    
    /* for split view, did the display mode change (all visible)
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDisplayModeChangeWithNotification:) name:@"DisplayModeChangeNote" object:nil];
     */
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kExercisesChangedNote object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDayInRoutineChangedNote object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWeightUnitChangedNote object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (KLERoutine *)usingSelectedRoutine
{
    KLERoutine *routine;
    
    if (_selectedRoutineFromDaily != nil)
    {
        routine = _selectedRoutineFromDaily;
        
        NSLog(@"FROM DAILY VC %@", _selectedRoutineFromDaily);
    }
    
    else if (_selectedRoutineFromRoutines != nil)
    {
        routine = _selectedRoutineFromRoutines;
        
        NSLog(@"FROM ROUTINES VC %@", _selectedRoutineFromRoutines);
    }
    
    return routine;
}

+ (instancetype)routineExercisesViewControllerWithMode:(KLERoutineExercisesViewControllerMode)mode
{
    KLERoutineExercisesViewController *routineExercisesViewController = [KLERoutineExercisesViewController new];
    [routineExercisesViewController setMode:mode];
    
    return routineExercisesViewController;
}

- (void)setMode:(KLERoutineExercisesViewControllerMode)mode
{
    _mode = mode;
    
    NSLog(@"CURRENT MODE %ld", _mode);
    
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    // gets called twice if routine exercises from both daily and routines are presented. save both selected routines for respective view controllers
    NSLog(@"CURRENT MODE %lu", _mode);
    NSLog(@"ENCODE DAILY ROUTINE %@, ROUTINES ROUTINE %@", _selectedRoutineFromDaily, _selectedRoutineFromRoutines);
    NSLog(@"RESTORATION ID %@", self.restorationIdentifier);
    
    
    if (_selectedRoutineFromDaily != nil)
    {
        NSString *routineFromDaily = [[_selectedRoutineFromDaily.objectID URIRepresentation] absoluteString];
        [coder encodeObject:routineFromDaily forKey:kSelectedRoutineIDFromDailyKey];
        
        NSNumber *currentMode = [NSNumber numberWithInteger:_mode];
        [coder encodeObject:currentMode forKey:kCurrentModeFromRoutinesKey];
    }
    if (_selectedRoutineFromRoutines != nil)
    {
        NSString *routineFromRoutines = [[_selectedRoutineFromRoutines.objectID URIRepresentation] absoluteString];
        [coder encodeObject:routineFromRoutines forKey:kSelectedRoutineIDFromRoutinesKey];
        
        NSNumber *currentMode = [NSNumber numberWithInteger:_mode];
        [coder encodeObject:currentMode forKey:kCurrentModeFromRoutinesKey];
    }
    
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"REVC DECODE");
    
    [super decodeRestorableStateWithCoder:coder];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    NSLog(@"ID COMPONENTS %@", identifierComponents);
    KLERoutineExercisesViewController *routineExercisesViewController = [KLERoutineExercisesViewController new];
    
    NSLog(@"RESTORATION ID IN RESTORE %@", routineExercisesViewController.restorationIdentifier);
    
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    
    
    NSString *routineObjectURLFromDaily = [coder decodeObjectForKey:kSelectedRoutineIDFromDailyKey];
    NSString *routineObjectURLFromRoutines = [coder decodeObjectForKey:kSelectedRoutineIDFromRoutinesKey];
    NSLog(@"ROUTINE URL FROM DAILY %@, FROM ROUTINES %@", routineObjectURLFromDaily, routineObjectURLFromRoutines);
    if (routineObjectURLFromDaily != nil)
    {
        NSManagedObjectID *routineIDFromDaily = [[cdh.context persistentStoreCoordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:routineObjectURLFromDaily]];
        KLERoutine *routineFromDaily = (KLERoutine *)[cdh.context existingObjectWithID:routineIDFromDaily error:nil];
        routineExercisesViewController.selectedRoutineFromDaily = routineFromDaily;
        NSLog(@"ROUTINE ID FROM DAILY %@", routineFromDaily);
        
        KLERoutineExercisesViewControllerMode mode = [[coder decodeObjectForKey:kCurrentModeFromDailyKey] integerValue];
        [routineExercisesViewController setMode:mode];
    }
    if (routineObjectURLFromRoutines != nil)
    {
        NSManagedObjectID *routineIDFromRoutines = [[cdh.context persistentStoreCoordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:routineObjectURLFromRoutines]];
        KLERoutine *routineFromRoutines = (KLERoutine *)[cdh.context existingObjectWithID:routineIDFromRoutines error:nil];
        routineExercisesViewController.selectedRoutineFromRoutines = routineFromRoutines;
        NSLog(@"ROUTINE ID FROM ROUTINES %@", routineFromRoutines);
        
        KLERoutineExercisesViewControllerMode mode = [[coder decodeObjectForKey:kCurrentModeFromRoutinesKey] integerValue];
        [routineExercisesViewController setMode:mode];
    }
    
    
    return routineExercisesViewController;
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

- (void)reloadDayButtonTitle
{
    
    KLERoutine *selectedRoutine = [self usingSelectedRoutine];
    
    [self.tableHeaderView.dayButton setTitle:selectedRoutine.dayname forState:UIControlStateNormal];
}

- (void)updateWeightUnit
{
    [self.tableView reloadData];
}

/*
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
    
    
    
    self.routineTextField.text = selectedRoutine.routinename;
    
    [self.tableHeaderView.dayButton setTitle:selectedRoutine.dayname forState:UIControlStateNormal];
    
    // hides routine view when routine selected
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
 
    
    // for split view
    // pop off the exercise detail view controller when there's a new routine selection
    if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[KLERoutineExerciseDetailViewController class]]) {
        NSLog(@"EXERCISE DETAIL VC PRESENT");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
*/

- (void)configureFetch
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSLog(@"object id from daily view or routines view %@", [self usingSelectedRoutine]);
    
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];

    KLERoutine *selectedRoutine = [self usingSelectedRoutine];
    
    NSLog(@"configure fetch selected routine %@", selectedRoutine);
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLEExerciseGoal"];
    NSArray *fetchedObjects = [cdh.context executeFetchRequest:request error:nil];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY routine == %@", selectedRoutine];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"routine == %@", selectedRoutine];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"exercise.musclegroup" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSLog(@"configure fetch Objects %@", fetchedObjects);
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//    NSLog(@"request object %@", request);
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"exercise.musclegroup" cacheName:nil];
    self.frc.delegate = self;
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
    cell.weightLabel.text = [NSString stringWithFormat:@"%@ %@", exerciseGoal.weight, [KLEUtility weightUnitType]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *selectedColorView = [[UIView alloc] init];
    [selectedColorView setBackgroundColor:[UIColor kPrimaryColor]];
    [cell setSelectedBackgroundView:selectedColorView];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    KLERoutineExercisesViewCell *routineExerciseCell = (KLERoutineExercisesViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [routineExerciseCell.exerciseNameLabel setTextColor:[UIColor whiteColor]];
    [routineExerciseCell.setsLabel setTextColor:[UIColor whiteColor]];
    [routineExerciseCell.repsLabel setTextColor:[UIColor whiteColor]];
    [routineExerciseCell.weightLabel setTextColor:[UIColor whiteColor]];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLERoutineExercisesViewCell *routineExerciseCell = (KLERoutineExercisesViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [routineExerciseCell.exerciseNameLabel setTextColor:[UIColor kPrimaryColor]];
    [routineExerciseCell.setsLabel setTextColor:[UIColor kPrimaryColor]];
    [routineExerciseCell.repsLabel setTextColor:[UIColor kPrimaryColor]];
    [routineExerciseCell.weightLabel setTextColor:[UIColor kPrimaryColor]];
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
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"KLEStoryBoard" bundle:nil];
        KLERoutineExerciseDetailTableViewController *routineExerciseDetailTableViewController = [storyBoard instantiateViewControllerWithIdentifier:@"RoutineExerciseDetail"];
        routineExerciseDetailTableViewController.selectedRoutineExercise = [self.frc objectAtIndexPath:indexPath];
        
        [self.navigationController pushViewController:routineExerciseDetailTableViewController animated:YES];
        
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    [headerView.backgroundView setBackgroundColor:[UIColor kPrimaryColor]];
    [headerView.textLabel setTextColor:[UIColor whiteColor]];
    [headerView.textLabel setFont:[KLEUtility getFontFromFontFamilyWithSize:16.0]];
    
    if (_mode == KLERoutineExercisesViewControllerModeNormal) {
        [headerView.backgroundView setAlpha:0.7];
    }
}

- (void)addNewExercise
{
    KLEExerciseListViewController *elvc = [[KLEExerciseListViewController alloc] initForNewExercise:YES];
    
    elvc.selectedRoutineID = [[self usingSelectedRoutine] objectID];
    
    // completion block that will reload the table
//    elvc.dismissBlock = ^{
//        NSLog(@"parent VC %@", [self.navigationController.viewControllers objectAtIndex:0]);
//        KLEDailyViewController *dvc = [self.navigationController.viewControllers objectAtIndex:0];
//        NSLog(@"current Action Row Paths %lu", [dvc.currentActionRowPaths count]);
//        if ([dvc.currentActionRowPaths count]) {
//            [dvc createActionRowPathsFromRoutineIndex:dvc.newRoutineIndex startIndex:dvc.newStartIndex atIndexPath:dvc.currentIndexPath];
//        }
//    };
    
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kRoutineWasDeletedNote object:nil];
    }
}

//- (void)selectionFromELVC:(KLEExerciseListViewController *)elvc thisSelection:(NSIndexPath *)selection
//{
//    NSLog(@"REVC delegate ELVCselection %lu", selection.row);
//
//}

- (void)showActionSheet
{
    NSArray *days = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Day", nil];
    
    ActionSheetStringPicker *dayPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"Select Day" rows:days initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        KLERoutine *routine = [self usingSelectedRoutine];
        
        routine.daynumber = [NSNumber numberWithInteger:selectedIndex];
        routine.dayname = [days objectAtIndex:selectedIndex];
        routine.inworkout = [NSNumber numberWithBool:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDayInRoutineChangedNote object:nil];
        
//        [self.tableHeaderView.dayButton setTitle:routine.dayname forState:UIControlStateNormal];
        
        NSLog(@"Header Day %@", self.tableHeaderView.dayButton.titleLabel.text);
        NSLog(@"Picker: %@", picker);
        NSLog(@"Selected index %lu", selectedIndex);
        NSLog(@"Selected value %@", selectedValue);
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
        NSLog(@"Cancelled");
        
    } origin:self.view];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[KLEUtility getFontFromFontFamilyWithSize:16.0]];
    [doneButton setFrame:CGRectMake(0, 0, 50, 32)];
    [dayPicker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[KLEUtility getFontFromFontFamilyWithSize:16.0]];
    [cancelButton setFrame:CGRectMake(0, 0, 60, 32)];
    [dayPicker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    UIFont *font = [KLEUtility getFontFromFontFamilyWithSize:18.0];
    NSAttributedString *attribTitleString = [[NSAttributedString alloc] initWithString:@"Select Day" attributes:@{ NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor kPrimaryColor] }];
    
    [dayPicker setAttributedTitle:attribTitleString];
    [dayPicker showActionSheetPicker];
    
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



@end
