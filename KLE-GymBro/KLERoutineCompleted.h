//
//  KLERoutineCompleted.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/16/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KLERoutinesCompleted.h"

@class KLEExerciseCompleted, KLERoutinesCompleted;

@interface KLERoutineCompleted : KLERoutinesCompleted

@property (nonatomic, retain) NSSet *exercisecompleted;
@property (nonatomic, retain) KLERoutinesCompleted *routinescompleted;
@end

@interface KLERoutineCompleted (CoreDataGeneratedAccessors)

- (void)addExercisecompletedObject:(KLEExerciseCompleted *)value;
- (void)removeExercisecompletedObject:(KLEExerciseCompleted *)value;
- (void)addExercisecompleted:(NSSet *)values;
- (void)removeExercisecompleted:(NSSet *)values;

@end
