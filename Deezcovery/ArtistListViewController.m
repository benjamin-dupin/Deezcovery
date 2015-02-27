//
//  ArtistListViewController.m
//  Deezcovery
//

#import "AlbumListViewController.h"
#import "ArtistListViewController.h"
#import "ArtistService.h"
#import "Artist.h"
#import "DBManager.h"
#import "ArtistDpo.h"

#define CELL_ID @"ARTIST_CELL_ID"
#define SEGUE_ID @"ARTIST_SEGUE_ID"

@interface ArtistListViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTxtField;
@property (weak, nonatomic) IBOutlet UITableView *artists;
@property (weak, nonatomic) ArtistService *artistService;
@property (weak, nonatomic) Artist *selectedArtist;
@property (strong, nonatomic) NSMutableArray *relatedArtists;
@end

@implementation ArtistListViewController

- (void)setupModel{
    self.artistService = [ArtistService sharedInstance];
}

- (void)configureOutlets{
    self.artists.delegate = self;
    self.artists.dataSource = self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupModel];
    [self configureOutlets];
    
    //DEBUT AJOUT VLE
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handledLongPress:)];
    //longPressRecognizer.minimumPressDuration = 2.0f;
    [self.artists addGestureRecognizer:longPressRecognizer];
    //FIN AJOUT VLE
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.artists reloadData];
}

#pragma mark - Click on "Search" button
- (IBAction)didTouchSearchButton:(id)sender {
    
    // Méthode appelée quand on clique sur le boutton de la loupe
    
    @try {
        
        if ([self.searchTxtField.text length ] > 0) {
            
            // Si le text field est renseigné
            
            self.relatedArtists = [[NSMutableArray alloc]init];
            
            self.relatedArtists = [self.artistService getRelatedArtists:self.searchTxtField.text];
            
            [self.artists reloadData];
        }
        
    }
    
    @catch(NSException *exception) {
        
        //Gestion des exceptions
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Impossible to find this artist."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
- (IBAction)didTouchFavButton:(id)sender {
    
    // Click sur l'étoile pour voir les favoris
    
    @try {
        
        DBManager *db = [DBManager sharedInstance];
        
        // Récupérer les favoris
        NSArray * favoriteArtists = [db fetchAllByName:NSStringFromClass([ArtistDpo class])];
        
        if ([favoriteArtists count] == 0) {
            // Si aucun favoris
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No favorite"
                                                            message:@"You do not have any favorites"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        } else {
            // Sinon, convertion ArtistDpo -> Artist
            self.relatedArtists = [[NSMutableArray alloc]init];
            self.relatedArtists = [self.artistService getArtistsByArtistDpoArray:favoriteArtists];
            [self.artists reloadData];
        }
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.relatedArtists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // load cell artist
    
    UITableViewCell *cell = [self.artists dequeueReusableCellWithIdentifier:CELL_ID];
    
    Artist *artist = self.relatedArtists[indexPath.row];
    UIImage *image= artist.UIpicture;
    
    //if image is already saved
    if(image){
        cell.textLabel.text = artist.name;
        cell.imageView.image = image;
    }else{
        //else it will be downloaded
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            
            //downloaded image
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:artist.picture]];
            artist.UIpicture = [UIImage imageWithData:data];
            
            //put image in cells in an asynchronous way
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.textLabel.text = artist.name;
                cell.imageView.image = artist.UIpicture ;
            });
        });
    }
    
    // Chargement sync des images
    //NSData *dataPicture = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:artist.picture]];
    //cell.imageView.image = [UIImage imageWithData:dataPicture];
    
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SEGUE_ID]){
        AlbumListViewController *controller = segue.destinationViewController;
        controller.artist = self.selectedArtist;
    }
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedArtist = self.relatedArtists[indexPath.row];
    [self performSegueWithIdentifier:SEGUE_ID sender:self];
}


//DEBUT AJOUT VLE
- (IBAction)handledLongPress:(id)sender {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favorite"
//                                                    message:@"This artist is already in your favorites. Do you want to want to delete it ?"
//                                                   delegate:self
//                                          cancelButtonTitle:@"Cancel"
//                                          otherButtonTitles:@"Delete", nil];
//    [alert show];
}
//FIN AJOUT VLE
@end
