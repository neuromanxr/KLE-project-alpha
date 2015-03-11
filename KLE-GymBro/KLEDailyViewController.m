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

#import "DateTools.h"
#import "NSIndexPathUtilities.h"
#import "KLEActionCell.h"
#import "KLEDailyViewCell.h"

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


@property (nonatomic, copy) NSArray *daysArray;
@property (nonatomic, copy) NSArray *datesArray;
    
//@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger indexInActionRowPaths;
@property (nonatomic, assign) NSUInteger rowCountBySection;
@property (nonatomic, assign) NSUInteger currentSet;

@property (nonatomic, strong) KLEContainerViewController *containerViewController;
@property (nonatomic, strong) NSString *todaysDate;
@property (nonatomic, copy) NSString *(^weeklyDates)(NSString *);

// daily view header
@property (strong, nonatomic) IBOutlet UIView *dailyHeaderView;
//@property (strong, nonatomic) IBOutlet UIView *dailyFooterView;

@property (weak, nonatomic) IBOutlet UILabel *headerDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerDateLabel;
//@property (weak, nonatomic) IBOutlet UIButton *footerAddButton;
//@property (strong, nonatomic) UIBarButtonItem *editButton;

// action rows
@property (nonatomic, strong) KLEActionCell *actionCell;
@property (nonatomic, strong) NSArray *actionRowPaths;
@property (nonatomic, strong) NSIndexPath *didSelectRowAtIndexPath;

@property (nonatomic, strong) NSArray *routineObjects;
//@property (nonatomic, strong) NSArray *exercisesInActionRows;

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

-(CGFloat)getLabelHeightForIndex:(NSInteger)index
{
    CGSize labelHeightSize = CGSizeMake(230, 100);
    
    return labelHeightSize.height;
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


// fix this
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 70;
//    
//}

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
    _rowCountBySection = 0;
    NSLog(@"actionRowPaths contents %@", self.actionRowPaths);
    if ([self.actionRowPaths count]) {
        actionRowsCount = [self.actionRowPaths count];
        while (actionRow = [enumerator nextObject]) {
            NSLog(@"actionRow row %lu and section %lu", actionRow.row, actionRow.section);
            if (actionRow.section == section) {
                _rowCountBySection = routinesCount + actionRowsCount;
            } else {
                _rowCountBySection = routinesCount;
            }
        }
    } else {
        _rowCountBySection = routinesCount;
        NSLog(@"rowCountBySection ELSE %lu", _rowCountBySection);
    }
    
    return _rowCountBySection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_daysArray count];
}

#pragma mark HEADER VIEW
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // load dailyHeaderView.xib
    [[NSBundle mainBundle] loadNibNamed:@"KLEDailyHeaderView"
                                  owner:self
                                options:nil];

    self.headerDayLabel.text = _daysArray[section];
    self.headerDateLabel.text = _datesArray[section];
    
    return _dailyHeaderView;
}

// need dynamic height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    float height = self.view.bounds.size.height / 7;
//    if (self.actionRowPaths) {
//        height = self.view.bounds.size.height / 7;
//    } else {
//        height = self.view.bounds.size.height / 7;
//    }
    return 30;
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

#pragma mark TABLEVIEW

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
        
    // case: when an action row is already expanded and you click a different action row
    } else if ([self.actionRowPaths count]) {
        
        // move action cell
        NSLog(@"current indexPath row %lu section %lu", indexPath.row, indexPath.section);
        
        pathsToDelete = self.actionRowPaths;
        
        NSIndexPath *newActionRowPath;
        NSIndexPath *actionRowPath = [self.actionRowPaths lastObject];
        
        // is the selected index before or after current action rows?
        BOOL before = [indexPath before:actionRowPath];
        
        NSUInteger routineIndex = actionRowPath.row;
        NSUInteger startIndexAtOne = newActionRowPath.row;
        NSLog(@"startIndexAtOne %lu routineIndex %lu", startIndexAtOne, routineIndex);
        
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
                newActionRowPath = indexPath.next;
                NSLog(@"new Action Row Path %lu : action Row Path %lu", newActionRowPath.row, actionRowPath.row);
                
            }
            
            routineIndex = actionRowPath.row;
            startIndexAtOne = newActionRowPath.row;
            NSLog(@"startIndexAtOne %lu", startIndexAtOne);
        
        // case: when the selected indexPath is after the action rows
        } else {
            
            // this indexPath is for exercises in the action rows
            NSIndexPath *adjustedIndexPath;
            
            // the row selected is after the action row plus the expanded rows
            
            /* when action row that is selected below the already expanded action row, the daily routine index has to be the routine that was selected (where the routine is in daily store) and the action row start index has to be the index after the routine index */
            
            // have to account for the expanded rows above, so subtract the count of actionRowPaths
            if ([[self.actionRowPaths firstObject] section] == indexPath.section) {
                
                NSLog(@"actionRowPaths section %lu matches indexPaths section %lu", [[self.actionRowPaths firstObject] section], indexPath.section);
                actionRowPath = [NSIndexPath indexPathForRow:(indexPath.row - [self.actionRowPaths count]) inSection:indexPath.section];
                newActionRowPath = [NSIndexPath indexPathForRow:(indexPath.next.row - [self.actionRowPaths count]) inSection:indexPath.section];
                adjustedIndexPath = [NSIndexPath indexPathForRow:(indexPath.row - [self.actionRowPaths count]) inSection:indexPath.section];
                self.didSelectRowAtIndexPath = adjustedIndexPath;
                
            } else {
                
                actionRowPath = indexPath;
                newActionRowPath = indexPath.next;
//                adjustedIndexPath = nil;
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
        
        NSArray *indexPathsForExercises = [self createActionRowPathsFromRoutineIndex:indexPath.row startIndex:startIndexAtOne atIndexPath:indexPath];

        pathsToAdd = indexPathsForExercises;
        self.actionRowPaths = indexPathsForExercises;
    }
    
    [self updateTableActionRowPathsToDelete:pathsToDelete pathsToAdd:pathsToAdd];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // case: test if there are actionRowPaths and match the indexPath with the actionRowPath and set the indexInActionRowPaths. actionRowPath starts after the normal cell
    if ([self.actionRowPaths count]) {
        
        // is the indexPath being shown in actionRowPaths? if so set the indexInActionRowPaths to be the action row that matches indexPath
        if ([self.actionRowPaths containsObject:indexPath]) {
            _indexInActionRowPaths = [self.actionRowPaths indexOfObject:indexPath];
        } else {
            _indexInActionRowPaths = -1;
        }
        
        NSLog(@"indexInActionRowPaths %ld", (long)_indexInActionRowPaths);
    } else {
        _indexInActionRowPaths = -1;
    }
    
    // case: action rows will be displayed for the indexPaths that equal to the indexPaths in actionRowPaths
    if ((_indexInActionRowPaths >= 0) && [self.actionRowPaths[_indexInActionRowPaths] isEqual:indexPath]) {
        NSLog(@"actionRowPaths %lu is equal to indexPath %lu", [self.actionRowPaths[_indexInActionRowPaths] row], indexPath.row);
        NSLog(@"indexInActionRowPaths in action %lu", _indexInActionRowPaths);

        // action row
        KLEActionCell *actionCell = [tableView dequeueReusableCellWithIdentifier:@"KLEActionCell" forIndexPath:indexPath];
        
        NSArray *routineObjects = [self fetchRoutinesWithIndexPath:indexPath];
        
        NSUInteger startIndexForExerises = _indexInActionRowPaths;
        
        // get the routine in the daily view from the selected index
        KLERoutine *routine = [routineObjects objectAtIndex:self.didSelectRowAtIndexPath.row];
        
        NSArray *exercises = [NSArray arrayWithArray:[routine.exercisegoal allObjects]];
        KLEExerciseGoal *routineExercise = [exercises objectAtIndex:startIndexForExerises];
        
        // set the values in the action cell
        // animate sets and reps text
        if ([routineExercise.sets integerValue] == 0) {
            actionCell.setsLabel.text = [NSString stringWithFormat:@"%@", routineExercise.sets];
        }
        else
        {
            CGFloat animationPeriod = 10;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                for (int i = 1; i <= [routineExercise.sets integerValue]; i++) {
                    usleep(animationPeriod / 100 * 1000000); // sleep in ms
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        actionCell.setsLabel.text = [NSString stringWithFormat:@"%d", i];
                    });
                }
            });
        }
        
        if ([routineExercise.reps integerValue] == 0) {
            actionCell.repsLabel.text = [NSString stringWithFormat:@"%@", routineExercise.reps];
        }
        else
        {
            CGFloat animationPeriod = 10;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                for (int i = 1; i <= [routineExercise.reps integerValue]; i++) {
                    usleep(animationPeriod / 100 * 1000000); // sleep in ms
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        actionCell.repsLabel.text = [NSString stringWithFormat:@"%d", i];
                    });
                }
            });
        }
        
        actionCell.exerciseNameLabel.text = routineExercise.exercise.exercisename;
        actionCell.weightLabel.text = [NSString stringWithFormat:@"%@", routineExercise.weight];
//        actionCell.repsLabel.text = [NSString stringWithFormat:@"%@", routineExercise.reps];
//        actionCell.setsLabel.text = [NSString stringWithFormat:@"%@", routineExercise.sets];

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
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.routineNameLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        cell.routineNameLabel.text = routine.routinename;
        
        // change cell selected color
        UIView *selectedColorView = [[UIView alloc] init];
        [selectedColorView setBackgroundColor:[UIColor orangeColor]];
        [cell setSelectedBackgroundView:selectedColorView];
        
        [cell.startWorkoutButton addTarget:self action:@selector(startWorkout:event:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *adjustedIndexPath = indexPath;
    
    if ([[self.tableView cellForRowAtIndexPath:indexPath.previous] isKindOfClass:[KLEActionCell class]]) {
        adjustedIndexPath = [NSIndexPath indexPathForRow:indexPath.row - [self.actionRowPaths count] inSection:indexPath.section];
        NSLog(@"ADJUSTED INDEX ROW %lu", adjustedIndexPath.row);
    }
    else
    {
        adjustedIndexPath = indexPath;
    }
    
    NSArray *routineObjects = [self fetchRoutinesWithIndexPath:adjustedIndexPath];
    KLERoutine *selectedRoutine = [routineObjects objectAtIndex:adjustedIndexPath.row];
    NSLog(@"selected routine %@", selectedRoutine);
    NSManagedObjectID *selectedRoutineID = selectedRoutine.objectID;
    
    KLERoutineExercisesViewController *revc = [KLERoutineExercisesViewController routineExercisesViewControllerWithMode:KLERoutineExercisesViewControllerModeWorkout];
    
    // pass the routine ID to routineExerciseViewController
    self.delegate = revc;
    [self.delegate selectedRoutineID:selectedRoutineID];
    
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

- (void)startWorkout:(id)sender event:(id)event
{
    // get a pointer to the button passed from sender
    UIButton *btn = (UIButton *)sender;
    
    NSNumber *dayNumber = @(btn.tag);
    NSLog(@"Add button tapped in section %@", dayNumber);
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    
    if (indexPath != nil) {
        
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

#pragma mark DATE METHODS

//- (void)startDate:(NSDate **)start andEndDate:(NSDate **)end ofWeekOn:(NSDate *)date
//{
//    NSDate *startDate = nil;
//    NSTimeInterval duration = 0;
//    BOOL b = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&startDate interval:&duration forDate:date];
//    if (!b) {
//        *start = nil;
//        *end = nil;
//        return;
//    }
//    NSTimeInterval interval = 24 * 60 * 60;
//    NSLog(@"DURATION %f", duration);
//    NSDate *endDate = [startDate dateByAddingTimeInterval:(duration - interval)];
//    NSLog(@"END DATE %@", endDate);
//    *start = startDate;
//    *end = endDate;
//}

//- (void)getDates
//{
//    NSDate *date = [NSDate date];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateStyle:NSDateFormatterShortStyle];
//    self.todaysDate = [dateFormat stringFromDate:date];
//    NSLog(@"TODAYS DATE %@", self.todaysDate);
//    
//    NSDate *thisStart = nil;
//    NSDate *thisEnd = nil;
//    [self startDate:&thisStart andEndDate:&thisEnd ofWeekOn:[NSDate date]];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterShortStyle];
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:thisStart];
//    NSString *dayName = stringFromWeekday((int)[components weekday]);
//    NSLog(@"STRING FROM WEEK DAY %@", dayName);
//    NSTimeInterval interval = 24 * 60 * 60;
//    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
//    for (int i = 0; i < 7; i++) {
//        NSDate *date = [thisStart dateByAddingTimeInterval:interval * i];
//        NSString *day = [formatter stringFromDate:date];
//        NSLog(@"Week Day %@", day);
//        [mutableArray addObject:day];
//    }
//    _datesArray = [NSArray arrayWithArray:mutableArray];
//    
//    // test block
//    void (^block)(NSString *) = ^(NSString *date) {
//        NSLog(@"BLOCK");
//    };
//    block(@"STRING");
//    
//    NSDate *lastWeekDate = [thisStart dateByAddingTimeInterval:-10];
//    NSDate *lastStart = nil;
//    NSDate *lastEnd = nil;
//    [self startDate:&lastStart andEndDate:&lastEnd ofWeekOn:lastWeekDate];
//    
//    NSDate *nextWeekDate = [thisEnd dateByAddingTimeInterval:10 + interval];
//    NSDate *nextStart = nil;
//    NSDate *nextEnd = nil;
//    [self startDate:&nextStart andEndDate:&nextEnd ofWeekOn:nextWeekDate];
//    
//    NSLog(@"START DAY %@ END DAY %@", thisStart, thisEnd);
//    NSLog(@"LAST WEEK DAY %@ END DAY %@", lastStart, lastEnd);
//    NSLog(@"NEXT WEEK DAY %@ END DAY %@", nextStart, nextEnd);
//    
//}

- (void)startDate:(NSDate **)start andEndDate:(NSDate **)end ofWeekOn:(NSDate *)date
{
    NSDate *startDate = nil;
    NSTimeInterval duration = 0;
    
    // is today's date in the week
    BOOL isDateInWeek = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&startDate interval:&duration forDate:date];
    
    if (!isDateInWeek) {
        *start = nil;
        *end = nil;
        return;
    }
    else
    {
        // seconds in a day
        NSTimeInterval interval = 24 * 60 * 60;
        NSLog(@"DURATION %f", duration);
        
        NSDate *endDate = [startDate dateByAddingTimeInterval:(duration - interval)];
        
        NSLog(@"END DATE %@", endDate);
        *start = startDate;
        *end = endDate;
    }
}

- (void)getWeekDates
{
    NSDate *todaysDate = [NSDate date];

    NSDate *todaysDateWithComponents = [NSDate dateWithYear:todaysDate.year month:todaysDate.month day:todaysDate.day hour:todaysDate.hour minute:todaysDate.minute second:todaysDate.second];
    
    NSString *todaysDateString = [todaysDateWithComponents formattedDateWithFormat:@"MMMM-dd-yy" timeZone:[NSTimeZone localTimeZone]];
    
    self.todaysDate = todaysDateString;
    
    NSDate *startWeekDate = nil;
    NSDate *endWeekDate = nil;
    [self startDate:&startWeekDate andEndDate:&endWeekDate ofWeekOn:todaysDateWithComponents];
    
    NSMutableArray *weekDatesArray = [NSMutableArray new];
    NSMutableArray *weekDayArray = [NSMutableArray new];
    
    for (int i = 0; i < 7; i++) {
        
        NSDate *dayDate = [startWeekDate dateByAddingDays:i];
        NSString *dateString = [dayDate formattedDateWithFormat:@"MMMM-dd-yy" timeZone:[NSTimeZone localTimeZone]];
        NSString *dayString = [dayDate formattedDateWithFormat:@"EEEE" timeZone:[NSTimeZone localTimeZone]];
        [weekDatesArray addObject:dateString];
        [weekDayArray addObject:dayString];
    }
    _datesArray = [NSArray arrayWithArray:weekDatesArray];
    _daysArray = [NSArray arrayWithArray:weekDayArray];
    
    NSLog(@"TODAYS DATE STRING %@", todaysDateString);
}

//- (void)makeDays
//{
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
//    // thread safe method
//    if (!_daysArray) {
//        static dispatch_once_t day;
//        dispatch_once(&day, ^{
//            _daysArray = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
//        });
//    }
//}

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
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.tableView indexPathsForVisibleRows]) {
        
        for (int i = 0; i < [_datesArray count]; i++) {
            
            NSLog(@"DAY MATCH %@ TODAY %@", [_datesArray objectAtIndex:i], self.todaysDate);
            if ([[_datesArray objectAtIndex:i] isEqualToString:self.todaysDate]) {
                
                NSLog(@"MATCH");
                if ([self.tableView numberOfRowsInSection:i] > 0) {
                    
                    NSLog(@"##NUMBER OF ROWS > 0 %lu", [self.tableView numberOfRowsInSection:i]);
                    if (![self.actionRowPaths count]) {
                        
                        if (i > 4) {
                            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i] animated:YES scrollPosition:UITableViewScrollPositionNone];
                            [self.tableView scrollToRowAtIndexPath:[self.actionRowPaths lastObject] atScrollPosition:UITableViewScrollPositionNone animated:YES];
                        }
                        else
                        {
                            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i] animated:YES scrollPosition:UITableViewScrollPositionTop];
                        }
                        
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
    
//    [self makeDays];
    
//    [self getDates];
    
    [self getWeekDates];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLEDailyViewCell" bundle:nil];
    
    UINib *actionNib = [UINib nibWithNibName:@"KLEActionCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLEDailyViewCell"];
    
    [self.tableView registerNib:actionNib forCellReuseIdentifier:@"KLEActionCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
    
    // no cell is expanded
//    _selectedIndex = -1;
    
    _indexInActionRowPaths = -1;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSLog(@"VIEW WILL DISAPPEAR");
    
    if ([self.tableView indexPathsForVisibleRows]) {
        
        for (int i = 0; i < [_datesArray count]; i++) {
            
            NSLog(@"DAY MATCH %@ TODAY %@", [_datesArray objectAtIndex:i], self.todaysDate);
            if ([[_datesArray objectAtIndex:i] isEqualToString:self.todaysDate]) {
                
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

//static inline NSString *stringFromWeekday(int weekday)
//{
//    static NSString *strings[] = {
//        @"Sunday",
//        @"Monday",
//        @"Tuesday",
//        @"Wednesday",
//        @"Thursday",
//        @"Friday",
//        @"Saturday",
//    };
//    
//    return strings[weekday - 1];
//}

@end
