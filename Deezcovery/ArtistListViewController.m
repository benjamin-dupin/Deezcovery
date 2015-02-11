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

@interface ArtistListViewController ()

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

/**
 Click on Search Button
 */
- (IBAction)didTouchSearchButton:(id)sender {
    
    NSLog(@"Search");
    
    if ([self.searchTxtField.text length ] > 0) {
        
        self.relatedArtists = [[NSMutableArray alloc]init];
        
        self.relatedArtists = [self.artistService getRelatedArtists:self.searchTxtField.text];
        
        [self.artists reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.relatedArtists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.artists dequeueReusableCellWithIdentifier:@"ARTIST_CELL_ID"];
    
    Artist *artist = self.relatedArtists[indexPath.row];
    cell.textLabel.text = artist.name;
    
    NSData *dataPicture = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:artist.picture]];
    
    cell.imageView.image = [UIImage imageWithData:dataPicture];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ARTIST_SEGUE_ID"]){
        AlbumListViewController *controller = segue.destinationViewController;
        controller.artist = self.selectedArtist;
    }
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedArtist = self.relatedArtists[indexPath.row];
    [self performSegueWithIdentifier:@"ARTIST_SEGUE_ID" sender:self];
}

@end
