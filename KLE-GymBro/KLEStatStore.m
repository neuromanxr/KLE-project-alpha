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

//+ (instancetype)sharedStore
//{
//    static KLEStatStore *sharedStore = nil;
//    
//    // do I need to create a sharedStore?
//    if (!sharedStore) {
//        sharedStore = [[self alloc] initPrivate];
//    }
//    return sharedStore;
//}

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

@end
