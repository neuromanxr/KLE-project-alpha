//
//  KLEStat.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/3/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLEStat : NSObject

@property (nonatomic, retain) NSString *exercise;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic) int sets;
@property (nonatomic) int reps;
@property (nonatomic) float weight;

@end
