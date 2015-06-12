//
//  KLERoutineExerciseDetailTableViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/16/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEAppDelegate.h"
#import "KLEUtility.h"
#import "KLEWeightControl.h"
#import "KLEExercise.h"
#import "KLEExerciseGoal.h"
#import "KLERoutineExerciseDetailTableViewController.h"

@interface KLERoutineExerciseDetailTableViewController () <UIViewControllerRestoration>

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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"INIT EXERCISE DETAIL");
        
        // restoration ID is set in storyboard, restoration class needs to be set here so UIViewControllerRestoration methods will run
        self.restorationClass = [self class];
    }
    return self;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSURL *routineExerciseURI = [[self.selectedRoutineExercise objectID] URIRepresentation];
    [coder encodeObject:routineExerciseURI forKey:kSelectedExerciseDetailIDKey];
    
    [coder encodeObject:_weightControl.weightIncrementLabel.text forKey:kWeightSliderLabelTextExerciseDetailKey];
    [coder encodeObject:_setsLabel.text forKey:kSetsSliderLabelTextExerciseDetailKey];
    [coder encodeObject:_repsLabel.text forKey:kRepsSliderLabelTextExerciseDetailKey];
    
    [coder encodeObject:_weightControl.weightTextField.text forKey:kWeightTextExerciseDetailKey];
    NSNumber *weightSliderValue = [NSNumber numberWithFloat:_weightControl.weightIncrementSlider.value];
    NSNumber *setsSliderValue = [NSNumber numberWithFloat:_setsSlider.value];
    NSNumber *repsSliderValue = [NSNumber numberWithFloat:_repsSlider.value];
    NSNumber *setsSegmentControlIndex = [NSNumber numberWithInteger:_setsSegment.selectedSegmentIndex];
    NSNumber *repsSegmentControlIndex = [NSNumber numberWithInteger:_repsSegment.selectedSegmentIndex];
    
    [coder encodeObject:weightSliderValue forKey:kWeightSliderValueExerciseDetailKey];
    [coder encodeObject:setsSliderValue forKey:kSetsSliderValueExerciseDetailKey];
    [coder encodeObject:repsSliderValue forKey:kRepsSliderValueExerciseDetailKey];
    [coder encodeObject:setsSegmentControlIndex forKey:kSetsSegmentControlIndexExerciseDetailKey];
    [coder encodeObject:repsSegmentControlIndex forKey:kRepsSegmentControlIndexExerciseDetailKey];
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *weightFieldText = [coder decodeObjectForKey:kWeightTextExerciseDetailKey];
    NSNumber *weightSliderValue = [coder decodeObjectForKey:kWeightSliderValueExerciseDetailKey];
    NSNumber *setsSliderValue = [coder decodeObjectForKey:kSetsSliderValueExerciseDetailKey];
    NSNumber *repsSliderValue = [coder decodeObjectForKey:kRepsSliderValueExerciseDetailKey];
    NSNumber *setsSegmentControlIndex = [coder decodeObjectForKey:kSetsSegmentControlIndexExerciseDetailKey];
    NSNumber *repsSegmentControlIndex = [coder decodeObjectForKey:kRepsSegmentControlIndexExerciseDetailKey];
    
    _weightControl.weightTextField.text = weightFieldText;
    _weightControl.weightIncrementSlider.value = [weightSliderValue floatValue];
    _setsSlider.value = [setsSliderValue floatValue];
    _repsSlider.value = [repsSliderValue floatValue];
    _setsSegment.selectedSegmentIndex = [setsSegmentControlIndex integerValue];
    _repsSegment.selectedSegmentIndex = [repsSegmentControlIndex integerValue];
    [self setsSegmentControl:_setsSegment];
    [self repsSegmentControl:_repsSegment];
    
    _weightControl.weightIncrementLabel.text = [coder decodeObjectForKey:kWeightSliderLabelTextExerciseDetailKey];
    _setsLabel.text = [coder decodeObjectForKey:kSetsSliderLabelTextExerciseDetailKey];
    _repsLabel.text = [coder decodeObjectForKey:kRepsSliderLabelTextExerciseDetailKey];
    
    [super decodeRestorableStateWithCoder:coder];
    
    NSLog(@"DECODE");
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"KLEStoryBoard" bundle:nil];
    KLERoutineExerciseDetailTableViewController *routineExerciseDetailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"RoutineExerciseDetail"];
    
    NSURL *routineExerciseURI = [coder decodeObjectForKey:kSelectedExerciseDetailIDKey];
    CoreDataAccess *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSManagedObjectID *routineExerciseID = [[cdh.context persistentStoreCoordinator] managedObjectIDForURIRepresentation:routineExerciseURI];
    
    KLEExerciseGoal *selectedExercise = (KLEExerciseGoal *)[cdh.context existingObjectWithID:routineExerciseID error:nil];
    routineExerciseDetailViewController.selectedRoutineExercise = selectedExercise;
    
    return routineExerciseDetailViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveChanges)];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    // setup sets slider
    [_setsSlider setMinimumValue:1];
    [_setsSlider setMaximumValue:100];
    [_setsSlider setValue:5];
    [_setsSegment setSelectedSegmentIndex:3];
    _setStepAmount = 5;
    
    // setup reps slider
    [_repsSlider setMinimumValue:1];
    [_repsSlider setMaximumValue:100];
    [_repsSlider setValue:5];
    [_repsSegment setSelectedSegmentIndex:3];
    _repStepAmount = 5;
    
    
    // custom title for navigation title
    NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:_selectedRoutineExercise.exercise.exercisename attributes:@{ NSFontAttributeName : [KLEUtility getFontFromFontFamilyWithSize:18.0], NSUnderlineStyleAttributeName : @0, NSBackgroundColorAttributeName : [UIColor clearColor] }];
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
    
    [self loadExerciseData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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

- (void)changeSliderStepAmount:(UISlider *)slider stepAmount:(NSUInteger)amount
{

    NSUInteger sliderValue = (NSUInteger)slider.value;
    NSUInteger newValue = amount * floorf((sliderValue / amount) + 0.5);
    [slider setValue:newValue animated:NO];

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
            NSLog(@"Step Amount %lu", (unsigned long)_setStepAmount);
            break;
        case 1:
            _setStepAmount = 2;
            NSLog(@"Step Amount %lu", (unsigned long)_setStepAmount);
            break;
        case 2:
            _setStepAmount = 3;
            NSLog(@"Step Amount %lu", (unsigned long)_setStepAmount);
            break;
        case 3:
            _setStepAmount = 5;
            NSLog(@"Step Amount %lu", (unsigned long)_setStepAmount);
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
            NSLog(@"Step Amount %lu", (unsigned long)_repStepAmount);
            break;
        case 1:
            _repStepAmount = 2;
            NSLog(@"Step Amount %lu", (unsigned long)_repStepAmount);
            break;
        case 2:
            _repStepAmount = 3;
            NSLog(@"Step Amount %lu", (unsigned long)_repStepAmount);
            break;
        case 3:
            _repStepAmount = 5;
            NSLog(@"Step Amount %lu", (unsigned long)_repStepAmount);
            break;
        default:
            break;
    }
}
@end
