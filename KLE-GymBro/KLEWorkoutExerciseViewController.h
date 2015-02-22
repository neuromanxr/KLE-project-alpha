//
//  KLEWorkoutExerciseViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLEWorkoutButton.h"
#import "KLERepsButton.h"
#import "KLEWorkoutButtonDelegate.h"

@class KLEExerciseGoal;

@interface KLEWorkoutExerciseViewController : UIViewController <UITextFieldDelegate, KLEWorkoutButtonDelegate>

@property (nonatomic, strong) KLEExerciseGoal *selectedRoutineExercise;

@property (strong, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong, nonatomic) IBOutlet UIButton *decreaseWeightButton;
@property (strong, nonatomic) IBOutlet UIButton *increaseWeightButton;
@property (strong, nonatomic) IBOutlet UISwitch *weightUnitSwitch;

@property (strong, nonatomic) IBOutlet UILabel *weightIncrementLabel;
@property (strong, nonatomic) IBOutlet UISlider *weightIncrementSlider;

@property (strong, nonatomic) IBOutlet KLEWorkoutButton *setsWorkoutButton;
@property (strong, nonatomic) IBOutlet KLERepsButton *repsWorkoutButton;

@property (strong, nonatomic) IBOutlet UIButton *finishWorkoutButton;

@end
