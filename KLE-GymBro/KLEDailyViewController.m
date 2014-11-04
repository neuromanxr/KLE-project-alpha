//
//  KLEDailyViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/6/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

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
#define COMMENT_LABEL_MIN_HEIGHT 65
#define COMMENT_LABEL_PADDING 10

@interface KLEDailyViewController ()

// daily view header
@property (strong, nonatomic) IBOutlet UIView *dailyHeaderView;
@property (strong, nonatomic) IBOutlet UIView *dailyFooterView;
@property (weak, nonatomic) IBOutlet UILabel *headerDayLabel;
@property (weak, nonatomic) IBOutlet UIButton *footerAddButton;
@property (strong, nonatomic) UIBarButtonItem *editButton;

// action rows
@property (nonatomic) NSIndexPath *actionRowPath;
@property (nonatomic, strong) NSArray *actionRowPaths;
@property (nonatomic, strong) NSIndexPath *didSelectRowAtIndexPath;

@end

@implementation KLEDailyViewController

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

- (void)addWorkout
{
    KLERoutineViewController *rvc = [[KLERoutineViewController alloc] init];
    
//    CGRect frame = [UIScreen mainScreen].bounds;
//    UIView *view = [[UIView alloc] initWithFrame:frame];
//    view.backgroundColor = [UIColor redColor];
//    UIViewController *stats = [[UIViewController alloc] init];
//    stats.view = view;
    
//    UITabBarController *tbc = [[UITabBarController alloc] init];
//    tbc.viewControllers = @[rvc, stats];
    
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)addWorkout:(id)sender
{
    // get a pointer to the button passed from sender
    UIButton *btn = (UIButton *)sender;
    
    // convert the button tag to a string to use as key for dictionary
    // there's probably a better way
    NSString *dayKey = [NSString stringWithFormat:@"%ld", (long)btn.tag];
    NSLog(@"Add button tapped in section %@", dayKey);
    
    // access the dictionary of day routines
    NSDictionary *dailyWorkouts = [[KLEDailyStore sharedStore] allStatStores];
    
    // access the routines for that day
    NSMutableArray *dayRoutines = [dailyWorkouts objectForKey:dayKey];
    
    NSLog(@"day routines %@", dayRoutines);
    
    KLERoutineViewController *rvc = [[KLERoutineViewController alloc] init];
    
    // pass the day selected
    rvc.dayTag = dayKey;
    
    [self.navigationController pushViewController:rvc animated:YES];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // access the dictionary of day routines to get the count
    NSDictionary *dailyWorkouts = [[KLEDailyStore sharedStore] allStatStores];
    NSString *key = [NSString stringWithFormat:@"%lu", section];
    NSArray *dayRoutines = [dailyWorkouts objectForKey:key];
    
    NSUInteger actionRowsCount = 0;

    // have to account for the extra action row plus the routines in each section
    NSEnumerator *enumerator = [self.actionRowPaths objectEnumerator];
    NSIndexPath *actionRow;
    rowCountBySection = 0;
    NSLog(@"actionRowPaths contents %@", self.actionRowPaths);
    if ([self.actionRowPaths count]) {
        actionRowsCount = [self.actionRowPaths count];
        while (actionRow = [enumerator nextObject]) {
            NSLog(@"actionRow row %lu and section %lu", actionRow.row, actionRow.section);
            if (actionRow.section == section) {
                rowCountBySection = [dayRoutines count] + actionRowsCount;
            } else {
                rowCountBySection = [dayRoutines count];
            }
        }
    } else {
        rowCountBySection = [dayRoutines count];
        NSLog(@"rowCountBySection ELSE %lu", rowCountBySection);
    }
    
    NSLog(@"Section %lu", section);
    NSLog(@"Row count %lu", rowCountBySection);
    return rowCountBySection;
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
    
    return _dailyHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90.0;
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
    return 60.0;
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
        
        KLEDailyStore *dailyStore = [KLEDailyStore sharedStore];
        NSDictionary *dailyRoutines = [dailyStore allStatStores];
        NSString *key = [NSString stringWithFormat:@"%lu", indexPath.section];
        NSArray *dayRoutines = [dailyRoutines objectForKey:key];
        
        NSMutableArray *indexPathsForExercises = [[NSMutableArray alloc] init];
        
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
            }
            
            routineIndex = actionRowPath.row;
            startIndexAtOne = newActionRowPath.row;
        }
        // write a method to make actionRowPaths from exercises, pass in parameter startIndex, return array
        // write block to update actionRowPaths when new exercise added to routine
        KLEStatStore *routines = [dayRoutines objectAtIndex:routineIndex];
        NSArray *exercises = [routines allStats];
        
        NSUInteger index = 0;
        if ([exercises count]) {
            for (KLEStat *exercise in exercises) {
                // index path has to start after the normal cell
                NSLog(@"exercises in routine %@ in section %lu", exercise.exercise, indexPath.section);
                NSIndexPath *exerciseIndexPath = [NSIndexPath indexPathForRow:startIndexAtOne inSection:indexPath.section];
                [indexPathsForExercises addObject:exerciseIndexPath];
                startIndexAtOne++;
                NSLog(@"IndexPathsForExercises row %lu and section %lu", [[indexPathsForExercises objectAtIndex:index] row], [[indexPathsForExercises objectAtIndex:index] section]);
                index++;
            }
        } else {
            NSLog(@"There's no exercises in this routine");
            self.editButton.enabled = YES;
        }
        pathsToAdd = indexPathsForExercises;
        self.actionRowPaths = indexPathsForExercises;
        
    } else {
        self.didSelectRowAtIndexPath = indexPath;
        // case: action row tapped
        KLEDailyStore *dailyStore = [KLEDailyStore sharedStore];
        NSDictionary *dailyRoutines = [dailyStore allStatStores];
        NSString *key = [NSString stringWithFormat:@"%lu", indexPath.section];
        NSArray *dayRoutines = [dailyRoutines objectForKey:key];
        
        KLEStatStore *routines = [dayRoutines objectAtIndex:indexPath.row];
        NSArray *exercises = [routines allStats];
        NSMutableArray *indexPathsForExercises = [[NSMutableArray alloc] init];
        
        NSUInteger index = 0;
        NSUInteger startIndexAtOne = indexPath.next.row;
        NSLog(@"startIndexAtOne %lu", startIndexAtOne);
        
        // disable edit button when action row appears
        self.editButton.enabled = NO;
        
        if ([exercises count]) {
            for (KLEStat *exercise in exercises) {
                // index path has to start after the normal cell
                NSLog(@"exercises in routine %@ in section %lu", exercise.exercise, indexPath.section);
                NSIndexPath *exerciseIndexPath = [NSIndexPath indexPathForRow:startIndexAtOne inSection:indexPath.section];
                [indexPathsForExercises addObject:exerciseIndexPath];
                startIndexAtOne++;
                NSLog(@"IndexPathsForExercises row %lu and section %lu", [[indexPathsForExercises objectAtIndex:index] row], [[indexPathsForExercises objectAtIndex:index] section]);
                index++;
                
                // need to add code to update pathsToAdd array when adding another exercise to already expanded cell so the new exercise will show in expanded cell
            }
        } else {
            [indexPathsForExercises removeAllObjects];
            NSLog(@"There's no exercises in this routine");
            self.editButton.enabled = YES;
        }

        pathsToAdd = indexPathsForExercises;
        self.actionRowPaths = indexPathsForExercises;
        
        NSLog(@"actionRowPath %lu", self.actionRowPath.row);
    }
    
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
        NSUInteger adjustedRow = indexPath.row;
        if ([self.actionRowPaths count] && [[self.actionRowPaths lastObject] row] < indexPath.row) {
            adjustedRow -= [self.actionRowPaths count];
            NSLog(@"adjusted row decrement %lu", adjustedRow);
        }
        
        // access the daily store routines
        KLEDailyStore *dailyStore = [KLEDailyStore sharedStore];
        NSDictionary *dailyRoutines = [dailyStore allStatStores];
        NSString *key = [NSString stringWithFormat:@"%lu", indexPath.section];
        NSArray *dayRoutines = [dailyRoutines objectForKey:key];
        
        // fixed
        // routineInDaily returns the routine using indexPath.row. when new row inserted from
        // action row, it is trying to access a index that isn't there
        
        // to access the properties of the routine, routine name, etc
        NSLog(@"day routines at adjusted row %@", [dayRoutines objectAtIndex:adjustedRow]);
        KLEStatStore *routineInDaily = [dayRoutines objectAtIndex:adjustedRow];
        NSLog(@"cell day routines array %@", dayRoutines);
        
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.routineNameLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        cell.routineNameLabel.text = routineInDaily.routineName;
        
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLEDailyViewCell" bundle:nil];
    
    UINib *actionNib = [UINib nibWithNibName:@"KLEActionCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLEDailyViewCell"];
    
    [self.tableView registerNib:actionNib forCellReuseIdentifier:@"KLEActionCell"];
    
    // no cell is expanded
    selectedIndex = -1;
    
    indexInActionRowPaths = -1;
    
    daysArray = [[NSArray alloc] initWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];

}

@end
