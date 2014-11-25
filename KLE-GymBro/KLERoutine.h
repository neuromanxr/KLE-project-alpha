//
//  KLERoutine.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/22/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KLEExerciseGoal;

@interface KLERoutine : NSManagedObject

@property (nonatomic, retain) NSString * dayname;
@property (nonatomic, retain) NSNumber * exercisecount;
@property (nonatomic, retain) NSString * routinename;
@property (nonatomic, retain) NSNumber * daynumber;
@property (nonatomic, retain) NSNumber * inworkout;
@property (nonatomic, retain) NSSet *exercisegoal;
@end

@interface KLERoutine (CoreDataGeneratedAccessors)

- (void)addExercisegoalObject:(KLEExerciseGoal *)value;
- (void)removeExercisegoalObject:(KLEExerciseGoal *)value;
- (void)addExercisegoal:(NSSet *)values;
- (void)removeExercisegoal:(NSSet *)values;

@end
