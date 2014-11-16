//
//  KLEExerciseCompleted.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/16/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KLEExerciseGoal.h"

@class KLERoutineCompleted;

@interface KLEExerciseCompleted : KLEExerciseGoal

@property (nonatomic, retain) KLERoutineCompleted *routinecompleted;

@end
