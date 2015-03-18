//
//  KLERoutineExerciseDetailTableViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/16/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
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

- (IBAction)setsSegmentControl:(UISegmentedControl *)sender;
- (IBAction)repsSegmentControl:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *setsSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *repsSegment;

@property (nonatomic, assign) NSUInteger setStepAmount;
@property (nonatomic, assign) NSUInteger repStepAmount;

@end

@implementation KLERoutineExerciseDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveChanges)];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    _weightControl.weightTextField.delegate = self;
    [_weightControl.weightTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    
    // setup sets slider
    [_setsSlider setMinimumValue:1];
    [_setsSlider setMaximumValue:100];
    [_setsSlider setValue:5];
    [_setsSegment setSelectedSegmentIndex:3];
    _setStepAmount = 5;
    _setsSlider.tag = kSetsSliderTag;
    
    // setup reps slider
    [_repsSlider setMinimumValue:1];
    [_repsSlider setMaximumValue:100];
    [_repsSlider setValue:5];
    [_repsSegment setSelectedSegmentIndex:3];
    _repStepAmount = 5;
    _repsSlider.tag = kRepsSliderTag;
    
    self.navigationItem.title = _selectedRoutineExercise.exercise.exercisename;
    
    [self loadExerciseData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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

- (void)saveChanges
{
    _selectedRoutineExercise.weight = [NSNumber numberWithFloat:[self.weightControl.weightTextField.text floatValue]];
    _selectedRoutineExercise.sets = [NSNumber numberWithInteger:[self.setsLabel.text integerValue]];
    _selectedRoutineExercise.reps = [NSNumber numberWithInteger:[self.repsLabel.text integerValue]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kExerciseGoalChangedNote object:_selectedRoutineExercise];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    [headerView.textLabel setFont:[KLEUtility getFontFromFontFamilyWithSize:17.0]];
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
#warning math error
- (void)changeSliderStepAmount:(UISlider *)slider stepAmount:(NSUInteger)amount
{

    NSUInteger sliderValue = (NSUInteger)slider.value;
    NSUInteger newValue = amount * floorf((sliderValue / amount) + 0.5);
    [slider setValue:newValue animated:NO];
    
//    switch (slider.tag) {
//        case kSetsSliderTag:
//            _setsLabel.text = [NSString stringWithFormat:@"%.f", slider.value];
//            break;
//        case kRepsSliderTag:
//            _repsLabel.text = [NSString stringWithFormat:@"%.f", slider.value];
//            break;
//        default:
//            break;
//    }
    
}

#pragma mark - TEXTFIELD DELEGATE

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"BEGAN EDITING");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"END EDITING");

    _selectedRoutineExercise.weight = [NSNumber numberWithInteger:[_weightControl.weightTextField.text integerValue]];
    NSLog(@"NEW WEIGHT %@", _selectedRoutineExercise.weight);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - SETS, REPS SLIDERS

- (IBAction)setsSliderAction:(UISlider *)sender
{
    [self changeSliderStepAmount:sender stepAmount:_setStepAmount];
    _setsLabel.text = [NSString stringWithFormat:@"%.f", sender.value];
}
- (IBAction)repsSliderAction:(UISlider *)sender
{
    [self changeSliderStepAmount:sender stepAmount:_repStepAmount];
    _repsLabel.text = [NSString stringWithFormat:@"%.f", sender.value];
}

#pragma mark - SETS, REPS SEGMENT CONTROLS

- (IBAction)setsSegmentControl:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            _setStepAmount = 1;
            NSLog(@"Step Amount %lu", _setStepAmount);
            break;
        case 1:
            _setStepAmount = 2;
            NSLog(@"Step Amount %lu", _setStepAmount);
            break;
        case 2:
            _setStepAmount = 3;
            NSLog(@"Step Amount %lu", _setStepAmount);
            break;
        case 3:
            _setStepAmount = 5;
            NSLog(@"Step Amount %lu", _setStepAmount);
            break;
        default:
            break;
    }
}

- (IBAction)repsSegmentControl:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            _repStepAmount = 1;
            NSLog(@"Step Amount %lu", _repStepAmount);
            break;
        case 1:
            _repStepAmount = 2;
            NSLog(@"Step Amount %lu", _repStepAmount);
            break;
        case 2:
            _repStepAmount = 3;
            NSLog(@"Step Amount %lu", _repStepAmount);
            break;
        case 3:
            _repStepAmount = 5;
            NSLog(@"Step Amount %lu", _repStepAmount);
            break;
        default:
            break;
    }
}
@end
