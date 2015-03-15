//
//  KLEHistoryDetailTableViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/13/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//
#import "KLEExerciseCompleted.h"
#import "KLEHistoryDetailTableViewController.h"
#import "KLEWeightControl.h"

@interface KLEHistoryDetailTableViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, copy) NSMutableArray *repsCompletedArray;
@property (nonatomic, copy) NSMutableArray *weightCompletedArray;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateCompletedPicker;
- (IBAction)dateCompletedAction:(UIDatePicker *)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *setsCompletedPicker;
@property (strong, nonatomic) IBOutlet UILabel *repsCompletedLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightCompletedLabel;

@property (strong, nonatomic) IBOutlet UISlider *repsCompletedSlider;
- (IBAction)repsCompletedSliderAction:(UISlider *)sender;

@property (strong, nonatomic) IBOutlet UISlider *weightCompletedSlider;
- (IBAction)weightCompletedSliderAction:(UISlider *)sender;

@end

@implementation KLEHistoryDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self seperateStringsInRepsWeightArray];
    
    self.navigationItem.title = _selectedExerciseCompleted.exercisename;
    
    _setsCompletedPicker.delegate = self;
    _setsCompletedPicker.dataSource = self;
    
    [self pickerView:_setsCompletedPicker didSelectRow:0 inComponent:0];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)seperateStringsInRepsWeightArray
{
    _repsCompletedArray = [NSMutableArray new];
    _weightCompletedArray = [NSMutableArray new];
    NSArray *repsWeightArray = _selectedExerciseCompleted.repsweightarray;
    
    for (NSString *repsWeightString in repsWeightArray) {
        [_repsCompletedArray addObject:[[repsWeightString componentsSeparatedByString:@" "] firstObject]];
        [_weightCompletedArray addObject:[[repsWeightString componentsSeparatedByString:@" "] lastObject]];
        
    }
    
    NSLog(@"REPS COMPLETED ARRAY IN HISTORY DETAIL %@, weight completed %@", _repsCompletedArray, _weightCompletedArray);
}

- (void)setupExerciseCompletedData
{
    [_selectedExerciseCompleted.repsweightarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
    }];
}

#pragma mark - Picker view data source

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    
    label.text = [NSString stringWithFormat:@"%lu", row + 1];
    
    return label;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_selectedExerciseCompleted.setscompleted integerValue];
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return @"TITLE";
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *repsCompleted = _repsCompletedArray[row];
    NSString *weightCompleted = _weightCompletedArray[row];
    
    _repsCompletedLabel.text = repsCompleted;
    _weightCompletedLabel.text = weightCompleted;
    
    [_repsCompletedSlider setValue:[repsCompleted integerValue]];
    [_weightCompletedSlider setValue:[weightCompleted floatValue]];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    NSArray *fontFamily = [UIFont fontNamesForFamilyName:@"Heiti TC"];
    [headerView.textLabel setFont:[UIFont fontWithName:[fontFamily firstObject] size:17.0]];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"" forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}


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

- (IBAction)dateCompletedAction:(UIDatePicker *)sender
{
    NSLog(@"Date Completed %@", sender.date);
}
- (IBAction)repsCompletedSliderAction:(UISlider *)sender
{
    NSLog(@"REPS COMPLETED SLIDER ACTION %lu", [_setsCompletedPicker selectedRowInComponent:0] + 1);
    
    _repsCompletedLabel.text = [NSString stringWithFormat:@"%.f", sender.value];
}
- (IBAction)weightCompletedSliderAction:(UISlider *)sender
{
    _weightCompletedLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
}
@end
