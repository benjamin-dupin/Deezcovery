//
//  ArtistService.m
//  Deezcovery
//

#import "FavArtistDpo.h"
#import "ArtistService.h"
#import "SessionManager.h"
#import "Artist+JSONSerializer.h"

@implementation ArtistService

static ArtistService *sharedInstance = nil;

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


#pragma mark - Recherches artistes
- (NSMutableArray *) getRelatedArtists:(NSString *)artistName{
    
    /*
     Cette méthode cherche un artiste à partir d'un string
     puis cherche les artistes correspondant au premier artiste trouvé
     */
    
    // Artists Array
    NSMutableArray *artists = [@[] mutableCopy];
    
    // ======================
    // Recherche de l'artiste
    // ======================
    
    NSString *searchArtistUrl = [NSString stringWithFormat:@"%@%@", @"/search/artist?q=", artistName];
    NSString* jsonString = [[SessionManager sharedInstance] getDataFrom:searchArtistUrl];
    // Convertir String JSON en Dictionnary
    NSData *webData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
    
    // On récupère le premier artiste et on le met dans l'array
    NSDictionary *firstArtistFromSearch = [[jsonDict objectForKey:@"data"] objectAtIndex:0];
    Artist *firstArtist = [Artist artistFromJSON:firstArtistFromSearch];
    [artists addObject:firstArtist];
    
    // ==========================
    // Recherche artiste "related"
    // ==========================
    
    NSString *searchRelatedArtistsUrl = [NSString stringWithFormat:@"%@%@%@", @"/artist/", firstArtist._id, @"/related"];
    jsonString = [[SessionManager sharedInstance] getDataFrom:searchRelatedArtistsUrl];
    // Convertir String JSON en Dictionnary
    webData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    jsonDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
    
    // Pour chaque objet du Dico, on crée un Artist ou on le put dans l'array
    for (NSDictionary *object in [jsonDict objectForKey:@"data"]) {
        Artist *artist = [Artist artistFromJSON:object];
        [artists addObject:artist];
    }
    
    return artists;
}

- (NSMutableArray *) getArtistsByFavArtistDpos:(NSArray *)favArtistDpoArray {
    
    NSMutableArray *artists = [@[] mutableCopy];
    
    for (FavArtistDpo * favArtistDpo in favArtistDpoArray) {
        Artist * artist = [[Artist alloc]init];
        artist._id = [favArtistDpo.id stringValue];
        artist.name = favArtistDpo.name;
        artist.UIpicture = [UIImage imageWithData:favArtistDpo.picture];
        [artists addObject:artist];
    }
    
    return artists;
}

- (Artist *) getArtistById:(NSNumber *)artistId {
    
    NSString *searchArtistUrl = [NSString stringWithFormat:@"%@%@", @"/artist/", artistId];
    NSString* jsonString = [[SessionManager sharedInstance] getDataFrom:searchArtistUrl];
    // Convertir String JSON en Dictionnary
    NSData *webData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
    
    return [Artist artistFromJSON:jsonDict];
}

@end
