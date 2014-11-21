//
//  KLEDay.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/21/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KLERoutine;

@interface KLEDay : NSManagedObject

@property (nonatomic, retain) NSNumber * daynumber;
@property (nonatomic, retain) NSNumber * routinescount;
@property (nonatomic, retain) NSSet *routine;
@end

@interface KLEDay (CoreDataGeneratedAccessors)

- (void)addRoutineObject:(KLERoutine *)value;
- (void)removeRoutineObject:(KLERoutine *)value;
- (void)addRoutine:(NSSet *)values;
- (void)removeRoutine:(NSSet *)values;

@end
