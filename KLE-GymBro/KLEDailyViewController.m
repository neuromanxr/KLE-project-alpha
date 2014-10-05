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

#define COMMENT_LABEL_WIDTH 230
#define COMMENT_LABEL_MIN_HEIGHT 65
#define COMMENT_LABEL_PADDING 10

@interface KLEDailyViewController ()

// daily view header
@property (strong, nonatomic) IBOutlet UIView *dailyHeaderView;
@property (strong, nonatomic) IBOutlet UIView *dailyFooterView;
@property (weak, nonatomic) IBOutlet UILabel *headerDayLabel;
@property (weak, nonatomic) IBOutlet UIButton *footerAddButton;

@end

@implementation KLEDailyViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {

    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(CGFloat)getLabelHeightForIndex:(NSInteger)index
{
//    CGSize maximumSize = CGSizeMake(COMMENT_LABEL_WIDTH, 10000);
    
//    CGSize labelHeightSize = [[textArray objectAtIndex:index]
//                             sizeWithFont: [UIFont fontWithName:@"Helvetica" size:14.0f]
//                        constrainedToSize:maximumSize
//                            lineBreakMode:NSLineBreakByWordWrapping];
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
    NSLog(@"Add button tapped in section %lu", btn.tag);
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
    return 2;
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
    if ([self getLabelHeightForIndex:indexPath.row] > COMMENT_LABEL_MIN_HEIGHT) {
        return indexPath;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // is the selected cell expanded? Then minimize it
    if (selectedIndex == indexPath.row) {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return;
    }
    
    // is there a cell already expanded? Then make sure it is reloaded to minimize it back
    if (selectedIndex >= 0) {
        NSIndexPath *previousPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    // set the selected index to the new selection and reload it to expand
    selectedIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create an instance of UITableViewCell, with default appearance
    KLEDailyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLEDailyViewCell" forIndexPath:indexPath];
    
//    NSArray *statsArray = [[KLEStatStore sharedStore] allStats];
//    KLEStat *stat = statsArray[indexPath.row];
    
//    cell.dayLabel.text = [stat description];
    [cell.exerciseButton addTarget:self action:@selector(addWorkout) forControlEvents:UIControlEventTouchUpInside];
    
    if (selectedIndex == indexPath.row) {
        CGFloat labelHeight = [self getLabelHeightForIndex:indexPath.row];
        cell.dayLabel.frame = CGRectMake(cell.dayLabel.frame.origin.x, cell.dayLabel.frame.origin.y, cell.dayLabel.frame.size.width, labelHeight);
    } else {
        // otherwise return the minimum height
        cell.dayLabel.frame = CGRectMake(cell.dayLabel.frame.origin.x, cell.dayLabel.frame.origin.y, cell.dayLabel.frame.size.width, COMMENT_LABEL_MIN_HEIGHT);
    }
    cell.dayLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    cell.dayLabel.text = @"Day";
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLEDailyViewCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLEDailyViewCell"];
    
    ////
    selectedIndex = -1;
    
    textArray = [[NSMutableArray alloc] init];
    
    NSString *testString;
    
    for (int i = 0; i < 7; i++) {
        testString = @"Test comment. Test comment.";

        [textArray addObject:testString];
    }
    
    daysArray = [[NSArray alloc] initWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];

}

@end
