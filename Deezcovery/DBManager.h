//
//  ScripteDB.h
//
//  Created by Julien Sarazin on 17/04/13.
//  Copyright (c) 2013 simpleApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FavArtistDpo.h"

@interface DBManager : NSObject

#pragma mark - singleton creation pattern
+ (id)sharedInstance;

#pragma mark - Generic Core data entity deletion -
- (void)deleteManagedObject:(NSManagedObject *)object;

#pragma mark - Generic Core data Managed Object creation -
- (id)createManagedObjectWithName:(NSString *)entityName;
- (id)createManagedObjectWithClass:(Class)entityClass;
- (id)createTemporaryObjectWithClass:(Class)entityClass;

#pragma mark - DB features
- (BOOL)persistData;
- (void)refreshObject:(NSManagedObject *)managedObject mergeChanges:(BOOL)flag;


#pragma mark - Domain related feature -
- (NSArray *)fetchArtists;
- (NSArray *)fetchAllByName:(NSString *)enityName;
- (FavArtistDpo *) getFavArtistById:(NSNumber *)artistId;
- (NSArray *) getAlbumsByArtist:(NSNumber *)artistId;
- (NSArray *) getTracksByAlbum:(NSNumber *)albumId;
@end