//
//  ArtistService.h
//  Deezcovery
//

#import <Foundation/Foundation.h>
#import "FavArtistDpo.h"
#import "Artist.h"

@interface ArtistService : NSObject
+ (instancetype)sharedInstance;

- (NSMutableArray *) getRelatedArtists:(NSString *) artistName;

- (NSMutableArray *) getArtistsByFavArtistDpos:(NSArray *)favArtistDpoArray;

- (Artist *) getArtistById:(NSNumber*)artistId;

- (BOOL) isArtistAlreadyInFav:(Artist *)artist;

- (void) addArtistToFavorite:(Artist *)artist;

- (void) removeArtistFromFavorite:(Artist *)artist;
@end
