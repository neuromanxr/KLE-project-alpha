//
//  KLEExercise.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/22/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KLEExerciseGoal;

@interface KLEExercise : NSManagedObject

@property (nonatomic, retain) NSString * exercisename;
@property (nonatomic, retain) NSString * musclename;
@property (nonatomic, retain) NSSet *exercisegoal;
@end

@interface KLEExercise (CoreDataGeneratedAccessors)

- (void)addExercisegoalObject:(KLEExerciseGoal *)value;
- (void)removeExercisegoalObject:(KLEExerciseGoal *)value;
- (void)addExercisegoal:(NSSet *)values;
- (void)removeExercisegoal:(NSSet *)values;

@end