//
//  KLERoutineExercisesViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/15/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEExercises.h"
#import "KLEStat.h"
#import "KLEStatStore.h"
#import "KLERoutinesStore.h"
#import "KLERoutineExercisesViewCell.h"
#import "KLEExerciseListViewController.h"
#import "KLERoutineExercisesViewController.h"

@interface KLERoutineExercisesViewController ()

@property (nonatomic, copy) NSArray *routinesArray;

@end

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
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:nil];
        
        // set bar button to toggle editing mode
        editButton = self.editButtonItem;
        
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
    NSLog(@"stat store count %lu", [[self.statStore allStats] count]);
    return [[self.statStore allStats] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create an instance of UITableViewCell, with default appearance
    KLERoutineExercisesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLERoutineExercisesViewCell" forIndexPath:indexPath];
    
    NSLog(@"revc %@", self.statStore.allStats);
    
    // access the stat store using the selected index path row
    // then assign the exercise name property to the cell label
    NSArray *statStoreArray = [[NSArray alloc] initWithArray:self.statStore.allStats];
    KLEStat *stat = statStoreArray[indexPath.row];
    cell.exerciseNameLabel.text = stat.exercise;
    cell.setsLabel.text = [NSString stringWithFormat:@"%d", stat.sets];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLEExerciseListViewController *elvc = [[KLEExerciseListViewController alloc] initForNewExercise:NO];
    
    NSArray *statStoreArray = [[NSArray alloc] initWithArray:self.statStore.allStats];
    KLEStat *stat = statStoreArray[indexPath.row];
    elvc.stat = stat;
    
    [self.navigationController pushViewController:elvc animated:YES];
}

- (void)addNewExercise
{
    KLEExerciseListViewController *elvc = [[KLEExerciseListViewController alloc] initForNewExercise:YES];
    
    // pass the selected statStore to exercise list view controller
    elvc.statStore = self.statStore;
    NSLog(@"elvc statstore %@", elvc.statStore);
    
    [self.navigationController pushViewController:elvc animated:YES];
    
    //    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:evc];
    //    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    //    self.navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    //    [self presentViewController:navController animated:YES completion:nil];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.tableView reloadData];
    
    NSLog(@"Data from elvc %@", self.statStore.userSelections);
}

@end
