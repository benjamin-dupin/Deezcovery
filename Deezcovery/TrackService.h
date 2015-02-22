//
//  TrackService.h
//  Deezcovery
//

#import <Foundation/Foundation.h>
#import "Album.h"

@interface TrackService : NSObject
+ (instancetype)sharedInstance;

- (NSMutableArray *) getTracksByAlbum:(Album *) album;
@end
