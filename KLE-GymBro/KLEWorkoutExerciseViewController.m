//
//  KLEWorkoutExerciseViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
#import "DateTools.h"
#import "KLEAppDelegate.h"
#import "CoreDataTableViewController.h"
#import "KLEWorkoutExerciseViewController.h"
#import "KLEExerciseCompleted.h"
#import "KLEExerciseGoal.h"
#import "KLEExercise.h"
#import "KLERoutine.h"
#import "KLEWeightControl.h"

@interface KLEWorkoutExerciseViewController () <UIViewControllerRestoration>

@property (nonatomic, copy) NSMutableArray *currentRepsWeightArray;
@property (nonatomic, copy) NSArray *weightIncrementNumbers;
@property (nonatomic, assign) NSUInteger currentSet;

@property (strong, nonatomic) IBOutlet KLEWeightControl *weightControl;

@end

@implementation KLEWorkoutExerciseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"WORKOUT INIT");
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    return self;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    
    NSURL *routineExerciseID = [[self.selectedRoutineExercise objectID] URIRepresentation];
    [coder encodeObject:routineExerciseID forKey:kSelectedExerciseIDKey];
    
    // current set in workout screen
    NSNumber *currentSet = [NSNumber numberWithInteger:_currentSet];
    [coder encodeObject:currentSet forKey:kCurrentSetInWorkoutViewKey];
    
    // current set in workout button
    [coder encodeObject:_setsWorkoutButton.currentSet forKey:kCurrentSetInWorkoutButtonKey];
    
    [coder encodeObject:_currentRepsWeightArray forKey:kCurrentRepsWeightArrayKey];
    [coder encodeObject:_workoutFeedLabel.text forKey:kWorkoutFeedTextKey];
    [coder encodeObject:_weightControl.weightTextField.text forKey:kWeightTextKey];
    NSLog(@"ENCODE workout feed %@", _workoutFeedLabel.text);
    
    NSNumber *weightSliderValue = [NSNumber numberWithInteger:_weightControl.weightIncrementSlider.value];
    [coder encodeObject:weightSliderValue forKey:kWeightSliderValueKey];
    
    [coder encodeObject:_repsWorkoutButton.repsLabel.text forKey:kRepsValueKey];
    // encode ring angle for sets workout button
    NSNumber *ringAngle = [NSNumber numberWithFloat:_setsWorkoutButton.ringAngle];
    [coder encodeObject:ringAngle forKey:kSetsProgressRingAngle];
    // encode sets workout button
    [coder encodeObject:_setsWorkoutButton.setsForAngle forKey:kSetsForAngle];
    [coder encodeObject:_setsWorkoutButton.setsButton.titleLabel.text forKey:kSetsButtonTitle];
    
    // encode button states
    NSNumber *setsButtonEnabledBool = [NSNumber numberWithBool:_setsWorkoutButton.setsButton.enabled];
    NSNumber *setsButtonAlpha = [NSNumber numberWithFloat:_setsWorkoutButton.alpha];
    [coder encodeObject:setsButtonEnabledBool forKey:kSetsButtonEnabledBoolKey];
    [coder encodeObject:setsButtonAlpha forKey:kSetsButtonAlphaKey];
    
    NSNumber *repsButtonEnabledBool = [NSNumber numberWithBool:_repsWorkoutButton.enabled];
    NSNumber *repsButtonAlpha = [NSNumber numberWithFloat:_repsWorkoutButton.alpha];
    [coder encodeObject:repsButtonEnabledBool forKey:kRepsButtonEnabledBoolKey];
    [coder encodeObject:repsButtonAlpha forKey:kRepsButtonAlphaKey];
    
    NSNumber *finishButtonEnabledBool = [NSNumber numberWithBool:_finishWorkoutButton.enabled];
    NSNumber *finishButtonAlpha = [NSNumber numberWithFloat:_finishWorkoutButton.alpha];
    [coder encodeObject:finishButtonEnabledBool forKey:kFinishButtonEnabledBoolKey];
    [coder encodeObject:finishButtonAlpha forKey:kFinishButtonAlphaKey];
    
    [super encodeRestorableStateWithCoder:coder];
    
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"DECODE");
    // this runs after viewDidLoad
    
    NSMutableArray *repsWeightArray = [NSMutableArray arrayWithArray:[coder decodeObjectForKey:kCurrentRepsWeightArrayKey]];
    NSString *workoutFeedText = [coder decodeObjectForKey:kWorkoutFeedTextKey];
    NSString *weightFieldText = [coder decodeObjectForKey:kWeightTextKey];
    NSString *repsLabelText = [coder decodeObjectForKey:kRepsValueKey];
    NSString *setsButtonTitleText = [coder decodeObjectForKey:kSetsButtonTitle];
    
    NSNumber *currentSetWorkoutViewNumber = [coder decodeObjectForKey:kCurrentSetInWorkoutViewKey];
    NSNumber *currentSetWorkoutButtonNumber = [coder decodeObjectForKey:kCurrentSetInWorkoutButtonKey];
    
    NSNumber *weightSliderNumber = [coder decodeObjectForKey:kWeightSliderValueKey];
    NSNumber *ringAngleNumber = [coder decodeObjectForKey:kSetsProgressRingAngle];
    NSNumber *setsForAngle = [coder decodeObjectForKey:kSetsForAngle];
    
    // decode button states
    NSNumber *setsButtonEnabledBool = [coder decodeObjectForKey:kSetsButtonEnabledBoolKey];
    NSNumber *setsButtonAlpha = [coder decodeObjectForKey:kSetsButtonAlphaKey];
    
    NSNumber *repsButtonEnabledBool = [coder decodeObjectForKey:kRepsButtonEnabledBoolKey];
    NSNumber *repsButtonAlpha = [coder decodeObjectForKey:kRepsButtonAlphaKey];
    
    NSNumber *finishButtonEnabledBool = [coder decodeObjectForKey:kFinishButtonEnabledBoolKey];
    NSNumber *finishButtonAlpha = [coder decodeObjectForKey:kFinishButtonAlphaKey];
    
    
    _currentRepsWeightArray = repsWeightArray;
    _weightControl.weightTextField.text = weightFieldText;
    _setsWorkoutButton.setsForAngle = setsForAngle;
    [_setsWorkoutButton.setsButton setTitle:setsButtonTitleText forState:UIControlStateNormal];
    _workoutFeedLabel.text = workoutFeedText;
    
    // current set in workout screen
    _currentSet = [currentSetWorkoutViewNumber integerValue];
    
    // current set in workout button
    _setsWorkoutButton.currentSet = currentSetWorkoutButtonNumber;
    
    _weightControl.weightIncrementSlider.value = [weightSliderNumber floatValue];
    _setsWorkoutButton.ringAngle = [ringAngleNumber floatValue];
    _repsWorkoutButton.repsLabel.text = repsLabelText;
    
    // button states
    [_setsWorkoutButton.setsButton setEnabled:[setsButtonEnabledBool boolValue]];
    [_setsWorkoutButton setAlpha:[setsButtonAlpha floatValue]];
    
    [_repsWorkoutButton setEnabled:[repsButtonEnabledBool boolValue]];
    [_repsWorkoutButton setAlpha:[repsButtonAlpha floatValue]];
    
    [_finishWorkoutButton setEnabled:[finishButtonEnabledBool boolValue]];
    [_finishWorkoutButton setAlpha:[finishButtonAlpha floatValue]];
    
    
    [super decodeRestorableStateWithCoder:coder];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    KLEWorkoutExerciseViewController *workoutExerciseViewController = [[self alloc] init];
    
    NSURL *routineExerciseURI = [coder decodeObjectForKey:kSelectedExerciseIDKey];
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSManagedObjectID *routineExerciseID = [[cdh.context persistentStoreCoordinator] managedObjectIDForURIRepresentation:routineExerciseURI];
    
    KLEExerciseGoal *selectedExercise = (KLEExerciseGoal *)[cdh.context existingObjectWithID:routineExerciseID error:nil];
    workoutExerciseViewController.selectedRoutineExercise = selectedExercise;
    
    NSLog(@"selected routine exercse %@", workoutExerciseViewController.selectedRoutineExercise);
    
    
    return workoutExerciseViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.restorationIdentifier = NSStringFromClass([self class]);
    
    // custom title for navigation title
    NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:_selectedRoutineExercise.exercise.exercisename attributes:@{ NSFontAttributeName : [KLEUtility getFontFromFontFamilyWithSize:18.0], NSUnderlineStyleAttributeName : @0, NSBackgroundColorAttributeName : [UIColor clearColor] }];
//     custom title for navigation title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 0;
    title.attributedText = attribString;
    [title sizeToFit];
    [self.navigationItem setTitleView:title];
    
    // set delegate for sets workout button
    _setsWorkoutButton.delegate = self;
    
    // set delegate for reps workout button
    _repsWorkoutButton.delegate = self;
    
    _weightControl.weightTextField.delegate = self;
    [_weightControl.weightTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    
    [self setupExerciseData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSelectedExercise:) name:kExerciseGoalChangedNote object:nil];
    
    [_finishWorkoutButton addTarget:self action:@selector(finishWorkout) forControlEvents:UIControlEventTouchUpInside];
#warning tap gesture interferes with finish button
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNumberPad)];
//    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kExerciseGoalChangedNote object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dismissNumberPad
//{
//    [_weightControl.weightTextField resignFirstResponder];
//}

- (void)setupExerciseData
{
//    _weightTextField.text = [NSString stringWithFormat:@"%@", _selectedRoutineExercise.weight];
    _weightControl.weightTextField.text = [NSString stringWithFormat:@"%@", _selectedRoutineExercise.weight];
    
    _setsWorkoutButton.setsForAngle = _selectedRoutineExercise.sets;
    [_setsWorkoutButton.setsButton setTitle:[NSString stringWithFormat:@"%@", _selectedRoutineExercise.sets] forState:UIControlStateNormal];
    _repsWorkoutButton.repsLabel.text = [NSString stringWithFormat:@"%@", _selectedRoutineExercise.reps];
    
    [_finishWorkoutButton setEnabled:NO];
    [_finishWorkoutButton setAlpha:0.5];
    
    _workoutFeedLabel.text = @"Start your set then press S button";
    
}

- (NSDate *)todaysDate
{
    // date from current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSLog(@" ## TIMEZONE %@", [calendar timeZone]);
    NSDate *todaysDate = [NSDate date];
    // date components with month, day, year, hour and minute
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:todaysDate];
    
    // todays date
    NSDate *todaysDateWithComponents = [calendar dateFromComponents:components];
    
    // date format and time zone for string
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeZone = [NSTimeZone localTimeZone];
    [formatter setDateFormat:@"MM-dd-yy HH:mm"];
    
    NSLog(@"## TODAY'S DATE %@", [formatter stringFromDate:todaysDateWithComponents]);
    
    return todaysDateWithComponents;
}

- (void)finishWorkout
{
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    
    KLEExerciseGoal *exerciseGoal = _selectedRoutineExercise;
    
    KLEExerciseCompleted *exerciseCompleted = [NSEntityDescription insertNewObjectForEntityForName:@"KLEExerciseCompleted" inManagedObjectContext:cdh.context];
    
    
    // reps and weight of each set is recorded here from the currentRepsWeightArray
    
//    exerciseCompleted.repsweightarray = [[_currentRepsWeightArray reverseObjectEnumerator] allObjects];
    exerciseCompleted.repsweightarray = [NSArray arrayWithArray:_currentRepsWeightArray];
    
    // get the array then get the max weight
    NSArray *repsWeightArray = [NSArray arrayWithArray:_currentRepsWeightArray];
    NSMutableArray *weightsArray = [[NSMutableArray alloc] init];
    
    for (NSString *repsWeightString in repsWeightArray) {
        
        NSNumber *weightNumber = [NSNumber numberWithFloat:[[[repsWeightString componentsSeparatedByString:@" "] lastObject] floatValue]];
        [weightsArray addObject:weightNumber];
    }
    NSNumber *maxInWeightArray = [weightsArray valueForKeyPath:@"@max.self"];
    NSLog(@"MAX WEIGHT %@", maxInWeightArray);
    
    // date range test
//    NSDate *dateTest = [[NSDate date] dateBySubtractingMonths:12];
    
    NSLog(@"NSDATE IN FINISH WORKOUT %@", [self todaysDate]);
    exerciseCompleted.maxweight = maxInWeightArray;
    exerciseCompleted.setscompleted = [NSNumber numberWithInteger:_currentSet];
    exerciseCompleted.exercisename = exerciseGoal.exercise.exercisename;
    exerciseCompleted.routinename = exerciseGoal.routine.routinename;
    exerciseCompleted.datecompleted = [self todaysDate];
    
    _currentRepsWeightArray = nil;
    
    NSLog(@"EXERCISE COMPLETED SETS %@ REPS WEIGHT ARRAY %@", exerciseCompleted.setscompleted, exerciseCompleted.repsweightarray);
    NSLog(@"EXERCISE GOAL SETS %@ REPS %@", exerciseGoal.sets, exerciseGoal.reps);
    
    [self.navigationController popViewControllerAnimated:YES];
}

// delegate method to set the current set for sets button
- (void)currentSet:(CGFloat)set
{
    // delegate method to get the current set
    _currentSet = set;
    NSLog(@"CURRENT SET IN WORKOUT EXERCISE VIEW CONTROLLER %.2f", set);
}

// delegate method for reps button
- (void)changeRepsValue:(BOOL)buttonSwitch
{
    if (buttonSwitch)
    {
        // decrement reps value
        
        NSUInteger currentReps = [_repsWorkoutButton.repsLabel.text integerValue];
        if (currentReps != 0) {
            currentReps--;
            NSLog(@"CURRENT REPS %lu", currentReps);
            _repsWorkoutButton.repsLabel.text = [NSString stringWithFormat:@"%lu", currentReps];
        }
        else
        {
            _repsWorkoutButton.repsLabel.text = [NSString stringWithFormat:@"%lu", currentReps];
        }
    }
    else
    {
        // increment reps value
        
        NSUInteger currentReps = [_repsWorkoutButton.repsLabel.text integerValue];
        currentReps++;
        NSLog(@"CURRENT REPS %lu", currentReps);
        _repsWorkoutButton.repsLabel.text = [NSString stringWithFormat:@"%lu", currentReps];
    }
}

- (void)logCurrentSetsRepsWeight
{
    NSString *currentReps = [NSString stringWithFormat:@"%lu", [_repsWorkoutButton.repsLabel.text integerValue]];
//    NSString *currentWeight = [NSString stringWithFormat:@" %.2f", [_weightTextField.text floatValue]];
    NSString *currentWeight = [NSString stringWithFormat:@" %.2f", [_weightControl.weightTextField.text floatValue]];
    NSString *currentSet = [NSString stringWithFormat:@"%lu", _currentSet];
    
    NSLog(@"Current Reps and Sets %@, %@", currentReps, currentSet);
    
    // animate feed label text
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_workoutFeedLabel setAlpha:0.0];
    } completion:^(BOOL finished) {
        
        _workoutFeedLabel.text = [NSString stringWithFormat:@"Sets: %@ Reps: %@ Weight: %@ %@", currentSet, currentReps, currentWeight, [KLEUtility weightUnitType]];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_workoutFeedLabel setAlpha:1.0];
        } completion:nil];
    }];
    
    
    NSString *repsWeightString = [currentReps stringByAppendingString:currentWeight];
    
    /*
    // for storing reps and weight as string instead of transformable array in core data
     
    if (!_repsWeightString) {
        _repsWeightString = [[NSMutableString alloc] init];
    }
    [_repsWeightString appendString:currentReps];
    [_repsWeightString appendString:currentWeight];
    
    NSLog(@"REPS WEIGHT STRING %@", _repsWeightString);
    */
    
    if (!_currentRepsWeightArray)
    {
        _currentRepsWeightArray = [[NSMutableArray alloc] init];
    }

    [_currentRepsWeightArray addObject:repsWeightString];
    
    NSLog(@"CURRENT REPS WEIGHT ARRAY IN WORKOUT: %@", _currentRepsWeightArray);
    
    // when finished with last set, disable the sets workout button
    if (_currentSet == [_selectedRoutineExercise.sets integerValue])
    {
        NSLog(@"SETS AT 0");
        [_setsWorkoutButton.setsButton setEnabled:NO];
        [_setsWorkoutButton setAlpha:0.5];
        
        [_repsWorkoutButton setEnabled:NO];
        [_repsWorkoutButton setAlpha:0.5];
    }
    
    [_finishWorkoutButton setEnabled:YES];
    [_finishWorkoutButton setAlpha:1.0];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"BEGAN EDITING");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"END EDITING");
//    _selectedRoutineExercise.weight = [NSNumber numberWithInteger:[_weightTextField.text integerValue]];
    
//    _selectedRoutineExercise.weight = [NSNumber numberWithInteger:[_weightControl.weightTextField.text integerValue]];
//    NSLog(@"NEW WEIGHT %@", _selectedRoutineExercise.weight);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)resetSelectedExercise:(id)exercise
{
    // exercise goal changed notification action and object
    NSLog(@"RESET OBJECT %@", [exercise object]);
    
    // check if the exercise in workout is the same
    if ([_selectedRoutineExercise isEqual:[exercise object]])
    {
        NSLog(@"EQUAL");
        
        [self resetButtonAction:nil];
    }
    else
    {
        NSLog(@"DON'T RESET, EXERCISE IN WORKOUT NOT THE SAME");
    }
}

- (IBAction)resetButtonAction:(UIButton *)sender
{
    _currentSet = 0;
    _currentRepsWeightArray = nil;
    
    _workoutFeedLabel.text = @"Start your set then press S button";
    
    [_setsWorkoutButton.setsButton setEnabled:YES];
    [_setsWorkoutButton setAlpha:1.0];
    
    [_repsWorkoutButton setEnabled:YES];
    [_repsWorkoutButton setAlpha:1.0];
    
    [_setsWorkoutButton resetAngle:0.0];
    
    [self setupExerciseData];
}
@end
