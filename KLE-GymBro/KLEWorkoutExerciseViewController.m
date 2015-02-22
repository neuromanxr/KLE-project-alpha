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

@interface KLEWorkoutExerciseViewController ()

{
    NSUInteger currentSet;
}

@end

@implementation KLEWorkoutExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.navigationItem.title = _selectedRoutineExercise.exercise.exercisename;
    
    // set delegate for sets workout button
    _setsWorkoutButton.delegate = self;
    
    _weightTextField.delegate = self;
    _weightTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [self setupExerciseData];
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
    exerciseCompleted.exercisenamecompleted = exerciseGoal.exercise.exercisename;
    
}

- (void)currentSet:(CGFloat)set
{
    // delegate method to get the current set
    currentSet = set;
    NSLog(@"CURRENT SET IN WORKOUT EXERCISE VIEW CONTROLLER %.2f", set);
}

- (void)calculateTotalReps
{
    NSUInteger currentReps = [_repsWorkoutButton.titleLabel.text integerValue];
    NSLog(@"Current Reps and Sets %lu, %lu", currentReps, currentSet);
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
