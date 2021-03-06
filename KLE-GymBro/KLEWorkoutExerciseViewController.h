//
//  KLEWorkoutExerciseViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLERoundButton.h"
#import "KLEWorkoutButton.h"
#import "KLERepsButton.h"
#import "KLEWorkoutButtonDelegate.h"

@class KLEExerciseGoal;

@interface KLEWorkoutExerciseViewController : UIViewController <KLEWorkoutButtonDelegate, KLERepsButtonDelegate>

@property (nonatomic, strong) KLEExerciseGoal *selectedRoutineExercise;

@property (strong, nonatomic) IBOutlet UILabel *workoutFeedLabel;

@property (strong, nonatomic) IBOutlet KLEWorkoutButton *setsWorkoutButton;
@property (strong, nonatomic) IBOutlet KLERepsButton *repsWorkoutButton;
@property (strong, nonatomic) IBOutlet KLERoundButton *finishWorkoutButton;

@property (strong, nonatomic) IBOutlet UIButton *resetButton;
- (IBAction)resetButtonAction:(UIButton *)sender;

@end
