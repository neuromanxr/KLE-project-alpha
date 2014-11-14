//
//  KLERoutine.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/11/14.
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
@property (nonatomic, retain) NSSet *exercisegoal;
@property (nonatomic, retain) KLERoutines *routines;
@end

@interface KLERoutine (CoreDataGeneratedAccessors)

- (void)addExercisegoalObject:(KLEExerciseGoal *)value;
- (void)removeExercisegoalObject:(KLEExerciseGoal *)value;
- (void)addExercisegoal:(NSSet *)values;
- (void)removeExercisegoal:(NSSet *)values;

@end
