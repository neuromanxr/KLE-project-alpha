//
//  KLEExerciseCompleted.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/25/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KLEExercise;

@interface KLEExerciseCompleted : NSManagedObject

@property (nonatomic, retain) KLEExercise *exercise;
@property (nonatomic, retain) NSString * routinename;
@property (nonatomic, retain) NSString * exercisename;
@property (nonatomic, retain) NSNumber * timecompleted;
@property (nonatomic, retain) NSDate * datecompleted;
@property (nonatomic, retain) NSNumber * setscompleted;
@property (nonatomic, retain) NSNumber * maxweight;
@property (nonatomic, retain) NSNumber * calories;
@property (nonatomic, retain) NSNumber * heartrate;
@property (nonatomic, retain) id repsweightarray;

@end

@interface RepsWeightArray : NSValueTransformer

@end

@interface KLEExerciseCompleted (AdditionalMethods)

- (NSString *)shortDateCompleted;

@end
