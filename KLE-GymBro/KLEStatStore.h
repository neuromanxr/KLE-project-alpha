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

@property (nonatomic, retain) NSString *routineName;

@property (nonatomic, retain) NSIndexPath *userSelections;

//+ (instancetype)sharedStore;

- (KLEStat *)createStat;
- (void)removeStat:(KLEStat *)stat;
- (void)moveStatAtIndex:(NSUInteger)fromIndex
                     toIndex:(NSUInteger)toIndex;

@end
