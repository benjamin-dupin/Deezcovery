//
//  Album.h
//  Deezcovery
//

#import <Foundation/Foundation.h>
#import "Artist.h"

@interface Album : NSObject
@property (strong, nonatomic) Artist *artist;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *cover;
@property (strong, nonatomic) NSString *genre_id;
@property (strong, nonatomic) NSString *record_type;
@property (strong, nonatomic) NSString *tracklist;
@property (assign, nonatomic) BOOL explicit_lyrics;
@property (assign, nonatomic) NSString *type;
@property (assign, nonatomic) NSString *_id;

@end
