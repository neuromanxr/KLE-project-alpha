//
//  KLEDailyViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/6/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEWorkoutButton.h"
#import "KLEContainerViewController.h"
#import "KLEExercise.h"
#import "KLEExerciseGoal.h"
#import "KLEExerciseCompleted.h"
#import "KLERoutine.h"
#import "KLEAppDelegate.h"

#import "NSIndexPathUtilities.h"
#import "KLEActionCell.h"
#import "KLEDailyViewCell.h"
#import "KLEStat.h"
#import "KLEStatStore.h"
#import "KLEDailyStore.h"
#import "KLERoutinesStore.h"
#import "KLEDailyViewController.h"
#import "KLERoutineViewController.h"
#import "KLERoutineExercisesViewController.h"
#import <QuartzCore/QuartzCore.h>

#define COMMENT_LABEL_WIDTH 230
#define COMMENT_LABEL_MIN_HEIGHT 95
#define COMMENT_LABEL_PADDING 10

#define SK_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.0174532952f) // PI / 180
#define SK_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180

// can remove splitviewcontroller delegate
@interface KLEDailyViewController () <UISplitViewControllerDelegate>

{
    NSArray *daysArray;
    NSArray *datesArray;
    
    NSInteger selectedIndex;
    NSInteger indexInActionRowPaths;
    NSUInteger rowCountBySection;
    NSUInteger currentSet;
}

@property (nonatomic, strong) KLEContainerViewController *containerViewController;
@property (nonatomic, strong) NSString *todaysDate;
@property (nonatomic, copy) NSString *(^weeklyDates)(NSString *);

// daily view header
@property (strong, nonatomic) IBOutlet UIView *dailyHeaderView;
@property (strong, nonatomic) IBOutlet UIView *dailyFooterView;

@property (strong, nonatomic) IBOutlet UIButton *manageRoutines;
@property (weak, nonatomic) IBOutlet UILabel *headerDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *footerAddButton;
//@property (strong, nonatomic) UIBarButtonItem *editButton;

// action rows
@property (nonatomic, strong) KLEActionCell *actionCell;
@property (nonatomic, strong) NSArray *actionRowPaths;
@property (nonatomic, strong) NSIndexPath *didSelectRowAtIndexPath;

@property (nonatomic, strong) NSArray *routineObjects;
@property (nonatomic, strong) NSArray *exercisesInActionRows;

@end

@implementation KLEDailyViewController

#define debug 1

#pragma mark - DATA

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"GymBro";
        
        UITabBarItem *tbi = [self tabBarItem];
        UIImage *tabBarImage = [UIImage imageNamed:@"weightlift.png"];
        tbi.image = tabBarImage;
        // button to edit routine
//        self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:nil];
        
        // set bar button to toggle editing mode
//        self.editButton = self.editButtonItem;
        
        // set the button to be the right nav button of the nav item
//        navItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:self.editButton, nil];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)currentSet:(float)set
{
    NSLog(@"DAILY VIEW CURRENT SET %f", set);
    currentSet = set;
}

-(CGFloat)getLabelHeightForIndex:(NSInteger)index
{
    CGSize labelHeightSize = CGSizeMake(230, 100);
    
    return labelHeightSize.height;
}

//- (void)addWorkout
//{
//    KLERoutineViewController *rvc = [[KLERoutineViewController alloc] init];

//    CGRect frame = [UIScreen mainScreen].bounds;
//    UIView *view = [[UIView alloc] initWithFrame:frame];
//    view.backgroundColor = [UIColor redColor];
//    UIViewController *stats = [[UIViewController alloc] init];
//    stats.view = view;
    
//    UITabBarController *tbc = [[UITabBarController alloc] init];
//    tbc.viewControllers = @[rvc, stats];
    
//    [self.navigationController pushViewController:rvc animated:YES];
//}

- (void)addWorkout:(id)sender
{
    // get a pointer to the button passed from sender
    UIButton *btn = (UIButton *)sender;
    
    NSNumber *dayNumber = @(btn.tag);
    NSLog(@"Add button tapped in section %@", dayNumber);
    
//    KLERoutineViewController *rvc = [[KLERoutineViewController alloc] init];
    
    // pass the day number to routine view controller to keep track of which day section to add the routine
//    rvc.dayNumber = dayNumber;
//    NSLog(@"### Day number %@", dayNumber);
    
//    UISplitViewController *svc = [self splitviewController:dayNumber];
//    svc.delegate = self;
//    svc.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
    
    // can remove
    KLEContainerViewController *cvc = [[KLEContainerViewController alloc] init];
    [cvc setEmbeddedViewController:[self splitviewController:dayNumber]];
    [cvc setModalPresentationStyle:UIModalPresentationFormSheet];
    [cvc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:cvc animated:YES completion:nil];
//    [self.navigationController pushViewController:cvc animated:YES];
}

// can remove, app delegate is delegate
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return YES;
}

// can remove
- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode
{
    if (displayMode == UISplitViewControllerDisplayModeAllVisible) {
        NSLog(@"ALL VISIBLE");
    }
    NSLog(@"DISPLAY MODE CHANGED");
}

// can remove
- (UISplitViewController *)splitviewController:(NSNumber *)buttonNumber
{
    KLERoutineViewController *rvc = [[KLERoutineViewController alloc] init];
    rvc.dayNumber = buttonNumber;
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:rvc];
    KLERoutineExercisesViewController *revc = [[KLERoutineExercisesViewController alloc] init];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:revc];
    rvc.delegate = revc;
    
    UISplitViewController *svc = [[UISplitViewController alloc] init];
    revc.navigationItem.leftBarButtonItem = [svc displayModeButtonItem];
    svc.delegate = self;
    svc.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    svc.viewControllers = @[rootNav, detailNav];
//    [self setOverrideTraitCollection: [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular] forChildViewController:rootNav];
    
    return svc;
}

- (NSArray *)fetchRoutinesWithIndexPath:(NSIndexPath *)indexPath
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLERoutine"];
    // fetch the routines with daynumbers that match the section and bool value is set to yes
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inworkout == %@ AND daynumber == %@", @(YES), @(indexPath.section)];
    [request setPredicate:predicate];
//    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"routinename" ascending:YES], nil];
    NSArray *requestObjects = [cdh.context executeFetchRequest:request error:nil];
    
    NSLog(@"routine objects %@", self.routineObjects);
    
    return requestObjects;
}

- (NSArray *)createActionRowPathsFromRoutineIndex:(NSUInteger)routineIndex startIndex:(NSUInteger)startIndex atIndexPath:(NSIndexPath *)indexPath
{
    NSArray *routineObjects = [self fetchRoutinesWithIndexPath:indexPath];
    KLERoutine *routine = [routineObjects objectAtIndex:routineIndex];
    NSArray *exercises = [NSArray arrayWithArray:[routine.exercisegoal allObjects]];
    
    // create and add the exercise index paths for every exercise in the routine to array
    NSMutableArray *indexPathsForExercises = [[NSMutableArray alloc] init];
    NSUInteger index = 0;
    if ([exercises count]) {
        for (KLEExerciseGoal *exercise in exercises) {
            // index path has to start after the normal cell
            NSLog(@"exercises in routine %@ in section %lu", exercise.exercise.exercisename, indexPath.section);
            NSIndexPath *exerciseIndexPath = [NSIndexPath indexPathForRow:startIndex inSection:indexPath.section];
            [indexPathsForExercises addObject:exerciseIndexPath];
            startIndex++;
            NSLog(@"IndexPathsForExercises row %lu and section %lu", [[indexPathsForExercises objectAtIndex:index] row], [[indexPathsForExercises objectAtIndex:index] section]);
            index++;
        }
    } else {
        NSLog(@"There's no exercises in this routine");
//        self.editButton.enabled = YES;
    }
    
    return indexPathsForExercises;
}

- (void)updateTableActionRowPathsToDelete:(NSArray *)pathsToDelete pathsToAdd:(NSArray *)pathsToAdd
{
    // animate the deletions and insertions
    [self.tableView beginUpdates];
    NSLog(@"paths to delete count %lu", pathsToDelete.count);
    if (pathsToDelete.count) {
        NSLog(@"paths to delete");
        [self.tableView deleteRowsAtIndexPaths:pathsToDelete withRowAnimation:UITableViewRowAnimationNone];
    }
    NSLog(@"paths to add count %lu", pathsToAdd.count);
    if (pathsToAdd.count) {
        NSLog(@"paths to add row %lu in section %lu", [[pathsToAdd objectAtIndex:0] row], [[pathsToAdd objectAtIndex:0] section]);
        [self.tableView insertRowsAtIndexPaths:pathsToAdd withRowAnimation:UITableViewRowAnimationNone];
    }
    [self.tableView endUpdates];
}

- (void)finishWorkout:(id)sender
{
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    
    KLEExerciseGoal *exerciseGoal = [self.exercisesInActionRows objectAtIndex:[sender tag]];
    
    KLEExerciseCompleted *exerciseCompleted = [NSEntityDescription insertNewObjectForEntityForName:@"KLEExerciseCompleted" inManagedObjectContext:cdh.context];
    exerciseCompleted.exercisenamecompleted = exerciseGoal.exercise.exercisename;
    
    NSLog(@"FINISH WORKOUT CURRENT SET %lu", currentSet);
    NSLog(@"FINISHED WORKOUT %@", sender);
    NSLog(@"FINISH TAG %lu", [sender tag]);
    
    NSLog(@"EXERCISE IN ARRAY %@", exerciseGoal.exercise.exercisename);
    currentSet = 0;
}
// fix this
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if this is the selected index we need to return the height of the cell
    // in relation to the label height otherwise just return the minimum height with padding
//    if (selectedIndex == indexPath.row) {
//        return [self getLabelHeightForIndex:indexPath.row] + COMMENT_LABEL_PADDING * 2;
//    } else {
//        return COMMENT_LABEL_MIN_HEIGHT + COMMENT_LABEL_PADDING * 2;
//    }

    if (selectedIndex == indexPath.row) {
        return 30;
    } else {
        return 115;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float currentOffset = scrollView.contentOffset.y;
    float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if ((maximumOffset - currentOffset) <= 40) {
        NSLog(@"##SCROLLING TO END");
    }
}

#pragma mark - DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *requestRoutine = [NSFetchRequest fetchRequestWithEntityName:@"KLERoutine"];
    
    // have to get the routines that were added to the day instance and the routines with daynumbers that match the section
    NSPredicate *predicateRoutine = [NSPredicate predicateWithFormat:@"inworkout == %@ AND daynumber == %@", @(YES), @(section)];
    [requestRoutine setPredicate:predicateRoutine];
    // get the row count for the routines in daily using countForFetchRequest
    NSUInteger routinesCount = [cdh.context countForFetchRequest:requestRoutine error:nil];
    NSLog(@"###routines count %lu", routinesCount);
    
    // have to account for the extra action row plus the routines in each section
    NSUInteger actionRowsCount = 0;
    NSEnumerator *enumerator = [self.actionRowPaths objectEnumerator];
    NSIndexPath *actionRow;
    rowCountBySection = 0;
    NSLog(@"actionRowPaths contents %@", self.actionRowPaths);
    if ([self.actionRowPaths count]) {
        actionRowsCount = [self.actionRowPaths count];
        while (actionRow = [enumerator nextObject]) {
            NSLog(@"actionRow row %lu and section %lu", actionRow.row, actionRow.section);
            if (actionRow.section == section) {
                rowCountBySection = routinesCount + actionRowsCount;
            } else {
                rowCountBySection = routinesCount;
            }
        }
    } else {
        rowCountBySection = routinesCount;
        NSLog(@"rowCountBySection ELSE %lu", rowCountBySection);
    }
    
    return rowCountBySection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [daysArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // load dailyHeaderView.xib
    [[NSBundle mainBundle] loadNibNamed:@"KLEDailyHeaderView"
                                  owner:self
                                options:nil];
    _dailyHeaderView.backgroundColor = [UIColor grayColor];
    self.headerDayLabel.text = daysArray[section];
    self.headerDateLabel.text = datesArray[section];
    self.manageRoutines.tag = section;
    [self.manageRoutines addTarget:self action:@selector(addWorkout:) forControlEvents:UIControlEventTouchUpInside];
    
    return _dailyHeaderView;
}

//- (void)showFooterView:(id)sender
//{
//    // get a pointer to the button passed from sender
//    UIButton *btn = (UIButton *)sender;
//
//    NSLog(@"Add button tapped in section %lu", btn.tag);
//    
//    CGRect newRect = CGRectMake(0, _dailyFooterView.frame.origin.y, self.view.bounds.size.width, 30.0);
//    [UIView animateKeyframesWithDuration:2.0 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
//        _dailyFooterView.frame = newRect;
//        NSLog(@"daily footer view %@", _dailyFooterView);
//    } completion:nil];
//}

// dynamic height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = self.view.bounds.size.height / 7;
    if (self.actionRowPaths) {
        height = self.view.bounds.size.height / 7;
    } else {
        height = self.view.bounds.size.height / 7;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // load dailyFooterView.xib
    [[NSBundle mainBundle] loadNibNamed:@"KLEDailyFooterView"
                                  owner:self
                                options:nil];
    _dailyFooterView.backgroundColor = [UIColor lightGrayColor];
    
    // set the add button tag to be the section number
    self.footerAddButton.tag = section;
    
    [self.footerAddButton addTarget:self action:@selector(addWorkout:) forControlEvents:UIControlEventTouchUpInside];
    
    return _dailyFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we only don't want to allow selection on any expanded cells
    if ([self.actionRowPaths containsObject:indexPath]) {
        return nil;
    }
    return indexPath;
}

- (void)deselect
{
    NSArray *paths = [self.tableView indexPathsForSelectedRows];
    if (!paths.count) {
        return;
    }
    
    NSIndexPath *path = paths[0];
    [self.tableView deselectRowAtIndexPath:path animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([self.workoutButtonDelegate isWorkoutInProgress]) {
//        NSLog(@"ACTION ROWS LOCKED");
//        return;
//    }
    
    NSLog(@"didSelectRowAtIndexPath row %lu and section %lu", indexPath.row, indexPath.section);
    
    NSArray *pathsToAdd;
    NSArray *pathsToDelete;
    
    NSIndexPath *actionRowPathPrevious;
    if ([self.actionRowPaths count]) {
        actionRowPathPrevious = [self.actionRowPaths objectAtIndex:0];
    }
    NSLog(@"actionRowPath previous row %lu and section %lu", actionRowPathPrevious.row, actionRowPathPrevious.section);
    
    if ([actionRowPathPrevious.previous isEqual:indexPath]) {
        
        // hide action cell
        pathsToDelete = self.actionRowPaths;
        self.actionRowPaths = nil;
        [self deselect];
//        self.editButton.enabled = YES;
        
    // case: when an action row is already expanded and you click a different action row
    } else if ([self.actionRowPaths count]) {
        
        // move action cell
        NSLog(@"current indexPath row %lu section %lu", indexPath.row, indexPath.section);
        pathsToDelete = self.actionRowPaths;
        
        NSIndexPath *newActionRowPath;
        NSIndexPath *actionRowPath = [self.actionRowPaths lastObject];
        BOOL before = [indexPath before:actionRowPath];
        
        NSUInteger routineIndex = actionRowPath.row;
        NSUInteger startIndexAtOne = newActionRowPath.row;
        NSLog(@"startIndexAtOne %lu", startIndexAtOne);
        
        // case: when the selected indexPath is before the action rows
        if (before) {
            self.didSelectRowAtIndexPath = indexPath;
            // case: when the selected indexPath is in the same section
            if ([[self.actionRowPaths firstObject] section] == indexPath.section) {
                NSLog(@"actionRowPaths section %lu matches indexPaths section %lu", [[self.actionRowPaths firstObject] section], indexPath.section);
                actionRowPath = indexPath;
                newActionRowPath = indexPath.next;
            // case: when the selected indexPath is not in the same section
            } else {
                actionRowPath = indexPath;
                newActionRowPath = indexPath;
            }
            
            routineIndex = actionRowPath.row;
            startIndexAtOne = newActionRowPath.row;
            NSLog(@"startIndexAtOne %lu", startIndexAtOne);
        
        // case: when the selected indexPath is after the action rows
        } else {
            // this indexPath is for exercises in the action rows
            NSIndexPath *adjustedIndexPath;
            // the row selected is after the action row plus the expanded rows
            // when action row that is selected below the already expanded action row, the daily routine index has to be the routine that was selected (where the routine is in daily store) and the action row start index has to be the index after the routine index
            // have to account for the expanded rows above, so subtract the count of actionRowPaths
            if ([[self.actionRowPaths firstObject] section] == indexPath.section) {
                NSLog(@"actionRowPaths section %lu matches indexPaths section %lu", [[self.actionRowPaths firstObject] section], indexPath.section);
                actionRowPath = [NSIndexPath indexPathForRow:(indexPath.row - [self.actionRowPaths count]) inSection:indexPath.section];
                newActionRowPath = [NSIndexPath indexPathForRow:(indexPath.next.row - [self.actionRowPaths count]) inSection:indexPath.section];
                adjustedIndexPath = [NSIndexPath indexPathForRow:(indexPath.row - [self.actionRowPaths count]) inSection:indexPath.section];
                self.didSelectRowAtIndexPath = adjustedIndexPath;
            } else {
                actionRowPath = indexPath;
                newActionRowPath = indexPath;
                adjustedIndexPath = indexPath;
                self.didSelectRowAtIndexPath = indexPath;
            }
            
            routineIndex = actionRowPath.row;
            startIndexAtOne = newActionRowPath.row;
        }
        
        NSArray *indexPathsForExercises = [self createActionRowPathsFromRoutineIndex:routineIndex startIndex:startIndexAtOne atIndexPath:indexPath];
        
        pathsToAdd = indexPathsForExercises;
        self.actionRowPaths = indexPathsForExercises;
        
    } else {
        // case: action row tapped
        self.didSelectRowAtIndexPath = indexPath;

        NSUInteger startIndexAtOne = indexPath.next.row;
        NSLog(@"startIndexAtOne %lu", startIndexAtOne);
        
        // disable edit button when action row appears
//        self.editButton.enabled = NO;
        
        NSArray *indexPathsForExercises = [self createActionRowPathsFromRoutineIndex:indexPath.row startIndex:startIndexAtOne atIndexPath:indexPath];

        pathsToAdd = indexPathsForExercises;
        self.actionRowPaths = indexPathsForExercises;
    }
    
    // needs work
    if ([self.actionRowPaths count]) {
        [self.tabBarController.tabBar setHidden:YES];
    } else {
        [self.tabBarController.tabBar setHidden:NO];
    }
    
    [self updateTableActionRowPathsToDelete:pathsToDelete pathsToAdd:pathsToAdd];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // case: test if there are actionRowPaths and match the indexPath with the actionRowPath and set the indexInActionRowPaths. actionRowPath starts after the normal cell
    if ([self.actionRowPaths count]) {
        // is the indexPath being shown in actionRowPaths? if so set the indexInActionRowPaths to be the action row that matches indexPath
        if ([self.actionRowPaths containsObject:indexPath]) {
            indexInActionRowPaths = [self.actionRowPaths indexOfObject:indexPath];
        } else {
            indexInActionRowPaths = -1;
        }
        
        NSLog(@"indexInActionRowPaths %ld", (long)indexInActionRowPaths);
    } else {
        indexInActionRowPaths = -1;
    }
    // case: action rows will be displayed for the indexPaths that equal to the indexPaths in actionRowPaths
    if ((indexInActionRowPaths >= 0) && [self.actionRowPaths[indexInActionRowPaths] isEqual:indexPath]) {
        NSLog(@"actionRowPaths %lu is equal to indexPath %lu", [self.actionRowPaths[indexInActionRowPaths] row], indexPath.row);
        NSLog(@"indexInActionRowPaths in action %lu", indexInActionRowPaths);

        // action row
        KLEActionCell *actionCell = [tableView dequeueReusableCellWithIdentifier:@"KLEActionCell" forIndexPath:indexPath];
        
        NSArray *routineObjects = [self fetchRoutinesWithIndexPath:indexPath];
        
        NSUInteger startIndexForExerises = indexInActionRowPaths;
        
        // get the routine in the daily view from the selected index
        KLERoutine *routine = [routineObjects objectAtIndex:self.didSelectRowAtIndexPath.row];
        
        NSArray *exercises = [NSArray arrayWithArray:[routine.exercisegoal allObjects]];
        KLEExerciseGoal *routineExercise = [exercises objectAtIndex:startIndexForExerises];
        
        // set the values in the action cell
        NSNumber *setsNumber = routineExercise.sets;
        NSString *setsTitle = [NSString stringWithFormat:@"%@", setsNumber];
        NSNumber *repsNumber = routineExercise.reps;
        NSString *repsTitle = [NSString stringWithFormat:@"%@", repsNumber];
        
        actionCell.finishWorkoutButton.tag = startIndexForExerises;
        NSLog(@"ACTION CELL TAG %lu", actionCell.workoutButton.tag);
        NSLog(@"ROUTINE NAME FROM EXERCISE %@", routineExercise.routine.routinename);
        actionCell.exerciseNameLabel.text = routineExercise.exercise.exercisename;
        actionCell.weightLabel.text = [NSString stringWithFormat:@"%@", routineExercise.weight];
        actionCell.repsLabel.text = [NSString stringWithFormat:@"%@", routineExercise.reps];
        
        // set delegates for workout button
        self.workoutButtonDelegate = actionCell.workoutButton;
        actionCell.workoutButton.delegate = self;
        
        [self.workoutButtonDelegate resetAngle:0.0];
        actionCell.workoutButton.setsForAngle = routineExercise.sets;
        [actionCell.workoutButton setTitle:setsTitle forState:UIControlStateNormal];
        [actionCell.repsWorkoutButton setTitle:repsTitle forState:UIControlStateNormal];
        
        [actionCell.finishWorkoutButton addTarget:self action:@selector(finishWorkout:) forControlEvents:UIControlEventTouchUpInside];
        self.exercisesInActionRows = exercises;

        return actionCell;
        
    } else {
        // normal cell
        KLEDailyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLEDailyViewCell" forIndexPath:indexPath];
        
        // when action row already present and the view is loaded again
        // adjust the row index accessed by day routines when cell comes into view, account for the action row paths count to make sure the day routines is accessed with the correct index
        NSUInteger adjustedRow = indexPath.row;
        if ([self.actionRowPaths count] && [[self.actionRowPaths lastObject] row] < indexPath.row) {
            adjustedRow -= [self.actionRowPaths count];
            NSLog(@"adjusted row decrement %lu", adjustedRow);
        }

        // access the routine using indexPath.row in request array. when new row inserted from action row, it is trying to access a index that isn't there. have to use adjusted row.
        NSArray *routineObjects = [self fetchRoutinesWithIndexPath:indexPath];
        NSLog(@"###cell for row objects %@ object count %lu", routineObjects, [routineObjects count]);
        KLERoutine *routine = [routineObjects objectAtIndex:adjustedRow];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.routineNameLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        cell.routineNameLabel.text = routine.routinename;
        
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *adjustedIndexPath = indexPath;
    if ([[self.actionRowPaths objectAtIndex:indexPath.previous.row] isKindOfClass:[KLEExerciseGoal class]]) {
        adjustedIndexPath = [NSIndexPath indexPathForRow:indexPath.row + [self.actionRowPaths count] inSection:indexPath.section];
    }
    
    NSArray *routineObjects = [self fetchRoutinesWithIndexPath:indexPath];
    KLERoutine *selectedRoutine = [routineObjects objectAtIndex:indexPath.row];
    NSLog(@"selected routine %@", selectedRoutine);
    NSManagedObjectID *selectedRoutineID = selectedRoutine.objectID;
    
    KLERoutineExercisesViewController *revc = [KLERoutineExercisesViewController routineExercisesViewControllerWithMode:KLERoutineExercisesViewControllerModeWorkout];
    
    // pass the routine ID to routineExerciseViewController
    self.delegate = revc;
    [self.delegate selectedRoutineID:selectedRoutineID];
    
    // pass selected statStore from routine view controller to routine exercise view controller
//    revc.selectedRoutineID = selectedRoutineID;
//    NSLog(@"selected routine ID %@", revc.selectedRoutineID);
    
    [self.navigationController pushViewController:revc animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // disable swipe to delete when action rows are present
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleDelete;
    } else if (![self.actionRowPaths count]) {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *routineObjects = [self fetchRoutinesWithIndexPath:indexPath];
        KLERoutine *deleteTarget = [routineObjects objectAtIndex:indexPath.row];
        deleteTarget.inworkout = [NSNumber numberWithBool:NO];
        deleteTarget.dayname = @"Day";
        deleteTarget.daynumber = nil;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        [cdh.context refreshObject:deleteTarget mergeChanges:YES];
        
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    KLEDailyStore *dailyStore = [KLEDailyStore sharedStore];
    NSString *fromKey = [NSString stringWithFormat:@"%lu", sourceIndexPath.section];
    NSString *toKey = [NSString stringWithFormat:@"%lu", destinationIndexPath.section];
    
    NSLog(@"moving row in section %@ to section %@", fromKey, toKey);
    
    [dailyStore moveStatStoreAtIndex:sourceIndexPath.row atKey:fromKey toIndex:destinationIndexPath.row toKey:toKey];
}

- (void)startDate:(NSDate **)start andEndDate:(NSDate **)end ofWeekOn:(NSDate *)date
{
    NSDate *startDate = nil;
    NSTimeInterval duration = 0;
    BOOL b = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&startDate interval:&duration forDate:date];
    if (!b) {
        *start = nil;
        *end = nil;
        return;
    }
    NSTimeInterval interval = 24 * 60 * 60;
    NSLog(@"DURATION %f", duration);
    NSDate *endDate = [startDate dateByAddingTimeInterval:(duration - interval)];
    NSLog(@"END DATE %@", endDate);
    *start = startDate;
    *end = endDate;
}

- (void)getDates
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    self.todaysDate = [dateFormat stringFromDate:date];
    NSLog(@"TODAYS DATE %@", self.todaysDate);
    
    NSDate *thisStart = nil;
    NSDate *thisEnd = nil;
    [self startDate:&thisStart andEndDate:&thisEnd ofWeekOn:[NSDate date]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:thisStart];
    NSString *dayName = stringFromWeekday((int)[components weekday]);
    NSLog(@"STRING FROM WEEK DAY %@", dayName);
    NSTimeInterval interval = 24 * 60 * 60;
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++) {
        NSDate *date = [thisStart dateByAddingTimeInterval:interval * i];
        NSString *day = [formatter stringFromDate:date];
        NSLog(@"Week Day %@", day);
        [mutableArray addObject:day];
    }
    datesArray = [NSArray arrayWithArray:mutableArray];
    
    // test block
    void (^block)(NSString *) = ^(NSString *date) {
        NSLog(@"BLOCK");
    };
    block(@"STRING");
    
    NSDate *lastWeekDate = [thisStart dateByAddingTimeInterval:-10];
    NSDate *lastStart = nil;
    NSDate *lastEnd = nil;
    [self startDate:&lastStart andEndDate:&lastEnd ofWeekOn:lastWeekDate];
    
    NSDate *nextWeekDate = [thisEnd dateByAddingTimeInterval:10 + interval];
    NSDate *nextStart = nil;
    NSDate *nextEnd = nil;
    [self startDate:&nextStart andEndDate:&nextEnd ofWeekOn:nextWeekDate];
    
    NSLog(@"START DAY %@ END DAY %@", thisStart, thisEnd);
    NSLog(@"LAST WEEK DAY %@ END DAY %@", lastStart, lastEnd);
    NSLog(@"NEXT WEEK DAY %@ END DAY %@", nextStart, nextEnd);
    
}

- (void)makeDays
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // thread safe method
    if (!daysArray) {
        static dispatch_once_t day;
        dispatch_once(&day, ^{
            daysArray = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
        });
    }
}

- (void)removeActionRowPathsFromView
{
    if ([self.tableView indexPathForSelectedRow]) {
        NSArray *pathsToDelete = self.actionRowPaths;
        self.actionRowPaths = nil;
        [self deselect];
        
        // animate the deletions and insertions
        [self.tableView beginUpdates];
        NSLog(@"paths to delete count %lu", pathsToDelete.count);
        if (pathsToDelete.count) {
            [self.tableView deleteRowsAtIndexPaths:pathsToDelete withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.tableView endUpdates];
        
//        self.editButton.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.tableView indexPathsForVisibleRows]) {
        for (int i = 0; i < [datesArray count]; i++) {
            NSLog(@"DAY MATCH %@ TODAY %@", [datesArray objectAtIndex:i], self.todaysDate);
            if ([[datesArray objectAtIndex:i] isEqualToString:self.todaysDate]) {
                NSLog(@"MATCH");
                if ([self.tableView numberOfRowsInSection:i] > 0) {
                    NSLog(@"##NUMBER OF ROWS > 0 %lu", [self.tableView numberOfRowsInSection:i]);
                    if (![self.actionRowPaths count]) {
                        [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
                    } else {
                        return;
                    }
                }
            }
        }
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeDays];
    
    [self getDates];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLEDailyViewCell" bundle:nil];
    
    UINib *actionNib = [UINib nibWithNibName:@"KLEActionCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLEDailyViewCell"];
    
    [self.tableView registerNib:actionNib forCellReuseIdentifier:@"KLEActionCell"];
    
    // no cell is expanded
    selectedIndex = -1;
    
    indexInActionRowPaths = -1;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSLog(@"VIEW WILL DISAPPEAR");
    
    if ([self.tableView indexPathsForVisibleRows]) {
        for (int i = 0; i < [datesArray count]; i++) {
            NSLog(@"DAY MATCH %@ TODAY %@", [datesArray objectAtIndex:i], self.todaysDate);
            if ([[datesArray objectAtIndex:i] isEqualToString:self.todaysDate]) {
                NSLog(@"MATCH");
                if ([self.tableView numberOfRowsInSection:i] > 0) {
                    NSLog(@"##NUMBER OF ROWS > 0 %lu", [self.tableView numberOfRowsInSection:i]);
                    if ([self.actionRowPaths count]) {
                        [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
                    } else {
                        return;
                    }
                }
            }
        }
    }
    
    [self removeActionRowPathsFromView];
}

static inline NSString *stringFromWeekday(int weekday)
{
    static NSString *strings[] = {
        @"Sunday",
        @"Monday",
        @"Tuesday",
        @"Wednesday",
        @"Thursday",
        @"Friday",
        @"Saturday",
    };
    
    return strings[weekday - 1];
}

@end
