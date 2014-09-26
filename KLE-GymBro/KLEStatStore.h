//
//  KLEStatStore.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/3/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KLEStat;

@interface KLEStatStore : NSObject

@property (nonatomic, readonly) NSArray *allStats;

@property (nonatomic, copy) NSIndexPath *userSelections;

@property (nonatomic, retain) NSString *routineName;

//+ (instancetype)sharedStore;

- (KLEStat *)createStat;

@end
