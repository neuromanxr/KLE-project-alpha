//
//  KLERoutineExercisesViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/15/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEStat.h"
#import "KLEStatStore.h"
#import "KLERoutineExercisesViewCell.h"
#import "KLEExerciseListViewController.h"
#import "KLERoutineExercisesViewController.h"

@implementation KLERoutineExercisesViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        // title for rvc
        navItem.title = @"Routine Exercises";
        
        // button to add exercises
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewExercise)];
        
        // button to edit routine
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editRoutines)];
        
        // set the button to be the right nav button of the nav item
        navItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:addButton, editButton, nil];
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create an instance of UITableViewCell, with default appearance
    KLERoutineExercisesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLERoutineExercisesViewCell" forIndexPath:indexPath];
    
//    NSArray *statsArray = [[KLEStatStore sharedStore] allStats];
//    KLEStat *stat = statsArray[indexPath.row];
    
    cell.exerciseNameLabel.text = @"exercise";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLEExerciseListViewController *evc = [[KLEExerciseListViewController alloc] init];
    
    [self.navigationController pushViewController:evc animated:YES];
}

- (void)addNewExercise
{
    // create a new BNRItem and add it to the store
    //    KLEStat *newStat = [[KLEStatStore sharedStore] createStat];
    
    KLEExerciseListViewController *evc = [[KLEExerciseListViewController alloc] initForNewExercise:YES];
    //    exerciseListViewController.exercise = newStat;
    
    // completion block that will reload the table
    //    detailViewController.dismissBlock = ^{
    //        [self.tableView reloadData];
    //    };
    
    //    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:evc];
    //    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    //    self.navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController pushViewController:evc animated:YES];
    //    [self presentViewController:navController animated:YES completion:nil];
}

- (void)editRoutines
{
    NSLog(@"Edit button tapped");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLERoutineExercisesViewCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLERoutineExercisesViewCell"];
    
}

@end
