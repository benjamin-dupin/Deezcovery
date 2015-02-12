//
//  TrackService.h
//  Deezcovery
//
//  Created by B'n'J on 12/02/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"

@interface TrackService : NSObject
+ (instancetype)sharedInstance;

- (NSMutableArray *) getTracksByAlbum:(Album *) album;
@end
