//
//  KLEHistoryDetailTableViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/13/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
#import "KLEExerciseCompleted.h"
#import "KLEHistoryDetailTableViewController.h"
#import "KLEWeightControl.h"

@interface KLEHistoryDetailTableViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

//@property (nonatomic, copy) NSMutableArray *tempRepsWeightArray;

@property (nonatomic, copy) NSMutableArray *repsCompletedArray;
@property (nonatomic, copy) NSMutableArray *weightCompletedArray;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateCompletedPicker;
- (IBAction)dateCompletedAction:(UIDatePicker *)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *setsCompletedPicker;
@property (strong, nonatomic) IBOutlet UILabel *repsCompletedLabel;

@property (strong, nonatomic) IBOutlet UISlider *repsCompletedSlider;
- (IBAction)repsCompletedSliderAction:(UISlider *)sender;

@property (strong, nonatomic) IBOutlet KLEWeightControl *weightControl;
- (IBAction)saveSetButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *saveSetButton;

@property (nonatomic, assign) NSUInteger currentSetIndex;

@end

@implementation KLEHistoryDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self seperateStringsInRepsWeightArray];
    
    self.navigationItem.title = _selectedExerciseCompleted.exercisename;
    
    _setsCompletedPicker.delegate = self;
    _setsCompletedPicker.dataSource = self;
    
    _weightControl.weightTextField.delegate = self;
    _weightControl.weightTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self pickerView:_setsCompletedPicker didSelectRow:0 inComponent:0];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEditSave:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_saveSetButton setEnabled:NO];
    [_saveSetButton setAlpha:0.3];
    [_repsCompletedLabel setAlpha:0.3];
    [_repsCompletedSlider setEnabled:NO];
    [_weightControl setEnabled:NO];
    [_weightControl setAlpha:0.3];
    [_dateCompletedPicker setAlpha:0.3];
    [_dateCompletedPicker setUserInteractionEnabled:NO];
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

- (NSArray *)combineStringsToRepsWeightArray
{
    NSMutableArray *combinedStringsArray = _repsCompletedArray;
    
    [combinedStringsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *repsString = obj;
        NSString *repsWeightString = [repsString stringByAppendingFormat:@" %@",[_weightCompletedArray objectAtIndex:idx]];
        
        [combinedStringsArray replaceObjectAtIndex:idx withObject:repsWeightString];
        
        NSLog(@"ITERATE REPS WEIGHT STRINGS %@", repsWeightString);
    }];
    
    NSLog(@"COMBINED ARRAY %@", combinedStringsArray);
    
    return combinedStringsArray;
}

- (void)toggleEditSave:(UIBarButtonItem *)sender
{
    NSLog(@"BAR BUTTON STYLE %lu", sender.style);
    if (sender.style == UIBarButtonItemStylePlain) {
        NSLog(@"EDIT");
        
        [_saveSetButton setEnabled:YES];
        [_saveSetButton setAlpha:1.0];
        [_repsCompletedLabel setAlpha:1.0];
        [_repsCompletedSlider setEnabled:YES];
        [_weightControl setEnabled:YES];
        [_weightControl setAlpha:1.0];
        [_dateCompletedPicker setUserInteractionEnabled:YES];
        [_dateCompletedPicker setAlpha:1.0];
        
        [sender setStyle:UIBarButtonItemStyleDone];
        [sender setTitle:@"Save"];
    }
    else
    {
        NSLog(@"ELSE STYLE %lu", sender.style);
        
        [sender setStyle:UIBarButtonItemStylePlain];
        [sender setTitle:@"Edit"];
        
        // save the new date
        _selectedExerciseCompleted.datecompleted = _dateCompletedPicker.date;
        
        // combine the reps and weight into new array then save the new reps weight array
        _selectedExerciseCompleted.repsweightarray = [self combineStringsToRepsWeightArray];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    _weightControl.weightTextField.text = weightCompleted;
    _dateCompletedPicker.date = _selectedExerciseCompleted.datecompleted;
    
    [_repsCompletedSlider setValue:[repsCompleted integerValue]];
    
    _currentSetIndex = row;
    
    // run animation only when button is enabled
    if (_saveSetButton.isEnabled) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAutoreverse animations:^{
            _saveSetButton.transform = CGAffineTransformMakeScale(1.25f, 1.25f);
        } completion:^(BOOL finished) {
            _saveSetButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }];
    }
    
    NSLog(@"Current Set Index %lu", _currentSetIndex);
    
    NSLog(@"WEIGHT CONTROL %@", _weightControl.weightTextField.text);
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;

    [headerView.textLabel setFont:[KLEUtility getFontFromFontFamilyWithSize:17.0]];
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
    return NO;
}
*/
 
// Override to support editing the table view.
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"EDITING STYLE %lu", editingStyle);
    if (editingStyle == UITableViewCellEditingStyleNone) {
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"BEGAN EDITING");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"END EDITING");
//    _selectedExerciseCompleted.reps = [NSNumber numberWithInteger:[_weightControl.weightTextField.text integerValue]];
//    NSLog(@"NEW WEIGHT %@", _selectedRoutineExercise.weight);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)dateCompletedAction:(UIDatePicker *)sender
{
    NSLog(@"Date Completed %@", sender.date);
}
- (IBAction)repsCompletedSliderAction:(UISlider *)sender
{
    NSLog(@"REPS COMPLETED SLIDER ACTION %lu", [_setsCompletedPicker selectedRowInComponent:0] + 1);
    
    _repsCompletedLabel.text = [NSString stringWithFormat:@"%.f", sender.value];
}

- (IBAction)saveSetButton:(UIButton *)sender
{
    // replace the old values with new values in the array
    
    NSLog(@"SAVE SET REPS %@ : WEIGHT %@", _repsCompletedArray[_currentSetIndex], _weightCompletedArray[_currentSetIndex]);
    
    [_repsCompletedArray replaceObjectAtIndex:_currentSetIndex withObject:_repsCompletedLabel.text];
    [_weightCompletedArray replaceObjectAtIndex:_currentSetIndex withObject:_weightControl.weightTextField.text];
    NSLog(@"NEW COMPLETE REPS ARRAY %@ AND WEIGHT ARRAY %@", _repsCompletedArray, _weightCompletedArray);
    
}

@end
