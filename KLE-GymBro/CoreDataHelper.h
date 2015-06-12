//
//  CoreDataHelper.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/7/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper : NSObject <NSXMLParserDelegate>

@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSManagedObjectModel *model;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, readonly) NSPersistentStore *store;

@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, readonly) NSManagedObjectContext *importContext;

- (void)setupCoreData;
- (void)saveContext;

+ (CoreDataHelper *)sharedCoreDataHelper;

@end
