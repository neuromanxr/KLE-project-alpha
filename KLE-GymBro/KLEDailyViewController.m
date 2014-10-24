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

// action rows
@property (nonatomic) NSIndexPath *actionRowPath;

@end

@implementation KLEDailyViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Daily";
        
        // button to edit routine
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:nil];
        
        // set bar button to toggle editing mode
        editButton = self.editButtonItem;
        
        // set the button to be the right nav button of the nav item
        navItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:editButton, nil];
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
    
//    NSLog(@"Action row %lu", [dayRoutines count] + (self.actionRowPath != nil));

    NSLog(@"Action row before %lu", self.actionRowPath.section);
    
    if (self.actionRowPath.section == section) {
        NSLog(@"Action row section equals section");
        return [dayRoutines count] + (self.actionRowPath != nil);
    } else {
        return [dayRoutines count];
    }
//    NSLog(@"Action row count %lu in section %lu", [dayRoutines count] + count, section);
//    return [dayRoutines count] + (self.actionRowPath != nil);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"number of sections %lu", [daysArray count]);
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
    // we only don't want to allow selection on any cells which cannot be expanded
//    if ([self getLabelHeightForIndex:indexPath.row] > COMMENT_LABEL_MIN_HEIGHT) {
//        return indexPath;
//    } else {
//        return nil;
//    }
    if ([indexPath isEqual:self.actionRowPath]) {
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
    NSArray *pathsToAdd;
    NSArray *pathsToDelete;
    
    if ([self.actionRowPath.previous isEqual:indexPath]) {
        // hide action cell
        pathsToDelete = @[self.actionRowPath];
        self.actionRowPath = nil;
        [self deselect];
    } else if (self.actionRowPath) {
        // move action cell
        pathsToDelete = @[self.actionRowPath];
        BOOL before = [indexPath before:self.actionRowPath];
        NSIndexPath *newPath = before ? indexPath.next : indexPath;
        pathsToAdd = @[newPath];
        self.actionRowPath = newPath;
    } else {
        // new action cell
        pathsToAdd = @[indexPath.next];
        NSLog(@"pathsToAdd row %lu in section %lu", [[pathsToAdd objectAtIndex:0] row], [[pathsToAdd objectAtIndex:0] section]);
        self.actionRowPath = indexPath.next;
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
    // create an instance of UITableViewCell, with default appearance
//    KLEDailyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLEDailyViewCell" forIndexPath:indexPath];
//    
//    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    if ([self.actionRowPath isEqual:indexPath]) {
        // action row
        KLEActionCell *actionCell = [tableView dequeueReusableCellWithIdentifier:@"KLEActionCell" forIndexPath:indexPath];
        
        return actionCell;
    } else {
        // normal cell
        KLEDailyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLEDailyViewCell" forIndexPath:indexPath];
        
        NSInteger adjustedRow = indexPath.row;
        if (_actionRowPath && (_actionRowPath.row < indexPath.row)) {
            adjustedRow--;
        }
        
        // access the daily store routines
        KLEDailyStore *dailyStore = [KLEDailyStore sharedStore];
        NSDictionary *dailyRoutines = [dailyStore allStatStores];
        NSString *key = [NSString stringWithFormat:@"%lu", indexPath.section];
        NSArray *dayRoutines = [dailyRoutines objectForKey:key];
        
        // routineInDaily returns the routine using indexPath.row. when new row inserted from
        // action row, it is trying to access a index that isn't there
        
        // to access the properties of the routine, routine name, etc
        KLEStatStore *routineInDaily = [dayRoutines objectAtIndex:adjustedRow];
        NSLog(@"cell day routines %@", dayRoutines);
        
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.routineNameLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        cell.routineNameLabel.text = routineInDaily.routineName;
        
        return cell;
    }
    
//    if (selectedIndex == indexPath.row) {
//        CGFloat labelHeight = [self getLabelHeightForIndex:indexPath.row];
//        cell.dayLabel.frame = CGRectMake(cell.dayLabel.frame.origin.x, cell.dayLabel.frame.origin.y, cell.dayLabel.frame.size.width, labelHeight);
//    } else {
//        // otherwise return the minimum height
//        cell.dayLabel.frame = CGRectMake(cell.dayLabel.frame.origin.x, cell.dayLabel.frame.origin.y, cell.dayLabel.frame.size.width, COMMENT_LABEL_MIN_HEIGHT);
//    }
    
//    cell.routineNameLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
//    cell.routineNameLabel.text = routineInDaily.routineName;
    
//    return cell;
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
    
    NSLog(@"access routines %@", routines);
    NSLog(@"index at routines store %@", routineInRoutineStore);
    
    KLERoutineExercisesViewController *revc = [[KLERoutineExercisesViewController alloc] init];
    
    // pass selected statStore from routine view controller to routine exercise view controller
    revc.statStore = routineInRoutineStore;
    
    [self.navigationController pushViewController:revc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if the table view is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        KLEDailyStore *dailyStore = [KLEDailyStore sharedStore];
        NSDictionary *dailyRoutines = [dailyStore allStatStores];
        NSString *key = [NSString stringWithFormat:@"%lu", indexPath.section];
        NSMutableArray *routines = [dailyRoutines objectForKey:key];
        
        [dailyStore removeStatStoreFromDay:[routines objectAtIndex:indexPath.row] atKey:key];
        
        // also remove that row from the table view with animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    KLEDailyStore *dailyStore = [KLEDailyStore sharedStore];
    NSString *key = [NSString stringWithFormat:@"%lu", sourceIndexPath.section];
    NSLog(@"moving row %@", key);
    
    [dailyStore moveStatStoreAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row atKey:key];
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
    
    daysArray = [[NSArray alloc] initWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];

}

@end
