//
//  KLERoutineCompleted.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/11/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KLERoutine.h"

@class KLEExerciseCompleted, KLERoutinesCompleted;

@interface KLERoutineCompleted : KLERoutine

@property (nonatomic, retain) NSSet *exercisecompleted;
@property (nonatomic, retain) KLERoutinesCompleted *routinescompleted;
@end

@interface KLERoutineCompleted (CoreDataGeneratedAccessors)

- (void)addExercisecompletedObject:(KLEExerciseCompleted *)value;
- (void)removeExercisecompletedObject:(KLEExerciseCompleted *)value;
- (void)addExercisecompleted:(NSSet *)values;
- (void)removeExercisecompleted:(NSSet *)values;

@end
