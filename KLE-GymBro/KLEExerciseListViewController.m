//
//  KLEExerciseListViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/11/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//
#import "KLEAppDelegate.h"
#import "CoreDataHelper.h"
#import "KLEExercise.h"
#import "KLEExerciseGoal.h"
#import "KLERoutine.h"

#import "KLEExerciseListViewCell.h"
#import "KLEExerciseListViewController.h"

@interface KLEExerciseListViewController () <UITextFieldDelegate>

@property (nonatomic, copy) NSArray *exerciseArray;
@property (nonatomic, strong) IBOutlet UIView *headerView;

// KLEHeaderView labels
@property (weak, nonatomic) IBOutlet UILabel *selectedExerciseLabel;
@property (weak, nonatomic) IBOutlet UILabel *setsLabel;
@property (weak, nonatomic) IBOutlet UILabel *repsLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UITextField *setsField;
@property (weak, nonatomic) IBOutlet UITextField *repsField;
@property (weak, nonatomic) IBOutlet UITextField *weightField;

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
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"exercisename" cacheName:nil];
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
        navItem.title = @"Exercises";
        
        if (isNew) {
            
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        } else {
            UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveChanges:)];
            self.navigationItem.rightBarButtonItem = saveItem;
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
    
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    KLERoutine *selectedRoutine = (KLERoutine *)[cdh.context existingObjectWithID:self.selectedRoutineID error:nil];
    [selectedRoutine addExercisegoalObject:exerciseGoal];
    NSLog(@"selected routine exercise goal objects %@", selectedRoutine.exercisegoal);
//    exerciseGoal.routinename = [newRoutine description];
    
    // get the selected exercise
//    NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
//    KLEExercise *selectedExercise = [_exerciseArray objectAtIndex:selectedRow.row];
    NSLog(@"selected exercise %@ type %@", selectedExercise.exercisename, selectedExercise.musclename);
    
    // insert exercise goal object and set its attributes
//    KLEExerciseGoal *exerciseGoal = [NSEntityDescription insertNewObjectForEntityForName:@"KLEExerciseGoal" inManagedObjectContext:cdh.context];
//    [exerciseGoal addExerciseObject:selectedExercise];
//    exerciseGoal.sets = @([self.setsField.text integerValue]);
//    exerciseGoal.reps = @([self.repsField.text integerValue]);
//    exerciseGoal.weight = @([self.weightField.text floatValue]);
//    NSLog(@"exercise goal object %@", exerciseGoal.exercise);
    
//    [cdh saveContext];
    
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLEExerciseGoal"];
//    NSArray *fetchedObjects = [cdh.context executeFetchRequest:request error:nil];
//    NSLog(@"exercise goals %@ fetched count %lu", fetchedObjects, [fetchedObjects count]);
    
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveChanges:(id)sender
{
    // selected row is the exercise selected from the exercise array
//    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    
    
    // pointer to the currently selected exercise
//    KLEStat *stat = self.stat;
//    stat.exercise = [_exerciseArray[selectedRow.row] name];
//    stat.sets = [self.setsField.text intValue];
//    stat.reps = [self.repsField.text intValue];
//    stat.weight = [self.weightField.text floatValue];
    
    // store the new exercise selection
//    stat.userSelections = selectedRow;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (!_headerView) {
//        // load headerView.xib
//        // lazy instantiation, saves memory
//        [[NSBundle mainBundle] loadNibNamed:@"KLEHeaderView"
//                                      owner:self
//                                    options:nil];
//        _headerView.backgroundColor = [UIColor grayColor];
//        
//        // set the text field delegates
//        self.setsField.delegate = self;
//        self.repsField.delegate = self;
//        self.weightField.delegate = self;
//        
//        // change keyboard to number pad
//        self.setsField.keyboardType = UIKeyboardTypeNumberPad;
//        self.repsField.keyboardType = UIKeyboardTypeNumberPad;
//        self.weightField.keyboardType = UIKeyboardTypeNumberPad;
//        
//        if (self.stat) {
//            self.selectedExerciseLabel.text = self.stat.exercise;
//            self.setsField.text = [NSString stringWithFormat:@"%d", self.stat.sets];
//            self.repsField.text = [NSString stringWithFormat:@"%d", self.stat.reps];
//            self.weightField.text = [NSString stringWithFormat:@"%f", self.stat.weight];
//
//        } else {
//            self.selectedExerciseLabel.text = @"Exercise Name";
//            self.setsField.text = [NSString stringWithFormat:@"%d", 0];
//            self.repsField.text = [NSString stringWithFormat:@"%d", 0];
//            self.weightField.text = [NSString stringWithFormat:@"%f", 0.0];
//        }
//    }
//    
//    return _headerView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 120.0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [_exerciseArray count];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create an instance of UITableViewCell, with default appearance
    KLEExerciseListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLEExerciseListViewCell" forIndexPath:indexPath];
    
    KLEExercise *exercise = [self.frc objectAtIndexPath:indexPath];
    cell.exerciseLabel.text = exercise.exercisename;
    // loop through the exercise names in the second column
//    cell.exerciseLabel.text = [[_exerciseArray objectAtIndex:indexPath.row] exercisename];
    // muscle group name is the third column
//    cell.muscleGroupLabel.text = _exerciseArray[0][indexPath.row][1];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    KLEStat *stat = self.stat;
    
    // pre-select the selected exercise from revc
//    [self.tableView selectRowAtIndexPath:stat.userSelections animated:YES scrollPosition:UITableViewScrollPositionTop];
    
//    NSLog(@"ELVC viewWillAppear ELVCselection %lu", stat.userSelections.row);
    
    // set the text field delegates
    self.setsField.delegate = self;
    self.repsField.delegate = self;
    self.weightField.delegate = self;
    
    // change keyboard to number pad
    self.setsField.keyboardType = UIKeyboardTypeNumberPad;
    self.repsField.keyboardType = UIKeyboardTypeNumberPad;
    self.weightField.keyboardType = UIKeyboardTypeNumberPad;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLEExerciseListViewCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLEExerciseListViewCell"];
    
    // tell tableview about its header view
//    UIView *header = self.headerView;
//    [self.tableView setTableHeaderView:header];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    // clear first responder
    [self.view endEditing:YES];
}

@end
