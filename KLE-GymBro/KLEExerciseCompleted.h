//
//  KLEExerciseCompleted.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/19/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KLERoutineCompleted;

@interface KLEExerciseCompleted : NSManagedObject

@property (nonatomic, retain) NSString * exercisenamecompleted;
@property (nonatomic, retain) KLERoutineCompleted *routinecompleted;

@end
