//
//  FavTrackDpo.h
//  Deezcovery
//
//  Created by B'n'J on 27/02/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FavAlbumDpo;

@interface FavTrackDpo : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSData * track;
@property (nonatomic, retain) FavAlbumDpo *album;

@end