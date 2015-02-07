//
//  ArtistListViewController.m
//  Deezcovery
//
//  Created by B'n'J on 20/01/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import "ArtistListViewController.h"
#import "ArtistService.h"
#import "Artist.h"

@interface ArtistListViewController ()

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTxtField;
@property (weak, nonatomic) IBOutlet UITableView *artists;
@property (weak, nonatomic) ArtistService *artistService;
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
        
        Artist* test = [[Artist alloc]init];
        test.name = @"Test 1";
        [self.relatedArtists addObject:test];
        
        Artist* test2 = [[Artist alloc]init];
        test2.name = @"Test 2";
        [self.relatedArtists addObject:test2];
        
        self.relatedArtists = [self.artistService getRelatedArtists:self.searchTxtField.text];
        
        for (Artist *artist in self.relatedArtists) {
            NSLog(@"ok");
            NSLog(artist.name);
        }
        
        NSLog(@"Number of sections : %ld", [self.relatedArtists count]);

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
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
