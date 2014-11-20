//
//  KLEDailyViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/6/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//
#import "KLEDay.h"
#import "KLERoutines.h"
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

@interface KLEDailyViewController ()

{
    NSArray *daysArray;
    
    NSInteger selectedIndex;
    NSInteger indexInActionRowPaths;
    NSUInteger rowCountBySection;
}

// daily view header
@property (strong, nonatomic) IBOutlet UIView *dailyHeaderView;
@property (strong, nonatomic) IBOutlet UIView *dailyFooterView;

@property (strong, nonatomic) IBOutlet UIButton *manageRoutines;
@property (weak, nonatomic) IBOutlet UILabel *headerDayLabel;
@property (weak, nonatomic) IBOutlet UIButton *footerAddButton;
@property (strong, nonatomic) UIBarButtonItem *editButton;

// action rows
@property (nonatomic, strong) NSArray *actionRowPaths;
@property (nonatomic, strong) NSIndexPath *didSelectRowAtIndexPath;

@property (nonatomic, strong) NSArray *routineObjects;
@property (nonatomic, strong) NSManagedObjectID *dayID;
@property (nonatomic, strong) NSManagedObjectID *routinesID;

@end

@implementation KLEDailyViewController

#define debug 1

#pragma mark - DATA
- (void)performFetch
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLERoutine"];
//    KLERoutines *routines = (KLERoutines *)[cdh.context executeFetchRequest:request error:nil];
//    KLERoutines *routines = (KLERoutines *)[cdh.context existingObjectWithID:self.routinesID error:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day != ''"];
    [request setPredicate:predicate];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"routinename" ascending:YES], nil];
    self.routineObjects = [cdh.context executeFetchRequest:request error:nil];
    
    NSLog(@"routine objects %@", self.routineObjects);
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Daily";
        
        // button to edit routine
        self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:nil];
        
        // set bar button to toggle editing mode
        self.editButton = self.editButtonItem;
        
        // set the button to be the right nav button of the nav item
        navItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:self.editButton, nil];
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
    
    // convert the button tag to a string to use as key for dictionary
    // there's probably a better way
//    NSString *dayKey = [NSString stringWithFormat:@"%ld", (long)btn.tag];
    NSNumber *dayNumber = @(btn.tag);
    NSLog(@"Add button tapped in section %@", dayNumber);
    
//    NSString *dayInRoutines;
//    switch (dayNumber) {
//        case 0:
//            dayInRoutines = @"Sunday";
//            break;
//        case 1:
//            dayInRoutines = @"Monday";
//            break;
//        case 2:
//            dayInRoutines = @"Tuesday";
//            break;
//        case 3:
//            dayInRoutines = @"Wednesday";
//            break;
//        case 4:
//            dayInRoutines = @"Thursday";
//            break;
//        case 5:
//            dayInRoutines = @"Friday";
//            break;
//        case 6:
//            dayInRoutines = @"Saturday";
//            break;
//        
//        default:
//            NSLog(@"Error");
//            break;
//    }
    
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLEDay"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"daynumber == %@", dayNumber];
    [request setPredicate:predicate];
    NSArray *fetchResult = [cdh.context executeFetchRequest:request error:nil];
    KLEDay *selectedDay = [fetchResult firstObject];
    self.dayID = [selectedDay objectID];
    NSLog(@"##Selected Day %@", selectedDay);
    
    // access the dictionary of day routines
//    NSDictionary *dailyWorkouts = [[KLEDailyStore sharedStore] allStatStores];
    
    // access the routines for that day
//    NSMutableArray *dayRoutines = [dailyWorkouts objectForKey:dayKey];
    
//    NSLog(@"day routines %@", dayRoutines);
    
    
    KLERoutineViewController *rvc = [[KLERoutineViewController alloc] init];
    
    // pass the day selected
//    rvc.dayTag = daynumber;
    rvc.routinesID = self.routinesID;
    rvc.dayID = self.dayID;
    NSLog(@"routines ID %@", self.routinesID);
    
    [self.navigationController pushViewController:rvc animated:YES];
}

- (NSArray *)createActionRowPathsFromRoutineIndex:(NSUInteger)routineIndex startIndex:(NSUInteger)startIndex atIndexPath:(NSIndexPath *)indexPath
{
    KLEDailyStore *dailyStore = [KLEDailyStore sharedStore];
    NSDictionary *dailyRoutines = [dailyStore allStatStores];
    NSString *key = [NSString stringWithFormat:@"%lu", indexPath.section];
    NSArray *dayRoutines = [dailyRoutines objectForKey:key];
    
    NSMutableArray *indexPathsForExercises = [[NSMutableArray alloc] init];
    
    KLEStatStore *routines = [dayRoutines objectAtIndex:routineIndex];
    NSArray *exercises = [routines allStats];
    
    NSUInteger index = 0;
    if ([exercises count]) {
        for (KLEStat *exercise in exercises) {
            // index path has to start after the normal cell
            NSLog(@"exercises in routine %@ in section %lu", exercise.exercise, indexPath.section);
            NSIndexPath *exerciseIndexPath = [NSIndexPath indexPathForRow:startIndex inSection:indexPath.section];
            [indexPathsForExercises addObject:exerciseIndexPath];
            startIndex++;
            NSLog(@"IndexPathsForExercises row %lu and section %lu", [[indexPathsForExercises objectAtIndex:index] row], [[indexPathsForExercises objectAtIndex:index] section]);
            index++;
        }
    } else {
        NSLog(@"There's no exercises in this routine");
        self.editButton.enabled = YES;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if this is the selected index we need to return the height of the cell
    // in relation to the label height otherwise just return the minimum height with padding
    if (selectedIndex == indexPath.row) {
        return [self getLabelHeightForIndex:indexPath.row] + COMMENT_LABEL_PADDING * 2;
    } else {
        return COMMENT_LABEL_MIN_HEIGHT + COMMENT_LABEL_PADDING * 2;
    }
}

#pragma mark - DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLEDay"];
//    KLERoutines *routines = (KLERoutines *)[cdh.context existingObjectWithID:self.routinesID error:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"daynumber == %@", @(section)];
    [request setPredicate:predicate];
//    NSUInteger routinesCount = [cdh.context countForFetchRequest:request error:nil];
    NSArray *requestObjects = [cdh.context executeFetchRequest:request error:nil];
    KLEDay *dayRoutines = [requestObjects firstObject];
    NSUInteger routinesCount = [dayRoutines.routine count];
    NSLog(@"###routines count %lu", routinesCount);
    
    return routinesCount;
//    // access the dictionary of day routines to get the count
//    NSDictionary *dailyWorkouts = [[KLEDailyStore sharedStore] allStatStores];
//    NSString *key = [NSString stringWithFormat:@"%lu", section];
//    NSArray *dayRoutines = [dailyWorkouts objectForKey:key];
//    
//    NSUInteger actionRowsCount = 0;
//
//    // have to account for the extra action row plus the routines in each section
//    NSEnumerator *enumerator = [self.actionRowPaths objectEnumerator];
//    NSIndexPath *actionRow;
//    rowCountBySection = 0;
//    NSLog(@"actionRowPaths contents %@", self.actionRowPaths);
//    if ([self.actionRowPaths count]) {
//        actionRowsCount = [self.actionRowPaths count];
//        while (actionRow = [enumerator nextObject]) {
//            NSLog(@"actionRow row %lu and section %lu", actionRow.row, actionRow.section);
//            if (actionRow.section == section) {
//                rowCountBySection = [dayRoutines count] + actionRowsCount;
//            } else {
//                rowCountBySection = [dayRoutines count];
//            }
//        }
//    } else {
//        rowCountBySection = [dayRoutines count];
//        NSLog(@"rowCountBySection ELSE %lu", rowCountBySection);
//    }
//    
//    NSLog(@"Section %lu", section);
//    NSLog(@"Row count %lu", rowCountBySection);
//    return rowCountBySection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"number of sections %lu", [daysArray count]);
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
    self.manageRoutines.tag = section;
    [self.manageRoutines addTarget:self action:@selector(addWorkout:) forControlEvents:UIControlEventTouchUpInside];
    
    return _dailyHeaderView;
}

// override CoreDataTableViewController methods
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index
{
    return 0;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
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
        self.editButton.enabled = YES;
        
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
        // write a method to make actionRowPaths from exercises, pass in parameter startIndex, return array
        // write block to update actionRowPaths when new exercise added to routine
        
        NSArray *indexPathsForExercises = [self createActionRowPathsFromRoutineIndex:routineIndex startIndex:startIndexAtOne atIndexPath:indexPath];
        
        pathsToAdd = indexPathsForExercises;
        self.actionRowPaths = indexPathsForExercises;
        
    } else {
        // case: action row tapped
        self.didSelectRowAtIndexPath = indexPath;

        NSUInteger startIndexAtOne = indexPath.next.row;
        NSLog(@"startIndexAtOne %lu", startIndexAtOne);
        
        // disable edit button when action row appears
        self.editButton.enabled = NO;
        
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
        
        NSArray *routinesInRoutinesStore = [[KLERoutinesStore sharedStore] allStatStores];
        KLEDailyStore *dailyStore = [KLEDailyStore sharedStore];
        NSDictionary *dailyRoutines = [dailyStore allStatStores];
        NSString *key = [NSString stringWithFormat:@"%lu", indexPath.section];
        NSArray *dayRoutines = [dailyRoutines objectForKey:key];
        
        NSUInteger startIndexForExercises = indexInActionRowPaths;
        
        // get the routine in the daily view from the selected index
        KLEStatStore *routines = [dayRoutines objectAtIndex:self.didSelectRowAtIndexPath.row];
        // find the row of the routine that matches the routine in daily
        NSUInteger indexOfRoutineInRoutinesStore;

        if ([routinesInRoutinesStore containsObject:routines]) {
            indexOfRoutineInRoutinesStore = [routinesInRoutinesStore indexOfObjectIdenticalTo:routines];
            routines = [routinesInRoutinesStore objectAtIndex:indexOfRoutineInRoutinesStore];
        }
        
        NSArray *exercises = [routines allStats];
        
        actionCell.exerciseNameLabel.text = [[exercises objectAtIndex:startIndexForExercises] exercise];

        return actionCell;
    } else {
        // normal cell
        KLEDailyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLEDailyViewCell" forIndexPath:indexPath];
        
        // when action row already present and the view is loaded again
        // adjust the row index accessed by day routines when cell comes into view, account for the action row paths count to make sure the day routines is accessed with the correct index
//        NSUInteger adjustedRow = indexPath.row;
//        if ([self.actionRowPaths count] && [[self.actionRowPaths lastObject] row] < indexPath.row) {
//            adjustedRow -= [self.actionRowPaths count];
//            NSLog(@"adjusted row decrement %lu", adjustedRow);
//        }
//        
//        // access the daily store routines
//        KLEDailyStore *dailyStore = [KLEDailyStore sharedStore];
//        NSDictionary *dailyRoutines = [dailyStore allStatStores];
//        NSString *key = [NSString stringWithFormat:@"%lu", indexPath.section];
//        NSArray *dayRoutines = [dailyRoutines objectForKey:key];
//        
//        // fixed
//        // routineInDaily returns the routine using indexPath.row. when new row inserted from
//        // action row, it is trying to access a index that isn't there
//        
//        // to access the properties of the routine, routine name, etc
//        NSLog(@"day routines at adjusted row %@", [dayRoutines objectAtIndex:adjustedRow]);
//        KLEStatStore *routineInDaily = [dayRoutines objectAtIndex:adjustedRow];
//        NSLog(@"cell day routines array %@", dayRoutines);
//        
//        cell.accessoryType = UITableViewCellAccessoryDetailButton;
//        cell.routineNameLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
//        cell.routineNameLabel.text = routineInDaily.routineName;
        
//        KLERoutine *routine = [self.frc objectAtIndexPath:indexPath];
//        cell.routineNameLabel.text = routine.routinename
        
        CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLEDay"];
        //    KLERoutines *routines = (KLERoutines *)[cdh.context existingObjectWithID:self.routinesID error:nil];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"daynumber == %@", @(indexPath.section)];
        [request setPredicate:predicate];
        //    NSUInteger routinesCount = [cdh.context countForFetchRequest:request error:nil];
        NSArray *requestObjects = [cdh.context executeFetchRequest:request error:nil];
        KLEDay *dayRoutines = [requestObjects firstObject];
        NSArray *routineObjects = [NSArray arrayWithArray:[dayRoutines.routine allObjects]];
        NSLog(@"###cell for row count %@", routineObjects);
        
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // access the routine store
    NSArray *statStores = [[KLERoutinesStore sharedStore] allStatStores];
    
    // access the daily routine dictionary
    NSDictionary *dailyRoutines = [[KLEDailyStore sharedStore] allStatStores];
    
    // key from the table view section which represents the day
    NSString *key = [NSString stringWithFormat:@"%lu", indexPath.section];
    
    // access the routines for the selected day
    NSArray *routines = [dailyRoutines objectForKey:key];
    
    // get the selected routine in the daily view
    KLEStatStore *selectedStatStoreInDaily = [routines objectAtIndex:indexPath.row];
    
    // get the index in routines store by matching the routine from daily dictionary to the routine store
    NSUInteger indexAtRoutinesStore = [statStores indexOfObjectIdenticalTo:selectedStatStoreInDaily];
    
    // routine in routine store
    KLEStatStore *routineInRoutineStore = statStores[indexAtRoutinesStore];
    
    NSLog(@"index at routines store %@", routineInRoutineStore);
    
    KLERoutineExercisesViewController *revc = [[KLERoutineExercisesViewController alloc] init];
    
    // pass selected statStore from routine view controller to routine exercise view controller
    revc.statStore = routineInRoutineStore;
    
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
    // can implement deletion of exercises from expanded cells
    // might be better to lock editing and deletion from user
    
    // if the table view is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        KLEDailyStore *dailyStore = [KLEDailyStore sharedStore];
        NSDictionary *dailyRoutines = [dailyStore allStatStores];
        NSString *key = [NSString stringWithFormat:@"%lu", indexPath.section];
        NSMutableArray *routines = [dailyRoutines objectForKey:key];
        
//        [dailyStore removeStatStoreFromDay:[routines objectAtIndex:indexPath.row] atKey:key];
        [dailyStore removeStatStoreFromDay:[routines objectAtIndex:indexPath.row] atIndex:indexPath.row atKey:key];
        
        // also remove that row from the table view with animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
            CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
            for (NSUInteger day = 0; day < [daysArray count]; day++) {
                KLEDay *dayInstance = [NSEntityDescription insertNewObjectForEntityForName:@"KLEDay" inManagedObjectContext:cdh.context];
                dayInstance.daynumber = @(day);
                
                NSLog(@"Day %@", dayInstance.daynumber);
            }
            
            // make KLERoutine instance
            KLERoutines *routines = [NSEntityDescription insertNewObjectForEntityForName:@"KLERoutines" inManagedObjectContext:cdh.context];
            self.routinesID = [routines objectID];
            NSLog(@"routines ID %@", self.routinesID);
            
        });
    }
}

//- (void)createDailyRoutines
//{
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
//    // thread safe method
//    if (!self.routinesID) {
//        static dispatch_once_t day;
//        dispatch_once(&day, ^{
//            CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
//            KLERoutines *routines = [NSEntityDescription insertNewObjectForEntityForName:@"KLERoutines" inManagedObjectContext:cdh.context];
//            self.routinesID = [routines objectID];
//            
//            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLERoutine"];
//            KLERoutines *routines = (KLERoutines *)[cdh.context existingObjectWithID:self.routinesID error:nil];
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"routines == %@", routines];
//            [request setPredicate:predicate];
//            NSUInteger routinesCount = [cdh.context countForFetchRequest:request error:nil];
//            NSLog(@"###routines count %lu", routinesCount);
//        });
//    }
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    [self createDailyRoutines];
    if (self.dayID != nil && self.routinesID != nil) {
        [self performFetch];
    }
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
    
    [self makeDays];
    
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
    [super viewWillDisappear:YES];
    
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
        
        self.editButton.enabled = YES;
    }
}

@end
