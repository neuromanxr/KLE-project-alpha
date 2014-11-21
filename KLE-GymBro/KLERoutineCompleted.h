//
//  KLERoutineCompleted.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/21/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KLEExerciseCompleted;

@interface KLERoutineCompleted : NSManagedObject

@property (nonatomic, retain) NSString * routinenamecompleted;
@property (nonatomic, retain) NSSet *exercisecompleted;
@end

@interface KLERoutineCompleted (CoreDataGeneratedAccessors)

- (void)addExercisecompletedObject:(KLEExerciseCompleted *)value;
- (void)removeExercisecompletedObject:(KLEExerciseCompleted *)value;
- (void)addExercisecompleted:(NSSet *)values;
- (void)removeExercisecompleted:(NSSet *)values;

@end
