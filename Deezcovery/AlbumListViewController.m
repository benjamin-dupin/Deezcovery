//
//  AlbumListViewController.m
//  Deezcovery
//

#import "ArtistService.h"
#import "DBManager.h"
#import "AlbumListViewController.h"
#import "AlbumService.h"
#import "Album.h"
#import "Artist.h"
#import "TrackListViewController.h"
#import "FavArtistDpo.h"
#import "FavAlbumDpo.h"
#import "FavTrackDpo.h"
#import "TrackService.h"

#define CELL_ID @"ALBUM_CELL_ID"
#define SEGUE_ID @"ALBUM_SEGUE_ID"

@interface AlbumListViewController ()

@property (strong, nonatomic) AlbumService *albumService;
@property (strong, nonatomic) Album *selectedAlbum;
@property (strong, nonatomic) NSMutableArray *artistAlbums;
@property (weak, nonatomic) IBOutlet UITableView *albums;
@property (weak, nonatomic) IBOutlet UINavigationBar *titleNavigationBar;

@end

@implementation AlbumListViewController

- (void)setupModel{
    self.albumService = [AlbumService sharedInstance];
}

- (void)configureOutlets{
    self.albums.delegate = self;
    self.albums.dataSource = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupModel];
    [self configureOutlets];
    
    [self setTitle:self.artist.name];
    
    [self loadAlbums];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.albums reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.artistAlbums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.albums dequeueReusableCellWithIdentifier:CELL_ID];
    
    // load cell artist
    
    Album *album = self.artistAlbums[indexPath.row];
    UIImage *image= album.UIcover;
    
    //if image is already saved
    if(image){
        cell.textLabel.text = album.title;
        cell.imageView.image = image;
    }else{
        //else it will be downloaded
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            
            //downloaded image
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:album.cover]];
            album.UIcover = [UIImage imageWithData:data];
            
            //put image in cells in an asynchronous way
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.textLabel.text = album.title;
                cell.imageView.image = album.UIcover ;
            });
        });
    }
    
    
    return cell;
}

- (void) loadAlbums {
    if (self.controlFav == YES) {
        [self loadAlbumsFromDatabase];
    } else {
        [self loadAlbumsFromDeezer];
    }
}

- (void) loadAlbumsFromDatabase {
    
    @try {
        DBManager *db = [DBManager sharedInstance];
        
        self.artistAlbums = [self.albumService getAlbumsByFavAlbumsArray:[db getAlbumsByArtist:[NSNumber numberWithInteger:[self.artist._id integerValue]]]];
        
        [self.albums reloadData];
    }
    @catch(NSException *exception) {
        
        //Gestion des exceptions
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Impossible to load favorites."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void) loadAlbumsFromDeezer {
    
    @try {
        
        self.artistAlbums = [self.albumService getAlbumsByArtist:self.artist];
        
        [self.albums reloadData];
        
        
        if ([self.artistAlbums count] == 0) {
            
            //Si on a récupéré 0 albums, on contrôle si c'est un favoris et on load depuis la base
            if ([[ArtistService sharedInstance]isArtistAlreadyInFav:self.artist] == YES) {
                [self loadAlbumsFromDatabase];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No album"
                                                                message:@"There is no album for this artist."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
        }
        
    }
    
    @catch(NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Can not find the albums."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)didTouchOnAddToFavButton:(id)sender {
    
    @try {
        // Si l'artiste n'est pas déjà en fav
        if ([[ArtistService sharedInstance]isArtistAlreadyInFav:self.artist] == NO) {
            
            // Alerte d'attente
            UIAlertView *baseAlert = [[UIAlertView alloc] initWithTitle:@"Please wait..."
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:nil];
            [baseAlert show];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
                
                // Mise en favoris
                [[ArtistService sharedInstance] addArtistToFavorite:self.artist];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // A la fin, on ferme l'alerte
                    [baseAlert dismissWithClickedButtonIndex:0 animated:YES];
                });
            });
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favorite"
                                                            message:@"This artist is already in your favorites. Do you want to want to delete it ?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Delete", nil];
            [alert show];
        }
        
    }
    
    @catch(NSException *exception) {
        
        //Gestion des exceptions
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Impossible to add to favorites."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // Méthode appelée quand on clique sur le bouton d'une UIAlertView
    
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Delete"]) {
        // Alerte d'attente
        UIAlertView *baseAlert = [[UIAlertView alloc] initWithTitle:@"Please wait..."
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
        [baseAlert show];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
            
            // Suppression du favoris
            [[ArtistService sharedInstance] removeArtistFromFavorite:self.artist];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // A la fin, on ferme l'alerte
                [baseAlert dismissWithClickedButtonIndex:0 animated:YES];
                
                //on revient à la page des favoris
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            
        });
        
        
        
        
    }
    
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SEGUE_ID]){
        TrackListViewController *controller = segue.destinationViewController;
        controller.album = self.selectedAlbum;
        controller.controlFav = self.controlFav;
        controller.artist = self.artist;
    }
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedAlbum = self.artistAlbums[indexPath.row];
    [self performSegueWithIdentifier:SEGUE_ID sender:self];
}

@end
