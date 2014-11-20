//
//  KLEExerciseGoal.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/19/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KLEExercise, KLERoutine;

@interface KLEExerciseGoal : NSManagedObject

@property (nonatomic, retain) NSNumber * hasweight;
@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) NSNumber * sets;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) KLEExercise *exercise;
@property (nonatomic, retain) KLERoutine *routine;

@end
