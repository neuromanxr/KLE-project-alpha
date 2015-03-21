//
//  KLEExerciseListViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/11/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
#import "KLEAppDelegate.h"
#import "CoreDataHelper.h"
#import "KLEExercise.h"
#import "KLEExerciseGoal.h"
#import "KLERoutine.h"

#import "KLEExerciseListViewCell.h"
#import "KLEExerciseListViewController.h"

@interface KLEExerciseListViewController () <UITextFieldDelegate>

@end

@implementation KLEExerciseListViewController
#define debug 1

#pragma mark - DATA
- (void)configureFetch
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLEExercise"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"exercisename" ascending:YES], nil];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"musclename" cacheName:nil];
    self.frc.delegate = self;
}
- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self initForNewExercise:NO];
}

- (instancetype)initForNewExercise:(BOOL)isNew
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        
        UINavigationItem *navItem = self.navigationItem;
        
        if (isNew) {
            
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            navItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            navItem.leftBarButtonItem = cancelItem;
        } else {
            UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveChanges:)];
            navItem.rightBarButtonItem = saveItem;
        }
    }
    return self;
}

- (void)save:(id)sender
{
    KLEExerciseGoal *exerciseGoal = [NSEntityDescription insertNewObjectForEntityForName:@"KLEExerciseGoal" inManagedObjectContext:self.frc.managedObjectContext];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    KLEExercise *selectedExercise = [self.frc objectAtIndexPath:selectedIndexPath];
//    [exerciseGoal addExerciseObject:selectedExercise];
    exerciseGoal.exercise = selectedExercise;
    exerciseGoal.sets = [NSNumber numberWithInteger:5];
    exerciseGoal.reps = [NSNumber numberWithInteger:5];
    
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    KLERoutine *selectedRoutine = (KLERoutine *)[cdh.context existingObjectWithID:self.selectedRoutineID error:nil];
    [selectedRoutine addExercisegoalObject:exerciseGoal];
    NSLog(@"selected routine exercise goal objects %@", selectedRoutine.exercisegoal);
//    exerciseGoal.routinename = [newRoutine description];
    
    NSLog(@"selected exercise %@ type %@", selectedExercise.exercisename, selectedExercise.musclename);
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveChanges:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    KLEExerciseListViewCell *exerciseCell = (KLEExerciseListViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [exerciseCell.exerciseLabel setTextColor:[UIColor whiteColor]];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLEExerciseListViewCell *exerciseCell = (KLEExerciseListViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [exerciseCell.exerciseLabel setTextColor:[UIColor kPrimaryColor]];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    [headerView.backgroundView setBackgroundColor:[UIColor kPrimaryColor]];
    [headerView.textLabel setTextColor:[UIColor whiteColor]];
    [headerView.textLabel setFont:[KLEUtility getFontFromFontFamilyWithSize:16.0]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create an instance of UITableViewCell, with default appearance
    KLEExerciseListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLEExerciseListViewCell" forIndexPath:indexPath];
    
    KLEExercise *exercise = [self.frc objectAtIndexPath:indexPath];
    cell.exerciseLabel.text = exercise.exercisename;
    
    // change cell selected color
    UIView *selectedColorView = [[UIView alloc] init];
    [selectedColorView setBackgroundColor:[UIColor kPrimaryColor]];
    [cell setSelectedBackgroundView:selectedColorView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Did select row %@", [self.frc objectAtIndexPath:indexPath]);
//    self.selectedExerciseLabel.text = [_exerciseArray[indexPath.row] exercisename];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)setupNavigationBar
{
    // custom title for navigation title
    NSArray *fontFamily = [UIFont fontNamesForFamilyName:@"Heiti TC"];
    UIFont *font = [UIFont fontWithName:[fontFamily firstObject] size:18.0];
    NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:@"Exercises" attributes:@{ NSFontAttributeName : font, NSUnderlineStyleAttributeName : @0, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    // custom title for navigation title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 0;
    title.attributedText = attribString;
    [title sizeToFit];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTintColor:[UIColor orangeColor]];
    [self.navigationItem setTitleView:title];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    
    [self setupNavigationBar];
    
    self.tableView.sectionIndexColor = [UIColor orangeColor];
//    self.tableView.sectionIndexBackgroundColor = [UIColor kPrimaryColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLEExerciseListViewCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLEExerciseListViewCell"];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
}

@end
