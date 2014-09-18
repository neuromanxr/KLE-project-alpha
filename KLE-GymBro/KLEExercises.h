//
//  KLEExercises.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/12/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLEExercises : NSObject

@property (nonatomic, retain) NSString *exerciseName;
@property (nonatomic, retain) NSString *exerciseType;

@property (nonatomic, strong) NSMutableArray *exerciseList;

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name ofType:(NSString *)type;

@end
