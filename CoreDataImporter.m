//
//  CoreDataImporter.m
//  Grocery Dude
//
//  Created by Tim Roadley on 20/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//

#import "CoreDataImporter.h"
@implementation CoreDataImporter
#define debug 1
+ (void)saveContext:(NSManagedObjectContext*)context {
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    [context performBlockAndWait:^{
        if ([context hasChanges]) {
            NSError *error = nil;
            if ([context save:&error]) {NSLog(
                                              @"CoreDataImporter SAVED changes from context to persistent store");
            } else {NSLog(
                          @"CoreDataImporter FAILED to save changes from context to persistent store: %@"
                          , error);
            }
        } else {NSLog(
                      @"CoreDataImporter SKIPPED saving context as there are no changes");
        }
    }];
}
- (CoreDataImporter*)initWithUniqueAttributes:(NSDictionary*)uniqueAttributes {
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    if (self = [super init]) {
        
        self.entitiesWithUniqueAttributes = uniqueAttributes;
        
        if (self.entitiesWithUniqueAttributes) {
            return self;
        } else {
            NSLog(@"FAILED to initialize CoreDataImporter: entitiesWithUniqueAttributes is nil");
            return nil;
        }
    }
    return nil;
}
- (NSString*)uniqueAttributeForEntity:(NSString*)entity {
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    return [self.entitiesWithUniqueAttributes valueForKey:entity];
}

- (NSManagedObject*)existingObjectInContext:(NSManagedObjectContext*)context
                                  forEntity:(NSString*)entity
                   withUniqueAttributeValue:(NSString*)uniqueAttributeValue {
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    NSString *uniqueAttribute = [self uniqueAttributeForEntity:entity];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"%K==%@",
     uniqueAttribute, uniqueAttributeValue];
    NSFetchRequest *fetchRequest =
    [NSFetchRequest fetchRequestWithEntityName:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    NSError *error;
    NSArray *fetchRequestResults =
    [context executeFetchRequest:fetchRequest error:&error];
    if (error) {NSLog(@"Error: %@", error.localizedDescription);}
    if (fetchRequestResults.count == 0) {return nil;}
    return fetchRequestResults.lastObject;
}

- (NSManagedObject*)insertUniqueObjectInTargetEntity:(NSString*)entity
                                uniqueAttributeValue:(NSString*)uniqueAttributeValue
                                     attributeValues:(NSDictionary*)attributeValues
                                           inContext:(NSManagedObjectContext*)context {
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    NSString *uniqueAttribute = [self uniqueAttributeForEntity:entity];
    if (uniqueAttributeValue.length > 0) {
        NSManagedObject *existingObject =
        [self existingObjectInContext:context
                            forEntity:entity
             withUniqueAttributeValue:uniqueAttributeValue];
        if (existingObject) {
            NSLog(@"%@ object with %@ value '%@' already exists",
                  entity, uniqueAttribute, uniqueAttributeValue);
            return existingObject;
        } else {
            NSManagedObject *newObject =
            [NSEntityDescription insertNewObjectForEntityForName:entity
                                          inManagedObjectContext:context];
            [newObject setValuesForKeysWithDictionary:attributeValues];
            NSLog(@"Created %@ object with %@ '%@'",
                  entity, uniqueAttribute, uniqueAttributeValue);
            return newObject;
        }
    } else {
        NSLog(@"Skipped %@ object creation: unique attribute value is 0 length",
              entity);
    }
    return nil;
}

- (NSManagedObject*)insertBasicObjectInTargetEntity:(NSString*)entity
                              targetEntityAttribute:(NSString*)targetEntityAttribute
                                 sourceXMLAttribute:(NSString*)sourceXMLAttribute
                                      attributeDict:(NSDictionary*)attributeDict
                                            context:(NSManagedObjectContext*)context {
    
    NSArray *attributes = [NSArray arrayWithObject:targetEntityAttribute];
    NSArray *values =
    [NSArray arrayWithObject:[attributeDict valueForKey:sourceXMLAttribute]];
    
    NSDictionary *attributeValues =
    [NSDictionary dictionaryWithObjects:values forKeys:attributes];
    
    return [self insertUniqueObjectInTargetEntity:entity
                             uniqueAttributeValue:[attributeDict valueForKey:sourceXMLAttribute]
                                  attributeValues:attributeValues
                                        inContext:context];
}

@end
