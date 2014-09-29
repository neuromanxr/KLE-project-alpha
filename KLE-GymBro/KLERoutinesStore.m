//
//  KLERoutinesStore.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/17/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLERoutinesStore.h"
#import "KLEStatStore.h"

@interface KLERoutinesStore ()

// private array accessible only to KLERoutinesStore
@property (nonatomic) NSMutableArray *privateStatStore;

@end

@implementation KLERoutinesStore

+ (instancetype)sharedStore
{
    static KLERoutinesStore *sharedStore = nil;
    
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
        _privateStatStore = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)allStatStores
{
    return self.privateStatStore;
}

- (KLEStatStore *)createStatStore
{
    KLEStatStore *statStore = [[KLEStatStore alloc] init];
    
    [self.privateStatStore addObject:statStore];
    
    return statStore;
}

- (void)removeStatStore:(KLEStatStore *)statStore
{
    [self.privateStatStore removeObjectIdenticalTo:statStore];
}

- (void)moveStatStoreAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    // get pointer to object being moved so you can re-insert it
    KLEStatStore *statStore = self.privateStatStore[fromIndex];
    
    // remove routine from array
    [self.privateStatStore removeObjectAtIndex:fromIndex];
    
    // insert routine in array at new location
    [self.privateStatStore insertObject:statStore atIndex:toIndex];
}

@end
