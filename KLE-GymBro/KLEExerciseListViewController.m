//
//  KLEExerciseListViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/11/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEExercises.h"
#import "KLEExerciseListViewCell.h"
#import "KLEStat.h"
#import "KLEStatStore.h"
#import "KLEExerciseListViewController.h"

@interface KLEExerciseListViewController ()

@property (nonatomic, copy) NSMutableArray *exerciseArray;
@property (strong, nonatomic) IBOutlet UIView *headerView;

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
        }
    }
    return self;
}

- (void)save:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
                                      owner:self
                                    options:nil];
        _headerView.backgroundColor = [UIColor redColor];
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
//    [self.navigationController popViewControllerAnimated:YES];
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

@end
