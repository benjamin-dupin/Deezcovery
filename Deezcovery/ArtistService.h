//
//  ArtistService.h
//  Deezcovery
//

#import <Foundation/Foundation.h>
#import "Artist.h"

@interface ArtistService : NSObject
+ (instancetype)sharedInstance;

- (NSMutableArray *) getRelatedArtists:(NSString *) artistName;

- (NSMutableArray *) getArtistsByArtistDpoArray:(NSArray *)artistDpoArray;

- (Artist *) getArtistById:(NSNumber*)artistId;
@end
