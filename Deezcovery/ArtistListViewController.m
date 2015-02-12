//
//  ArtistListViewController.m
//  Deezcovery
//
//  Created by B'n'J on 20/01/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import "AlbumListViewController.h"
#import "ArtistListViewController.h"
#import "ArtistService.h"
#import "Artist.h"

#define CELL_ID @"ARTIST_CELL_ID"
#define SEGUE_ID @"ARTIST_SEGUE_ID"

@interface ArtistListViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTxtField;

@property (weak, nonatomic) IBOutlet UITableView *artists;
@property (weak, nonatomic) ArtistService *artistService;
@property (strong, nonatomic) NSMutableArray *relatedArtists;
@property (weak, nonatomic) Artist *selectedArtist;


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
    
    @try {
        
        if ([self.searchTxtField.text length ] > 0) {
            
            self.relatedArtists = [[NSMutableArray alloc]init];
            
            self.relatedArtists = [self.artistService getRelatedArtists:self.searchTxtField.text];
            
            [self.artists reloadData];
        }
        
    }
    
    @catch(NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Can not find the artist..."
                                                       delegate:self
                                              cancelButtonTitle:@"OK :-("
                                              otherButtonTitles:nil];
        [alert show];
    }
}
- (IBAction)didTouchFavButton:(id)sender {
    
    /*
     TODO
     */
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TODO"
                                                    message:@"Gérer les favoris"
                                                   delegate:self
                                          cancelButtonTitle:@"..."
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.relatedArtists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.artists dequeueReusableCellWithIdentifier:CELL_ID];
    
    Artist *artist = self.relatedArtists[indexPath.row];
    cell.textLabel.text = artist.name;
    
    // FIXME : Voir avec le prof
    // Bug dans le chargement
    // Chargement async des images
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *dataPicture = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:artist.picture]];
        cell.imageView.image = [UIImage imageWithData:dataPicture];
    });
    
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

@end
