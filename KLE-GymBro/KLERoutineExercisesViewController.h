//
//  KLERoutineExercisesViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/15/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//
#import "KLETableHeaderView.h"
#import "CoreDataTableViewController.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KLERoutineExercisesViewControllerMode)
{
    KLERoutineExercisesViewControllerModeNormal,
    KLERoutineExercisesViewControllerModeWorkout
};

@interface KLERoutineExercisesViewController : CoreDataTableViewController

+ (instancetype)routineExercisesViewControllerWithMode:(KLERoutineExercisesViewControllerMode)mode;

@property (nonatomic, assign) KLERoutineExercisesViewControllerMode mode;

@property (nonatomic, strong) NSManagedObjectID *selectedRoutineID;

@end
