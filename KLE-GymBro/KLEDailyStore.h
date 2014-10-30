//
//  KLEDailyStore.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 10/3/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KLEStatStore;

@interface KLEDailyStore : NSObject

@property (nonatomic, readonly) NSDictionary *allStatStores;

+ (instancetype)sharedStore;

- (void)addStatStoreToDay:(KLEStatStore *)routine
                    atKey:(NSString *)key;
- (void)removeStatStoreFromDay:(KLEStatStore *)routine
                       atIndex:(NSUInteger)index
                         atKey:(NSString *)key;
- (void)moveStatStoreAtIndex:(NSUInteger)fromIndex
                       atKey:(NSString *)fromKey
                     toIndex:(NSUInteger)toIndex
                        toKey:(NSString *)toKey;

@end
