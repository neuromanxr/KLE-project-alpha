//
//  KLERoutineExerciseDetailViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 1/16/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLERoutineExerciseDetailViewController.h"
#import "KLEExerciseGoal.h"
#import "KLEExercise.h"
#import "KLERoutine.h"

@interface KLERoutineExerciseDetailViewController ()

@end

@implementation KLERoutineExerciseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // assign the weight, sets and reps values from the selected routine exercise
    self.weightTextField.delegate = self;
    self.weightTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.weightTextField.text = [NSString stringWithFormat:@"%@", self.selectedRoutineExercise.weight];
    
    self.setsAmount.text = [NSString stringWithFormat:@"%@", self.selectedRoutineExercise.sets];
    self.repsAmount.text = [NSString stringWithFormat:@"%@", self.selectedRoutineExercise.reps];
    self.weightAmount.text = [NSString stringWithFormat:@"%@", self.selectedRoutineExercise.weight];
    
    // assign the current values to the steppers
    self.weightStepper.value = [self.weightTextField.text floatValue];
    self.setsStepper.value = [self.setsAmount.text floatValue];
    self.repsStepper.value = [self.repsAmount.text floatValue];
    
    self.navigationItem.title = self.selectedRoutineExercise.exercise.exercisename;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.selectedRoutineExercise.weight = [NSNumber numberWithFloat:[self.weightTextField.text floatValue]];
    self.selectedRoutineExercise.sets = [NSNumber numberWithInteger:[self.setsAmount.text integerValue]];
    self.selectedRoutineExercise.reps = [NSNumber numberWithInteger:[self.repsAmount.text integerValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    NSLog(@"## ROUTINE EXERCISE DETAIL WILL TRANSITION");
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"BEGAN EDITING");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"END EDITING");
    self.selectedRoutineExercise.weight = [NSNumber numberWithInteger:[self.weightTextField.text integerValue]];
    NSLog(@"NEW WEIGHT %@", self.selectedRoutineExercise.weight);
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

- (IBAction)weightStepperAction:(id)sender
{
    self.weightTextField.text = [NSString stringWithFormat:@"%.f", self.weightStepper.value];
    
}

- (IBAction)setsStepperAction:(id)sender
{
    self.setsAmount.text = [NSString stringWithFormat:@"%.f", self.setsStepper.value];
}

- (IBAction)repsStepperAction:(id)sender
{
    self.repsAmount.text = [NSString stringWithFormat:@"%.f", self.repsStepper.value];
}
@end
