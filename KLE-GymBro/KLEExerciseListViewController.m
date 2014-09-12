//
//  KLEExerciseListViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/11/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEExerciseListViewCell.h"
#import "KLEStat.h"
#import "KLEStatStore.h"
#import "KLEExerciseListViewController.h"

@interface KLEExerciseListViewController ()

@property (nonatomic, copy) NSMutableArray *exerciseArray;

@end

@implementation KLEExerciseListViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        _exerciseArray = [NSMutableArray arrayWithObjects:@[
                                                            @[@"Bench Press", @"Chest"],
                                                            @[@"Squats", @"Legs"],
                                                            @[@"Arm Curls", @"Arms"]
                                                                                        ], nil];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
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
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLEExerciseListViewCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLEExerciseListViewCell"];
    
}

@end
