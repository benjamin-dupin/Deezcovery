//
//  ViewController.m
//  TodoList
//
//  Created by Julien Sarazin on 16/11/14.
//  Copyright (c) 2014 Julien Sarazin. All rights reserved.
//

#import "AlbumListViewController.h"
#import "AlbumService.h"
#import "Album.h"
#import "Artist.h"
#import "TrackListViewController.h"

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
    
    Album *album = self.artistAlbums[indexPath.row];
    cell.textLabel.text = album.title;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *dataPicture = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:album.cover]];
        cell.imageView.image = [UIImage imageWithData:dataPicture];
    });
    
    return cell;
}

- (void) loadAlbums {
    
    @try {
        
        self.artistAlbums = [self.albumService getAlbumsByArtist:self.artist];
        
        [self.albums reloadData];
        
        if ([self.artistAlbums count] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No album"
                                                            message:@"There is no album for this artist."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK :-("
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        
    }
    
    @catch(NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Can not find the albums..."
                                                       delegate:self
                                              cancelButtonTitle:@"OK :-("
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)didTouchOnAddToFavButton:(id)sender {
    
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

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SEGUE_ID]){
        TrackListViewController *controller = segue.destinationViewController;
        controller.album = self.selectedAlbum;
    }
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedAlbum = self.artistAlbums[indexPath.row];
    [self performSegueWithIdentifier:SEGUE_ID sender:self];
}

@end
