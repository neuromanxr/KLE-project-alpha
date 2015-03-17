//
//  KLERoutineExerciseDetailTableViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/16/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEWeightControl.h"
#import "KLEExercise.h"
#import "KLEExerciseGoal.h"
#import "KLERoutineExerciseDetailTableViewController.h"

@interface KLERoutineExerciseDetailTableViewController ()

@property (weak, nonatomic) IBOutlet KLEWeightControl *weightControl;

@property (weak, nonatomic) IBOutlet UILabel *setsLabel;
@property (weak, nonatomic) IBOutlet UISlider *setsSlider;
- (IBAction)setsSliderAction:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UILabel *repsLabel;
@property (weak, nonatomic) IBOutlet UISlider *repsSlider;
- (IBAction)repsSliderAction:(UISlider *)sender;

@end

@implementation KLERoutineExerciseDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = _selectedRoutineExercise.exercise.exercisename;
    
    [self loadExerciseData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _selectedRoutineExercise.weight = [NSNumber numberWithFloat:[self.weightControl.weightTextField.text floatValue]];
    _selectedRoutineExercise.sets = [NSNumber numberWithInteger:[self.setsLabel.text integerValue]];
    _selectedRoutineExercise.reps = [NSNumber numberWithInteger:[self.repsLabel.text integerValue]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadExerciseData
{
    if (_selectedRoutineExercise)
    {
        
        self.weightControl.weightTextField.text = [NSString stringWithFormat:@"%@", _selectedRoutineExercise.weight];
        
        self.setsSlider.value = [_selectedRoutineExercise.sets integerValue];
        self.setsLabel.text = [NSString stringWithFormat:@"%.f", _setsSlider.value];
        
        self.repsSlider.value = [_selectedRoutineExercise.reps integerValue];
        self.repsLabel.text = [NSString stringWithFormat:@"%.f", _repsSlider.value];
    }
    else
    {
        NSLog(@"NO DATA");
    }
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    NSArray *fontFamily = [UIFont fontNamesForFamilyName:@"Heiti TC"];
    [headerView.textLabel setFont:[UIFont fontWithName:[fontFamily firstObject] size:17.0]];
}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
*/

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SLIDERS

- (IBAction)setsSliderAction:(UISlider *)sender
{
    _setsLabel.text = [NSString stringWithFormat:@"%.f", sender.value];
}
- (IBAction)repsSliderAction:(UISlider *)sender
{
    _repsLabel.text = [NSString stringWithFormat:@"%.f", sender.value];
}
@end
