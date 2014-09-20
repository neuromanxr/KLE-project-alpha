//
//  KLERoutinesStore.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/17/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KLEStatStore;

@interface KLERoutinesStore : NSObject

@property (nonatomic, readonly) NSArray *allStatStores;

@property (nonatomic, strong) NSArray *userSelections;

+ (instancetype)sharedStore;

- (KLEStatStore *)createStatStore;
- (void)removeStatStore:(KLEStatStore *)statStore;
- (void)moveStatStoreAtIndex:(NSUInteger)fromIndex
                     toIndex:(NSUInteger)toIndex;

@end