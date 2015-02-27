//
//  FavAlbumDpo.h
//  Deezcovery
//
//  Created by B'n'J on 27/02/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FavArtistDpo;

@interface FavAlbumDpo : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSData * cover;
@property (nonatomic, retain) FavArtistDpo *artist;

@end
