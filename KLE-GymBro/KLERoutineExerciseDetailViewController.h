//
//  KLERoutineExerciseDetailViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 1/16/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEWorkoutButton.h"
#import <UIKit/UIKit.h>

@class KLEExerciseGoal;

@interface KLERoutineExerciseDetailViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) KLEExerciseGoal *selectedRoutineExercise;

@property (strong, nonatomic) IBOutlet UILabel *setsAmount;
@property (strong, nonatomic) IBOutlet KLEWorkoutButton *setsCircle;
@property (strong, nonatomic) IBOutlet UIStepper *setsStepper;
- (IBAction)setsStepperAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *repsAmount;
@property (strong, nonatomic) IBOutlet KLEWorkoutButton *repsCircle;
@property (strong, nonatomic) IBOutlet UIStepper *repsStepper;
- (IBAction)repsStepperAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *weightAmount;
@property (strong, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong, nonatomic) IBOutlet UIStepper *weightStepper;
- (IBAction)weightStepperAction:(id)sender;

@end
