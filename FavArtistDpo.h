//
//  FavArtistDpo.h
//  Deezcovery
//
//  Created by B'n'J on 27/02/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FavArtistDpo : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSString * name;

@end
