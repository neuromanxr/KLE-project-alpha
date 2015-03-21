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

@interface KLEWorkoutExerciseViewController ()

@property (nonatomic, copy) NSMutableArray *currentRepsWeightArray;
@property (nonatomic, copy) NSArray *weightIncrementNumbers;
@property (nonatomic, assign) NSUInteger currentSet;

@property (strong, nonatomic) IBOutlet KLEWeightControl *weightControl;

@end

@implementation KLEWorkoutExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    // custom title for navigation title
    NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:_selectedRoutineExercise.exercise.exercisename attributes:@{ NSFontAttributeName : [KLEUtility getFontFromFontFamilyWithSize:18.0], NSUnderlineStyleAttributeName : @0, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    // custom title for navigation title
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
    
    _workoutFeedLabel.text = @"Start your set then press S button";
    
    [self setupExerciseData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSelectedExercise:) name:kExerciseGoalChangedNote object:nil];
    
    [_finishWorkoutButton addTarget:self action:@selector(finishWorkout) forControlEvents:UIControlEventTouchUpInside];
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

- (void)setupExerciseData
{
//    _weightTextField.text = [NSString stringWithFormat:@"%@", _selectedRoutineExercise.weight];
    _weightControl.weightTextField.text = [NSString stringWithFormat:@"%@", _selectedRoutineExercise.weight];
    
    _setsWorkoutButton.setsForAngle = _selectedRoutineExercise.sets;
    [_setsWorkoutButton.setsButton setTitle:[NSString stringWithFormat:@"%@", _selectedRoutineExercise.sets] forState:UIControlStateNormal];
    _repsWorkoutButton.repsLabel.text = [NSString stringWithFormat:@"%@", _selectedRoutineExercise.reps];
    
    [_finishWorkoutButton setEnabled:NO];
    [_finishWorkoutButton setAlpha:0.5];
    
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
