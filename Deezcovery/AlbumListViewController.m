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
    
    [self loadAlbums];
    
    NSLog(@"test");
    
    NSLog(@"%ld",(unsigned long)[self.artistAlbums count]);
    
    for (Album *album in self.artistAlbums) {
        NSLog(@"OKOKOK");
        NSLog(album.title);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.albums reloadData];
    
    [self loadAlbums];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.artistAlbums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.albums dequeueReusableCellWithIdentifier:@"ALBUM_CELL_ID"];
    
    Album *album = self.artistAlbums[indexPath.row];
    cell.textLabel.text = album.title;
    
    NSData *dataPicture = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:album.cover]];
    cell.imageView.image = [UIImage imageWithData:dataPicture];
    
    return cell;
}

- (void) loadAlbums {
    self.artistAlbums = [@[] mutableCopy];
    
    Album *album = [[Album alloc]init];
    album.title = @"Toto";
    
    [self.artistAlbums addObject:album];
    
    [self.albums reloadData];
}


@end
