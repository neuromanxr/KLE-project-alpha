//
//  KLEDailyViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/6/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEDailyViewCell.h"
#import "KLEStat.h"
#import "KLEStatStore.h"
#import "KLEDailyViewController.h"
#import "KLERoutineViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation KLEDailyViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        for (int i = 0; i < 10; i++) {
            [[KLEStatStore sharedStore] createStat];
        }
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)addWorkout
{
    KLERoutineViewController *rvc = [[KLERoutineViewController alloc] init];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor redColor];
    UIViewController *stats = [[UIViewController alloc] init];
    stats.view = view;
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    tbc.viewControllers = @[rvc, stats];
    
    [self.navigationController pushViewController:tbc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[KLEStatStore sharedStore] allStats] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLERoutineViewController *rvc = [[KLERoutineViewController alloc] init];
    
    [self.navigationController pushViewController:rvc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create an instance of UITableViewCell, with default appearance
    KLEDailyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLEDailyViewCell" forIndexPath:indexPath];
    
    NSArray *statsArray = [[KLEStatStore sharedStore] allStats];
    KLEStat *stat = statsArray[indexPath.row];
    
    cell.dayLabel.text = [stat description];
    [cell.exerciseButton addTarget:self action:@selector(addWorkout) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLEDailyViewCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLEDailyViewCell"];
}

@end
