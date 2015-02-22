//
//  AlbumService.m
//  Deezcovery
//

#import "AlbumService.h"
#import "SessionManager.h"
#import "Album+JSONSerliazer.h"
#import "Album.h"

@implementation AlbumService
static AlbumService *sharedInstance = nil;

#pragma mark - Singleton Pattern -
+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (sharedInstance == nil)
            sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}
+ (id)allocWithZone:(NSZone *)zone{
    return [self sharedInstance];
}
- (id)copyWithZone:(NSZone *)zone{
    return self;
}
- (id)init{
    if(nil != (self = [super init]))
    {}
    return self;
}

- (NSMutableArray *)getAlbumsByArtist:(Artist *)artist {
    
    // Albums Array
    NSMutableArray *albums = [@[] mutableCopy];
    
    NSString *searchAlbumsUrl = [NSString stringWithFormat:@"%@%@%@", @"/artist/", artist._id, @"/albums"];
    NSString* jsonString = [[SessionManager sharedInstance] getDataFrom:searchAlbumsUrl];
    // Convertir String JSON en Dictionnary
    NSData *webData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
    
    for (NSDictionary *object in [jsonDict objectForKey:@"data"]) {
        Album *album = [Album albumFromJSON:object];
        [albums addObject:album];
    }
    
    return albums;
}

@end
