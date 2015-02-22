//
//  TrackService.m
//  Deezcovery
//

#import "TrackService.h"
#import "Track.h"
#import "SessionManager.h"
#import "Track+JSONSerializer.h"

@implementation TrackService

static TrackService *sharedInstance = nil;

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

- (NSMutableArray *) getTracksByAlbum:(Album *)album {
    
    // Récupérer les tracks pour un album
    
    NSMutableArray *tracks = [@[] mutableCopy];
    
    NSString *searchTracksUrl = [NSString stringWithFormat:@"%@%@%@", @"/album/", album._id, @"/tracks"];
    NSString* jsonString = [[SessionManager sharedInstance] getDataFrom:searchTracksUrl];
    // Convertir String JSON en Dictionnary
    NSData *webData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
    
    for (NSDictionary *object in [jsonDict objectForKey:@"data"]) {
        Track *track = [Track trackFromJSON:object];
        [tracks addObject:track];
    }
    
    return tracks;
}


@end
