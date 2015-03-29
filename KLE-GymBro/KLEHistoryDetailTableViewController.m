//
//  KLEHistoryDetailTableViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/13/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//
#import "KLEExercise.h"
#import "KLEAppDelegate.h"
#import "KLEUtility.h"
#import "KLEExerciseCompleted.h"
#import "KLEHistoryDetailTableViewController.h"
#import "KLEWeightControl.h"

@interface KLEHistoryDetailTableViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UIViewControllerRestoration>

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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"INIT HISTORY DETAIL");
        
        // restoration ID is set in storyboard, restoration class needs to be set here so UIViewControllerRestoration methods will run
        self.restorationClass = [self class];
    }
    return self;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSURL *exerciseCompletedURI = [[self.selectedExerciseCompleted objectID] URIRepresentation];
    [coder encodeObject:exerciseCompletedURI forKey:kSelectedExerciseCompletedKey];
    
    [super encodeRestorableStateWithCoder:coder];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"KLEStoryBoard" bundle:nil];
    KLEHistoryDetailTableViewController *historyDetailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"HistoryDetail"];
    
    NSURL *exerciseCompletedURI = [coder decodeObjectForKey:kSelectedExerciseCompletedKey];
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSManagedObjectID *exerciseCompletedID = [[cdh.context persistentStoreCoordinator] managedObjectIDForURIRepresentation:exerciseCompletedURI];
    
    KLEExerciseCompleted *exerciseCompleted = (KLEExerciseCompleted *)[cdh.context existingObjectWithID:exerciseCompletedID error:nil];
    historyDetailViewController.selectedExerciseCompleted = exerciseCompleted;
    
    return historyDetailViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self seperateStringsInRepsWeightArray];
    
    // custom title for navigation title
    NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:_selectedExerciseCompleted.exercise.exercisename attributes:@{ NSFontAttributeName : [KLEUtility getFontFromFontFamilyWithSize:18.0], NSUnderlineStyleAttributeName : @0, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    // custom title for navigation title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 0;
    title.attributedText = attribString;
    title.adjustsFontSizeToFitWidth = YES;
    title.minimumScaleFactor = 0.5;
    [title sizeToFit];
    [self.navigationItem setTitleView:title];
    
    _setsCompletedPicker.delegate = self;
    _setsCompletedPicker.dataSource = self;
    
    [_saveSetButton setEnabled:NO];
    [_saveSetButton setAlpha:0.3];
    [_repsCompletedLabel setAlpha:0.3];
    [_repsCompletedSlider setEnabled:NO];
    [_weightControl setEnabled:NO];
    [_weightControl setAlpha:0.3];
    [_dateCompletedPicker setAlpha:0.3];
    [_dateCompletedPicker setUserInteractionEnabled:NO];
    
    [self pickerView:_setsCompletedPicker didSelectRow:0 inComponent:0];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEditSave:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
    
    label.text = [NSString stringWithFormat:@"%lu", (unsigned long)row + 1];
    [label setFont:[KLEUtility getFontFromFontFamilyWithSize:16.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *repsCompleted = _repsCompletedArray[row];
    NSString *weightCompleted = _weightCompletedArray[row];
    
    _repsCompletedLabel.text = repsCompleted;
    _weightControl.weightTextField.text = weightCompleted;
    _weightControl.rightWeightLabel.text = _selectedExerciseCompleted.weightunit;
    _dateCompletedPicker.date = _selectedExerciseCompleted.datecompleted;
    
    [_repsCompletedSlider setValue:[repsCompleted integerValue]];
    
    _currentSetIndex = row;
    
    // run animation only when button is enabled
    if (_saveSetButton.isEnabled) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAutoreverse animations:^{
            _saveSetButton.transform = CGAffineTransformMakeScale(1.25f, 1.25f);
        } completion:^(BOOL finished) {
            _saveSetButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }];
    }
    
//    NSLog(@"Current Set Index %lu", _currentSetIndex);
    
//    NSLog(@"WEIGHT CONTROL %@", _weightControl.weightTextField.text);
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;

    [headerView.textLabel setFont:[KLEUtility getFontFromFontFamilyWithSize:17.0]];
}

- (IBAction)dateCompletedAction:(UIDatePicker *)sender
{
    NSLog(@"Date Completed %@", sender.date);
}
- (IBAction)repsCompletedSliderAction:(UISlider *)sender
{
//    NSLog(@"REPS COMPLETED SLIDER ACTION %lu", [_setsCompletedPicker selectedRowInComponent:0] + 1);
    
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
