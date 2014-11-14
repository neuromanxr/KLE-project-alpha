//
//  KLEExerciseCompleted.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/11/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KLEExerciseGoal.h"

@class KLERoutineCompleted;

@interface KLEExerciseCompleted : KLEExerciseGoal

@property (nonatomic, retain) NSSet *routinecompleted;
@end

@interface KLEExerciseCompleted (CoreDataGeneratedAccessors)

- (void)addRoutinecompletedObject:(KLERoutineCompleted *)value;
- (void)removeRoutinecompletedObject:(KLERoutineCompleted *)value;
- (void)addRoutinecompleted:(NSSet *)values;
- (void)removeRoutinecompleted:(NSSet *)values;

@end
