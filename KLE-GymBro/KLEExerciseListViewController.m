//
//  KLEExerciseListViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/11/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLERoutinesStore.h"
#import "KLEExercises.h"
#import "KLEExerciseListViewCell.h"
#import "KLEStat.h"
#import "KLEStatStore.h"
#import "KLEExerciseListViewController.h"

@interface KLEExerciseListViewController ()

@property (nonatomic, copy) NSMutableArray *exerciseArray;
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
        navItem.title = @"Exercises List";
        
        KLEExercises *exercises = [[KLEExercises alloc] init];
        _exerciseArray = exercises.exerciseList;
        
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
    // CHANGE THIS, DONT USE ARRAY
    // store the exercise selection for this routine, there's only one selection always
    // might implement multiple selections in future
    self.statStore.userSelections = [[NSArray alloc] initWithObjects:[self.tableView indexPathForSelectedRow], nil];
    NSLog(@"store user selections %@", self.statStore.userSelections);
    
    // create the exercise in the routine
    [self.statStore createStat];
    
    // selected row is the exercise selected from the exercise array
    NSIndexPath *selectedRow = [self.statStore.userSelections lastObject];
    NSLog(@"user selections %lu", selectedRow.row);
    NSLog(@"Stats %@", [self.statStore allStats]);
    
    // access the routine store
    NSArray *statStoreArray = [[NSArray alloc] initWithArray:self.statStore.allStats];
    
    // it is the last exercise because revc adds the exercise to the end of the array
    KLEStat *stat = [statStoreArray lastObject];
    
    // assign the label name from the selected row in exercise array
    stat.exercise = _exerciseArray[0][selectedRow.row][0];
    NSLog(@"exercise %@", stat.exercise);
    
    stat.sets = [self.setsField.text intValue];
    NSLog(@"stat sets %d", stat.sets);
    NSLog(@"text field %@", self.setsField.text);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)saveChanges:(id)sender
{
    // store the exercise selection for this routine, there's only one selection always
    // might implement multiple selections in future
//    self.statStore.userSelections = [[NSArray alloc] initWithObjects:[self.tableView indexPathForSelectedRow], nil];
    
    // selected row is the exercise selected from the exercise array
    NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
    
    NSLog(@"stat saveChanges %@", self.stat);
    NSLog(@"user saveChanges %lu", selectedRow.row);
}

- (void)cancel:(id)sender
{
    // if the user cancelled, then remove the BNRItem from the store
    
    [self.navigationController popViewControllerAnimated:YES];
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_headerView) {
        // load headerView.xib
        // lazy instantiation, saves memory
        [[NSBundle mainBundle] loadNibNamed:@"KLEHeaderView"
                                      owner:self
                                    options:nil];
        _headerView.backgroundColor = [UIColor grayColor];
        
        if (self.stat) {
            self.selectedExerciseLabel.text = self.stat.exercise;
//            self.setsField.text = @"22";
            NSLog(@"if stat %@", self.stat);
        } else {
            self.selectedExerciseLabel.text = @"Exercise Name";
        }
    }
    
    return _headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 120.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_exerciseArray[0] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create an instance of UITableViewCell, with default appearance
    KLEExerciseListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLEExerciseListViewCell" forIndexPath:indexPath];
    
    // loop through the exercise names in the second column
    cell.exerciseLabel.text = _exerciseArray[0][indexPath.row][0];
    // muscle group name is the third column
    cell.muscleGroupLabel.text = _exerciseArray[0][indexPath.row][1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedExerciseLabel.text = _exerciseArray[0][indexPath.row][0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.setsField.text = @"22";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
}

@end
