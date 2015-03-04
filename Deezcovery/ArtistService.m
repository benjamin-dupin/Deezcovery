//
//  ArtistService.m
//  Deezcovery
//

#import "Album.h"
#import "Track.h"
#import "AlbumService.h"
#import "TrackService.h"
#import "FavArtistDpo.h"
#import "FavAlbumDpo.h"
#import "FavTrackDpo.h"
#import "ArtistService.h"
#import "SessionManager.h"
#import "Artist+JSONSerializer.h"
#import "DBManager.h"

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

- (BOOL) isArtistAlreadyInFav:(Artist *)artist {
    if ([[DBManager sharedInstance]
         getFavArtistById:
         [NSNumber numberWithInteger:[artist._id integerValue]]] == nil) {
        return NO;
    } else {
        return YES;
    }
}

- (void) addArtistToFavorite:(Artist *)artist {
    
    DBManager * db = [DBManager sharedInstance];
    
    // Création du FavArtistDpo
    FavArtistDpo * favArtist = [db createManagedObjectWithName:NSStringFromClass([FavArtistDpo class])];
    favArtist.id = [NSNumber numberWithInteger:[artist._id integerValue]];
    favArtist.name = artist.name;
    favArtist.picture = UIImagePNGRepresentation(artist.UIpicture);
    
    NSLog(@"Artist : %@", favArtist.name);
    
    // Pour chaque Album de l'Artist
    for(Album * album in [[AlbumService sharedInstance]getAlbumsByArtist:artist]) {
        
        // Création du FavAlbumDpo
        FavAlbumDpo * favAlbum = [db createManagedObjectWithName:NSStringFromClass([FavAlbumDpo class])];
        favAlbum.id =  [NSNumber numberWithInteger:[album._id integerValue]];
        favAlbum.title = album.title;
        favAlbum.cover = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:album.cover]];
        favAlbum.artist = favArtist;
        
        NSLog(@"Album : %@",favAlbum.title);
        
        // Pour chaque Track de l'Album
        for (Track * track in [[TrackService sharedInstance]getTracksByAlbum:album]) {
            
            // Création du FavTrackDpo
            FavTrackDpo * favTrack = [db createManagedObjectWithName:NSStringFromClass([FavTrackDpo class])];
            favTrack.id = [NSNumber numberWithInteger:[track._id integerValue]];
            favTrack.title = track.title;
            favTrack.track = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:track.preview]];
            favTrack.album = favAlbum;
            
            NSLog(@"Track : %@",track.title);
            
        }
    }
    
    // Commit
    [db persistData];
}

- (void) removeArtistFromFavorite:(Artist *)artist {
    
    DBManager * db = [DBManager sharedInstance];
    
    // Récupération du favArtist
    FavArtistDpo * favArtist = [db getFavArtistById:[NSNumber numberWithInteger:[artist._id integerValue]]];
    
    // Pour chaque FavAlbumDpo du favArtist
    for (FavAlbumDpo * favAlbum in [db getAlbumsByArtist:favArtist.id]) {
        
        // Pour chaque FavTrackDpo du favAlbum
        for (FavTrackDpo * favTrack in [db getTracksByAlbum:favAlbum.id]) {
            
            // Supppression du favTrack
            [db deleteManagedObject:favTrack];
        }
        
        // Suppression du favAlbum
        [db deleteManagedObject:favAlbum];
    }
    
    // Suppresssion du favArtist;
    [db deleteManagedObject:favArtist];
    
    // Commit
    [db persistData];
}

@end
