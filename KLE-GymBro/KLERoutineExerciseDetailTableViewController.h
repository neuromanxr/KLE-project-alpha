//
//  KLERoutineExerciseDetailTableViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/16/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLEExerciseGoal;

@interface KLERoutineExerciseDetailTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) KLEExerciseGoal *selectedRoutineExercise;

@end
