//
//  KLERoutineExerciseDetailViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 1/16/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLEExerciseGoal;

@interface KLERoutineExerciseDetailViewController : UIViewController

@property (nonatomic, strong) KLEExerciseGoal *selectedRoutineExercise;
@property (strong, nonatomic) IBOutlet UILabel *exerciseNameTitle;
@property (strong, nonatomic) IBOutlet UILabel *setsAmount;
@property (strong, nonatomic) IBOutlet UILabel *repsAmount;
@property (strong, nonatomic) IBOutlet UILabel *weightAmount;

@end
