//
//  KLEDailyStore.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 10/3/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEDailyStore.h"
#import "KLEStatStore.h"

@interface KLEDailyStore ()

// private dictionary accessible only to KLERoutinesStore
@property (nonatomic) NSDictionary *privateDictionaryStatStore;

@end

@implementation KLEDailyStore

+ (instancetype)sharedStore
{
    static KLEDailyStore *sharedStore = nil;
    
    // do I need to create a sharedStore?
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

// if you try to call [[KLERoutinesStore alloc] init], throw an error
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[KLEStatStore sharedStore]" userInfo:nil];
    return nil;
}

// this is the secret initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        NSMutableArray *sundayRoutines = [[NSMutableArray alloc] init];
        NSMutableArray *mondayRoutines = [[NSMutableArray alloc] init];
        NSMutableArray *tuesdayRoutines = [[NSMutableArray alloc] init];
        NSMutableArray *wednesdayRoutines = [[NSMutableArray alloc] init];
        NSMutableArray *thursdayRoutines = [[NSMutableArray alloc] init];
        NSMutableArray *fridayRoutines = [[NSMutableArray alloc] init];
        NSMutableArray *saturdayRoutines = [[NSMutableArray alloc] init];
        
        _privateDictionaryStatStore = @{@"0" : sundayRoutines,
                                        @"1" : mondayRoutines,
                                        @"2" :tuesdayRoutines,
                                        @"3" : wednesdayRoutines,
                                        @"4" : thursdayRoutines,
                                        @"5" : fridayRoutines,
                                        @"6" : saturdayRoutines};
    }
    
    return self;
}

- (NSDictionary *)allStatStores
{
    return self.privateDictionaryStatStore;
}

- (void)addStatStoreToDay:(KLEStatStore *)routine atKey:(NSString *)key
{
    
    NSMutableArray *dayStatStore = [self.privateDictionaryStatStore objectForKey:key];
    [dayStatStore addObject:routine];
    NSLog(@"add to day array %@", dayStatStore);
}

- (void)removeStatStoreFromDay:(KLEStatStore *)routine atKey:(NSString *)key
{
    NSMutableArray *dayStatStore = [self.privateDictionaryStatStore objectForKey:key];
    [dayStatStore removeObjectIdenticalTo:routine];
    NSLog(@"remove from day array %@", dayStatStore);
}

- (void)moveStatStoreAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex atKey:(NSString *)key
{
    if (fromIndex == toIndex) {
        return;
    }
    // get pointer to the array at the passed in key
    NSMutableArray *dayStatStore = [self.privateDictionaryStatStore objectForKey:key];
    
    // get pointer to object being moved so you can re-insert it
    KLEStatStore *statStore = dayStatStore[fromIndex];
    
    // remove routine from array
    [dayStatStore removeObjectAtIndex:fromIndex];
    
    // insert routine in array at new location
    [dayStatStore insertObject:statStore atIndex:toIndex];
}

@end
