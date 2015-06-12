//
//  KLEExerciseGoal.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/24/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
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
