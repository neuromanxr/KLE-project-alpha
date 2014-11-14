//
//  KLEExerciseGoal.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/11/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KLEExercise, KLERoutine;

@interface KLEExerciseGoal : NSManagedObject

@property (nonatomic, retain) NSNumber * sets;
@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * hasWeight;
@property (nonatomic, retain) NSSet *exercise;
@property (nonatomic, retain) NSSet *routine;
@end

@interface KLEExerciseGoal (CoreDataGeneratedAccessors)

- (void)addExerciseObject:(KLEExercise *)value;
- (void)removeExerciseObject:(KLEExercise *)value;
- (void)addExercise:(NSSet *)values;
- (void)removeExercise:(NSSet *)values;

- (void)addRoutineObject:(KLERoutine *)value;
- (void)removeRoutineObject:(KLERoutine *)value;
- (void)addRoutine:(NSSet *)values;
- (void)removeRoutine:(NSSet *)values;

@end
