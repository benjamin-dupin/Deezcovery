//
//  AlbumService.h
//  Deezcovery
//

#import <Foundation/Foundation.h>
#import "Album.h"
#import "Artist.h"

@interface AlbumService : NSObject
#pragma mark - Singleton Pattern -
+ (instancetype)sharedInstance;

- (NSMutableArray *)getAlbumsByArtist:(Artist *)artist;

@end
