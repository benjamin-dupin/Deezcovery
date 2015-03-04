//
//  ArtistListViewController.m
//  Deezcovery
//

#import "AlbumListViewController.h"
#import "ArtistListViewController.h"
#import "ArtistService.h"
#import "Artist.h"
#import "DBManager.h"

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
@property (assign) BOOL controlFav; //Controle si la liste des favoris est affichée ou non
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
    
    //Gestion clic long
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handledLongPress:)];
    longPressRecognizer.minimumPressDuration = 1.0f;
    [self.artists addGestureRecognizer:longPressRecognizer];
    
    //Initialisation du controle de l'affichage des favoris ou non
    self.controlFav = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Reload la liste des favoris si elle a été modifiée
    if (self.controlFav == YES) {
        DBManager * db = [DBManager sharedInstance];
        NSArray * favoriteArtists = [db fetchAllByName:NSStringFromClass([FavArtistDpo class])];
        self.relatedArtists = [self.artistService getArtistsByFavArtistDpos:favoriteArtists];
    }
    
    [self.artists reloadData];
}

#pragma mark - Click on "Search" button
- (IBAction)didTouchSearchButton:(id)sender {
    
    // Méthode appelée quand on clique sur le boutton de la loupe
    
    @try {
        
        // Si le text field est renseigné
        if ([self.searchTxtField.text length ] > 0) {
            
            self.relatedArtists = [[NSMutableArray alloc]init];
            self.relatedArtists = [self.artistService getRelatedArtists:self.searchTxtField.text];
            
            [self.artists reloadData];
            
            self.controlFav = NO;
        }
    }
    
    @catch(NSException *exception) {
        
        //Gestion des exceptions
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Can not find this artist."
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
        NSArray * favArtists = [db fetchAllByName:NSStringFromClass([FavArtistDpo class])];
        
        // Si aucun favoris
        if ([favArtists count] == 0) {
            // Si aucun favoris
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No favorite"
                                                            message:@"You do not have any favorites"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
        // Sinon, récupération des favoris
        else {
            self.controlFav = YES;
            
            self.relatedArtists = [[NSMutableArray alloc]init];
            self.relatedArtists = [self.artistService getArtistsByFavArtistDpos:favArtists];
            
            [self.artists reloadData];
        }
        
    }
    
    @catch(NSException *exception) {
        
        //Gestion des exceptions
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Can not load favorites."
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
    
    // Chargement async des images
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
    
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SEGUE_ID]){
        AlbumListViewController *controller = segue.destinationViewController;
        controller.artist = self.selectedArtist;
        controller.controlFav = self.controlFav;
    }
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedArtist = self.relatedArtists[indexPath.row];
    [self performSegueWithIdentifier:SEGUE_ID sender:self];
}


//Clique long pour ajout/suppression de favoris
- (IBAction)handledLongPress:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer*)sender;
    UIGestureRecognizerState state = longPress.state;
    if (state == UIGestureRecognizerStateBegan) {
        
        //Contrôle qu'on clique sur un item de la TableView
        CGPoint location = [longPress locationInView:self.artists];
        NSIndexPath *indexPath = [self.artists indexPathForRowAtPoint:location];
        if (indexPath) {
            
            //On récupère l'artiste
            self.selectedArtist = self.relatedArtists[indexPath.row];
            
            //Si l'artiste n'est pas en favori
            if ([self.artistService isArtistAlreadyInFav:self.selectedArtist] == NO) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favorite"
                                                                message:@"Add this artist to your favorites ?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Add", nil];
                [alert show];
            }
            //Si l'artiste est un favori
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favorite"
                                                                message:@"Remove this artist from your favorites ?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Remove", nil];
                [alert show];
            }
        }
    }
}

//Gestion des actions des UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // Méthode appelée quand on clique sur le bouton d'une UIAlertView
    DBManager * db = [DBManager sharedInstance];
    
    // Bouton Suppression
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Remove"]) {
        
        // Alerte d'attente
        UIAlertView *baseAlert = [[UIAlertView alloc] initWithTitle:@"Please wait..."
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
        [baseAlert show];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
            
            // Suppression du favoris
            [self.artistService removeArtistFromFavorite:self.selectedArtist];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // A la fin, on ferme l'alerte
                [baseAlert dismissWithClickedButtonIndex:0 animated:YES];
                
                //On met à jour l'affichage de la liste des favoris si on est en train de l'afficher
                if (self.controlFav == YES) {
                    NSArray * favoriteArtists = [db fetchAllByName:NSStringFromClass([FavArtistDpo class])];
                    self.relatedArtists = [self.artistService getArtistsByFavArtistDpos:favoriteArtists];
                    [self.artists reloadData];
                }
            });
        });
        
        
    }
    // Bouton ajout dans les favoris
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Add"]) {
        
        // Alerte d'attente
        UIAlertView *baseAlert = [[UIAlertView alloc] initWithTitle:@"Please wait..."
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
        [baseAlert show];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
            
            // Mise en favoris
            [self.artistService addArtistToFavorite:self.selectedArtist];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // A la fin, on ferme l'alerte
                [baseAlert dismissWithClickedButtonIndex:0 animated:YES];
            });
        });
    }
}
@end
