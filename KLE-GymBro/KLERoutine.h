//
//  KLERoutine.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/16/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KLERoutines.h"

@class KLEExerciseGoal, KLERoutines;

@interface KLERoutine : KLERoutines

@property (nonatomic, retain) NSString * routinename;
@property (nonatomic, retain) NSNumber * exercisecount;
@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSOrderedSet *exercisegoal;
@property (nonatomic, retain) KLERoutines *routines;
@end

@interface KLERoutine (CoreDataGeneratedAccessors)

- (void)insertObject:(KLEExerciseGoal *)value inExercisegoalAtIndex:(NSUInteger)idx;
- (void)removeObjectFromExercisegoalAtIndex:(NSUInteger)idx;
- (void)insertExercisegoal:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeExercisegoalAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInExercisegoalAtIndex:(NSUInteger)idx withObject:(KLEExerciseGoal *)value;
- (void)replaceExercisegoalAtIndexes:(NSIndexSet *)indexes withExercisegoal:(NSArray *)values;
- (void)addExercisegoalObject:(KLEExerciseGoal *)value;
- (void)removeExercisegoalObject:(KLEExerciseGoal *)value;
- (void)addExercisegoal:(NSOrderedSet *)values;
- (void)removeExercisegoal:(NSOrderedSet *)values;

- (void)addExerciseGoal:(KLEExerciseGoal *)exerciseGoal;
@end
