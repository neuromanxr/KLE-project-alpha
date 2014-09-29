//
//  KLEStatStore.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/3/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEStat.h"
#import "KLEStatStore.h"

@interface KLEStatStore ()

// private array accessible only to KLEStatStore
@property (nonatomic) NSMutableArray *privateStats;

@end

@implementation KLEStatStore

- (instancetype)init
{
    return [self initPrivate];
}

// this is the secret initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _privateStats = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)allStats
{
    return self.privateStats;
}

- (KLEStat *)createStat
{
    KLEStat *stat = [[KLEStat alloc] init];
    
    [self.privateStats addObject:stat];
    
    return stat;
}

- (void)removeStat:(KLEStat *)stat
{
    [self.privateStats removeObjectIdenticalTo:stat];
}

- (void)moveStatAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    // get pointer to object being moved so you can re-insert it
    KLEStat *stat = self.privateStats[fromIndex];
    
    // remove routine from array
    [self.privateStats removeObjectAtIndex:fromIndex];
    
    // insert routine in array at new location
    [self.privateStats insertObject:stat atIndex:toIndex];
}

@end
