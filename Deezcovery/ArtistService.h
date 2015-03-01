//
//  ArtistService.h
//  Deezcovery
//

#import <Foundation/Foundation.h>
#import "Artist.h"

@interface ArtistService : NSObject
+ (instancetype)sharedInstance;

- (NSMutableArray *) getRelatedArtists:(NSString *) artistName;

- (NSMutableArray *) getArtistsByFavArtistDpos:(NSArray *)favArtistDpoArray;

- (Artist *) getArtistById:(NSNumber*)artistId;
@end
