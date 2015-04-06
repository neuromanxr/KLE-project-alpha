//
//  CoreDataAccess.h
//  Barbell Bro
//
//  Created by Kelvin Lee on 4/6/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataAccess : NSObject <NSXMLParserDelegate>

@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSManagedObjectModel *model;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, readonly) NSPersistentStore *store;

@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, readonly) NSManagedObjectContext *importContext;

- (void)setupCoreData;
- (void)saveContext;

+ (CoreDataAccess *)sharedCoreDataAccess;

@end
