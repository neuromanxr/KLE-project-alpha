//
//  CoreDataHelper.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/7/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "CoreDataImporter.h"
#import "CoreDataHelper.h"

@interface CoreDataHelper ()

@property (nonatomic, retain) UIAlertView *importAlertView;

@end

@implementation CoreDataHelper

#define debug 1

#pragma mark - FILES
NSString *storeFilename = @"GymBro.sqlite";

#pragma mark - PATHS
- (NSString *)applicationDocumentsDirectory
{
//    if (debug == 1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSURL *)applicationStoresDirectory
{
//    if (debug == 1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    NSURL *storesDirectory = [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]] URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtURL:storesDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
            if (debug == 1) {
                NSLog(@"Successfully created Stores directory");
            } else {
                NSLog(@"FAILED to create Stores directory: %@", error);
            }
        }
    }
    return storesDirectory;
}

- (NSURL *)storeURL
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[self applicationStoresDirectory]
            URLByAppendingPathComponent:storeFilename];
}

#pragma mark - SETUP

- (id)init
{
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    self = [super init];
    if (!self) {return nil;}
    
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    _coordinator = [[NSPersistentStoreCoordinator alloc]
                    initWithManagedObjectModel:_model];
    _context = [[NSManagedObjectContext alloc]
                initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_context setPersistentStoreCoordinator:_coordinator];
    
    // importContext
    _importContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_importContext setPersistentStoreCoordinator:_coordinator];
    [_importContext setUndoManager:nil];
    
    return self;
}

// uncomment NSSQLitePragmasOption to disable WAL journaling
- (void)loadStore
{
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    if (_store) {return;} // Don’t load store if it's already loaded
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption:@YES,
                              NSInferMappingModelAutomaticallyOption:@YES,
//                              NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}
                              };
    NSError *error = nil;
    _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:[self storeURL]
                                              options:options error:&error];
    if (!_store) {NSLog(@"Failed to add store. Error: %@", error);abort();}
    else         {if (debug==1) {NSLog(@"Successfully added store: %@", _store);}}
}

- (void)setupCoreData
{
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    
    // preloaded default data
    [self setDefaultDataStoreAsInitialStore];
    
    [self loadStore];
    
    [self checkIfDefaultDataNeedsImporting];
}

#pragma mark - SAVING

- (void)saveContext
{
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    if ([_context hasChanges]) {
        NSError *error = nil;
        if ([_context save:&error]) {
            NSLog(@"_context SAVED changes to persistent store");
        } else {
            NSLog(@"Failed to save _context: %@", error);
        }
    } else {
        NSLog(@"SKIPPED _context save, there are no changes!");
    }
}

#pragma mark - DELEGATE: UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    if (alertView == self.importAlertView) {
        if (buttonIndex == 1) {
            // import button
            NSLog(@"Default Data Import Yes");
            [_importContext performBlock:^{
                // XML Import
                [self importFromXML:[[NSBundle mainBundle] URLForResource:@"exercises" withExtension:@"xml"]];
            }];
        } else {
            NSLog(@"Default Data Import No");
        }
        // set the data as imported regardless of the user's decision
        [self setDefaultDataAsImportedForStore:_store];
    }
}

#pragma mark - DATA IMPORT

- (void)setDefaultDataAsImportedForStore:(NSPersistentStore *)aStore
{
//    if (debug == 1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    // get metadata dictionary
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[[aStore metadata] copy]];
//    if (debug == 1) {
//        NSLog(@"_Store metadata BEFORE changes_ \n %@", dictionary);
//    }
    
    // edit metadata dictionary
    [dictionary setObject:@YES forKey:@"DefaultDataImported"];
    
    // set metadata dictionary
    [self.coordinator setMetadata:dictionary forPersistentStore:aStore];
    
//    if (debug == 1) {
//        NSLog(@"_Store metadata AFTER changes_ \n %@", dictionary);
//    }
}

- (void)importFromXML:(NSURL *)url
{
//    if (debug == 1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    self.parser.delegate = self;
    
    NSLog(@"**** START PARSE OF %@", url.path);
    [self.parser parse];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
    NSLog(@"**** END PARSE OF %@", url.path);
}

- (void)checkIfDefaultDataNeedsImporting
{
//    if (debug == 1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    if (![self isDefaultDataAlreadyImportedForStoreWithURL:[self storeURL] ofType:NSSQLiteStoreType]) {
        self.importAlertView = [[UIAlertView alloc] initWithTitle:@"Import Default Data" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Import", nil];
        
        [self.importAlertView show];
    }
}

- (BOOL)isDefaultDataAlreadyImportedForStoreWithURL:(NSURL *)url ofType:(NSString *)type
{
//    if (debug == 1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    NSError *error;
    NSDictionary *dictionary = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:type
                                                                                          URL:url
                                                                                        error:&error];
    if (error) {
        NSLog(@"Error reading persistent store metadata: %@", error.localizedDescription);
    } else {
        NSNumber *defaultDataAlreadyImported = [dictionary valueForKey:@"DefaultDataImported"];
        if (![defaultDataAlreadyImported boolValue]) {
            NSLog(@"Default Data has NOT already been imported");
            return NO;
        }
    }
    if (debug == 1) {
        NSLog(@"Default Data HAS already been imported");
    }
    return YES;
}

- (void)setDefaultDataStoreAsInitialStore
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[self storeURL].path]) {
        NSURL *defaultDataURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"DefaultData" ofType:@"sqlite"]];
        NSError *error;
        if (![fileManager copyItemAtURL:defaultDataURL toURL:[self storeURL] error:&error]) {
            NSLog(@"DefaultData.sqlite copy FAIL: %@", error.localizedDescription);
        }
        else
        {
            NSLog(@"A copy of DefaultData.sqlite was set as the initial store for %@", [self storeURL].path);
        }
    }
}

#pragma mark - DELEGATE: NSXMLParser (CUSTOM)

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if (debug == 1) {
        NSLog(@"Parser Error: %@", parseError.localizedDescription);
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [self.importContext performBlockAndWait:^{
        // STEP 1: Process only the 'item' element in the XML file
        if ([elementName isEqualToString:@"exercise"]) {
            // STEP 2: Prepare the Core Data Importer
            CoreDataImporter *importer = [[CoreDataImporter alloc] initWithUniqueAttributes:[self selectedUniqueAttributes]];
            
            // STEP 3a: Insert a unique 'KLEExercise' object
            NSManagedObject *KLEExercise = [importer insertBasicObjectInTargetEntity:@"KLEExercise" targetEntityAttribute:@"exercisename" sourceXMLAttribute:@"exercisename" attributeDict:attributeDict context:_importContext];
            
            // STEP 3b: Insert a unique
            
            // STEP 4: Manually add extra attribute values
            // attributes for entity is in attributeDict
            if ([attributeDict valueForKey:@"musclegroup"]) {
                [KLEExercise setValue:[attributeDict valueForKey:@"musclegroup"] forKey:@"musclegroup"];
            }
            
            // STEP 5: Create relationships
            
            // STEP 6: Save new objects to the persistent store
            [CoreDataImporter saveContext:_importContext];
            
            // STEP 7: Turn objects into faults to save memory
            [_importContext refreshObject:KLEExercise mergeChanges:NO];
        }
    }];
}

#pragma mark - UNIQUE ATTRIBUTE SELECTION (CUSTOM)

- (NSDictionary *)selectedUniqueAttributes
{
//    if (debug == 1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    NSMutableArray *entities = [NSMutableArray new];
    NSMutableArray *attributes = [NSMutableArray new];
    
    // select an attribute in each entity for uniqueness
    [entities addObject:@"KLEExercise"]; [attributes addObject:@"exercisename"];
//    [entities addObject:@"KLEExercise"]; [attributes addObject:@"muscle"];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:attributes forKeys:entities];
    
    return dictionary;
}

@end
