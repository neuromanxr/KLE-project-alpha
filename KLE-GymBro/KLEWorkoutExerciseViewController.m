//
//  KLEWorkoutExerciseViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEAppDelegate.h"
#import "CoreDataTableViewController.h"
#import "KLEWorkoutExerciseViewController.h"
#import "KLEExerciseCompleted.h"
#import "KLEExerciseGoal.h"
#import "KLEExercise.h"
#import "KLERoutine.h"

@interface KLEWorkoutExerciseViewController ()

@property (nonatomic, copy) NSMutableArray *currentRepsWeightArray;
@property (nonatomic, copy) NSArray *weightIncrementNumbers;
@property (nonatomic, assign) NSUInteger currentSet;

@end

@implementation KLEWorkoutExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.navigationItem.title = _selectedRoutineExercise.exercise.exercisename;
    
    // set delegate for sets workout button
    _setsWorkoutButton.delegate = self;
    
    // set delegate for reps workout button
    _repsWorkoutButton.delegate = self;
    
    _weightTextField.delegate = self;
    _weightTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [self setupExerciseData];
    
    [self setupWeightSlider];
    
    [_decreaseWeightButton addTarget:self action:@selector(decreaseWeight) forControlEvents:UIControlEventTouchUpInside];
    [_increaseWeightButton addTarget:self action:@selector(increaseWeight) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupExerciseData
{
    _weightTextField.text = [NSString stringWithFormat:@"%@", _selectedRoutineExercise.weight];
    
    _setsWorkoutButton.setsForAngle = _selectedRoutineExercise.sets;
    [_setsWorkoutButton setTitle:[NSString stringWithFormat:@"%@", _selectedRoutineExercise.sets] forState:UIControlStateNormal];
    [_repsWorkoutButton setTitle:[NSString stringWithFormat:@"%@", _selectedRoutineExercise.reps] forState:UIControlStateNormal];
    
    [_finishWorkoutButton addTarget:self action:@selector(finishWorkout) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)finishWorkout
{
    CoreDataHelper *cdh = [(KLEAppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    
    KLEExerciseGoal *exerciseGoal = _selectedRoutineExercise;
    
    KLEExerciseCompleted *exerciseCompleted = [NSEntityDescription insertNewObjectForEntityForName:@"KLEExerciseCompleted" inManagedObjectContext:cdh.context];
    
//    exerciseCompleted.repsweightarray = [[_currentRepsWeightArray reverseObjectEnumerator] allObjects];
    exerciseCompleted.repsweightarray = [NSArray arrayWithArray:_currentRepsWeightArray];
    
    // get the array then get the max weight
    NSArray *repsWeightArray = [NSArray arrayWithArray:_currentRepsWeightArray];
    NSMutableArray *weightArray = [[NSMutableArray alloc] init];
    for (NSString *weight in repsWeightArray) {
        [weightArray addObject:[[weight componentsSeparatedByString:@" "] lastObject]];
    }
    CGFloat maxWeight = [[weightArray valueForKeyPath:@"@max.self"] floatValue];
    NSLog(@"MAX WEIGHT %.2f", maxWeight);
    
    exerciseCompleted.maxweight = [NSNumber numberWithFloat:maxWeight];
    exerciseCompleted.setscompleted = [NSNumber numberWithInteger:_currentSet];
    exerciseCompleted.exercisename = exerciseGoal.exercise.exercisename;
    exerciseCompleted.routinename = exerciseGoal.routine.routinename;
    exerciseCompleted.datecompleted = [NSDate date];
    
    _currentRepsWeightArray = nil;
    
    NSLog(@"EXERCISE COMPLETED SETS %@ REPS WEIGHT ARRAY %@", exerciseCompleted.setscompleted, exerciseCompleted.repsweightarray);
    NSLog(@"EXERCISE GOAL SETS %@ REPS %@", exerciseGoal.sets, exerciseGoal.reps);
}

- (void)setupWeightSlider
{
    _weightIncrementNumbers = @[@(2.5), @(5), @(10), @(25), @(35), @(45)];
    NSUInteger numberOfSteps = [_weightIncrementNumbers count] - 1;
    
    _weightIncrementSlider.maximumValue = numberOfSteps;
    _weightIncrementSlider.minimumValue = 0;
    [_weightIncrementSlider setValue:_weightIncrementSlider.minimumValue];
    [_weightIncrementSlider setMaximumTrackTintColor:[UIColor redColor]];
    _weightIncrementSlider.continuous = YES;
    [_weightIncrementSlider addTarget:self action:@selector(weightValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
}

- (void)decreaseWeight
{
    CGFloat weightChangeValue = [_weightIncrementLabel.text floatValue];
    
    if ([_weightTextField.text floatValue] >= weightChangeValue)
    {
        CGFloat weightTextFieldValue = [_weightTextField.text floatValue];
        weightTextFieldValue -= weightChangeValue;
        
        _weightTextField.text = [NSString stringWithFormat:@"%.2f", weightTextFieldValue];
    }
    else
    {
        NSLog(@"CHANGE VALUE IS GREATER THAN THE WEIGHT VALUE");
    }
}

- (void)increaseWeight
{
    CGFloat weightChangeValue = [_weightIncrementLabel.text floatValue];
    CGFloat weightTextFieldValue = [_weightTextField.text floatValue];
    
    weightTextFieldValue += weightChangeValue;
    
    _weightTextField.text = [NSString stringWithFormat:@"%.2f", weightTextFieldValue];
        
    NSLog(@"WEIGHT TEXT FIELD VALUE %.f", weightTextFieldValue);
}

- (void)weightValueChanged:(UISlider *)sender
{
    // round the slider position to the nearest index of the weight increment numbers array
    NSUInteger index = _weightIncrementSlider.value + 0.5;
    [_weightIncrementSlider setValue:index animated:NO];
    NSNumber *number = [_weightIncrementNumbers objectAtIndex:index];
    
    _weightIncrementLabel.text = [NSString stringWithFormat:@"%@", number];
    
    NSLog(@"~~SLIDERINDEX: %lu", index);
    NSLog(@"~~number: %@", number);
}

// delegate method for sets button
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
        
        NSUInteger currentReps = [_repsWorkoutButton.titleLabel.text integerValue];
        if (currentReps != 0) {
            currentReps--;
            NSLog(@"CURRENT REPS %lu", currentReps);
            [_repsWorkoutButton setTitle:[NSString stringWithFormat:@"%lu", currentReps] forState:UIControlStateNormal];
        }
        else
        {
            [_repsWorkoutButton setTitle:[NSString stringWithFormat:@"%lu", currentReps] forState:UIControlStateNormal];
        }
    }
    else
    {
        // increment reps value
        
        NSUInteger currentReps = [_repsWorkoutButton.titleLabel.text integerValue];
        currentReps++;
        NSLog(@"CURRENT REPS %lu", currentReps);
        [_repsWorkoutButton setTitle:[NSString stringWithFormat:@"%lu", currentReps] forState:UIControlStateNormal];
    }
}

- (void)calculateTotalReps
{
    NSString *currentReps = [NSString stringWithFormat:@"%lu", [_repsWorkoutButton.titleLabel.text integerValue]];
    NSString *currentWeight = [NSString stringWithFormat:@" %.2f", [_weightTextField.text floatValue]];
    NSString *currentSet = [NSString stringWithFormat:@"%lu", _currentSet];
    
    NSLog(@"Current Reps and Sets %@, %@", currentReps, currentSet);
    
    _workoutFeedLabel.text = [NSString stringWithFormat:@"Weight: %@ Sets: %@ Reps: %@", currentWeight, currentSet, currentReps];
    
    NSString *repsWeightString = [currentReps stringByAppendingString:currentWeight];
    
    // for storing reps and weight as string instead of transformable array in core data
//    if (!_repsWeightString) {
//        _repsWeightString = [[NSMutableString alloc] init];
//    }
//    [_repsWeightString appendString:currentReps];
//    [_repsWeightString appendString:currentWeight];
    
//    NSLog(@"REPS WEIGHT STRING %@", _repsWeightString);
    
    if (!_currentRepsWeightArray) {
        _currentRepsWeightArray = [[NSMutableArray alloc] init];
    }

    [_currentRepsWeightArray addObject:repsWeightString];
    
    NSLog(@"CURRENT REPS WEIGHT ARRAY IN WORKOUT: %@", _currentRepsWeightArray);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"BEGAN EDITING");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"END EDITING");
    _selectedRoutineExercise.weight = [NSNumber numberWithInteger:[_weightTextField.text integerValue]];
    NSLog(@"NEW WEIGHT %@", _selectedRoutineExercise.weight);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
