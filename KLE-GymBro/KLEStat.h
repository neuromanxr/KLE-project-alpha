//
//  KLEStat.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/3/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

// User picked exercise. User picks goal sets, reps and weight

@class KLEExercises;

@interface KLEStat : NSObject

@property (nonatomic, strong) KLEExercises *exerciseObject;
@property (nonatomic, retain) NSString *exercise; // should be using KLEExercise Object
@property (nonatomic, retain) NSDate *date;
@property (nonatomic) int sets;
@property (nonatomic) int reps;
@property (nonatomic) float weight;

@property (nonatomic, copy) NSIndexPath *userSelections;

- (instancetype)initWithExercise:(NSString *)exerciseName
                    numberOfSets:(int)setsNumber
                    numberOfReps:(int)repsNumber
                      withWeight:(float)weightNumber;

@end
