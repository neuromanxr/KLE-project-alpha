//
//  KLEExercise.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/16/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KLEExerciseGoal;

@interface KLEExercise : NSManagedObject

@property (nonatomic, retain) NSString * exercisename;
@property (nonatomic, retain) NSString * musclename;
@property (nonatomic, retain) KLEExerciseGoal *exercisegoal;

@end
