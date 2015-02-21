//
//  ScripteDB.m
//  SimpleScripte
//
//  Created by Julien Sarazin on 17/04/13.
//  Copyright (c) 2013 simpleApp. All rights reserved.
//

#import "DBManager.h"

#define Persistance_Directory   @"Persistence"
#define SQlite_DB_Filename      @"ARTISTDPO.sqlite"

@interface DBManager ()

@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) NSManagedObjectModel *mom;
@property (strong, nonatomic) NSPersistentStoreCoordinator *psc;
@property (strong, nonatomic) NSPersistentStore *ps;
@end

@implementation DBManager

#pragma mark - singleton creation pattern
static DBManager *sharedInstance = nil;
+ (id)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (sharedInstance == nil)
            sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}
+ (id)allocWithZone:(NSZone *)zone{
    return [self sharedInstance];
}
- (id)copyWithZone:(NSZone *)zone{
    return self;
}
- (id)init{
    if(nil != (self = [super init])){
        _moc = [[NSManagedObjectContext alloc] init];
        _mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Deezcovery" withExtension:@"momd"]];
        _psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_mom];
        
        [_moc setPersistentStoreCoordinator:_psc];
        [self createPersistentStore];
    }
    return self;
}


-(void)createPersistentStore{
    if ([[_psc persistentStores] count] > 0){
        NSLog(@"addPersistentStoreToCoordinator : store coordinator already has one store");
        return;
    }
    
    NSURL *storePathURL = [[NSURL alloc] initFileURLWithPath:[self getPersistentStorePathWithType:NSSQLiteStoreType]];
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption: [NSNumber numberWithBool:YES],
                              NSInferMappingModelAutomaticallyOption: [NSNumber numberWithBool:YES]
                              };
    NSError *error;
    _ps = [_psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storePathURL options:options error:&error];
    
    if(_ps == nil){
        NSLog(@"StoreURL: %@", storePathURL.absoluteString);
        NSLog(@"Adding persistentStore to the coordinator failed with error:\n %@, %@", error.localizedDescription, error.userInfo);
        return;
    }
}

- (BOOL)persistData{
    NSError *error = nil;
    [_moc save:&error];
    
    if(nil != error){
        NSLog(@"PersistData failed with errors: \n%@\n%@", error.localizedDescription, error.userInfo);
        return NO;
    }
    NSLog(@"Data saved.");
    return YES;
}

- (void)refreshObject:(NSManagedObject *)managedObject mergeChanges:(BOOL)flag{
    [_moc refreshObject:managedObject mergeChanges:flag];
}


#pragma mark - Tools -
-(NSArray *)fetchEntity:(NSString *)entityName predicate:(NSPredicate *)predicate prefetchedRelations:(NSArray *)prefetchedRelationKeys sortKey:(NSString *)sortKey ascending:(BOOL)ascending error:(NSError **)error
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:_moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entityDescription;
    
    if (predicate)
        request.predicate = predicate;
    
    if (sortKey){
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
        request.sortDescriptors = @[sortDescriptor];
    }
    
    if (prefetchedRelationKeys)
        [request setRelationshipKeyPathsForPrefetching:prefetchedRelationKeys];
    
    NSArray *result = [_moc executeFetchRequest:request error:error];
    if (error && *error != nil)
        NSLog(@"fetchEntity failed with errors: \n%@\n%@", [(*error) localizedDescription], [(*error) userInfo]);
    
    return result;
}

#pragma mark - Entity creation
- (id)createManagedObjectWithName:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:_moc];
}

- (id)createManagedObjectWithClass:(Class)entityClass
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(entityClass)
                                         inManagedObjectContext:_moc];
}

- (id)createTemporaryObjectWithClass:(Class)entityClass
{
    return [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:NSStringFromClass(entityClass)
                                                               inManagedObjectContext:_moc] insertIntoManagedObjectContext:nil];
}

#pragma mark - Generic Core data entity deletion
- (void)deleteManagedObject:(NSManagedObject *)object
{
    [_moc deleteObject:object];
}

#pragma mark - Utils -
#pragma mark - standards iOS directories
- (NSString *)getDocumentDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSString *)getLibraryDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSString *)getCacheDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}


#pragma mark - CoreData db path
- (NSString *)getPersistentStorePathWithType:(NSString *)type
{
    if ([type isEqualToString:NSSQLiteStoreType])
    {
        NSString *path = [[self getLibraryDirectoryPath] stringByAppendingPathComponent:Persistance_Directory];
        
        [self createDirIfNotExists:path];
        return [path stringByAppendingPathComponent:SQlite_DB_Filename];
    }
    NSLog(@"Unrecognized Persistent store type.");
    return nil;
}

-(BOOL)createDirIfNotExists:(NSString *)path
{
    NSError *error = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDir;
    if(![manager fileExistsAtPath:path isDirectory:&isDir])
    {
        if(![manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Creating photos directory failed with error: %@, %@", error.localizedDescription, error.userInfo);
            return NO;
        }
    }
    return YES;
}


#pragma mark - domain related features -
- (NSArray *)fetchArtists{
    return [self fetchEntity:@"ArtistDpo" predicate:nil prefetchedRelations:nil sortKey:nil ascending:YES error:nil];
}
@end