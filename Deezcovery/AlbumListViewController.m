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

#define TODO_CELL_ID        @"AlbumCellIdentifier"
#define SEGUE_TO_DETAIL_ID  @"ListToDetail"


@interface AlbumListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableAlbums;
@property (weak, nonatomic) IBOutlet UITextField *fieldAlbum;

@property (strong, nonatomic) NSMutableArray *albums;
@property (weak, nonatomic) AlbumService *albumService;
@property (weak, nonatomic) Album *selectedTodo;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation AlbumListViewController
#pragma mark - Privates
- (void)setupModel{
    self.albumService = [AlbumService sharedInstance];
}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tableAlbums addSubview:self.refreshControl];
}

- (void)refreshData {
    [self.refreshControl beginRefreshing];
    [self.albumService getAlbumsWithcompletion:^(NSArray *albums) {
        self.albums = [[albums sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 name] compare:[obj2 name]];
        }] mutableCopy];
        
        [self.tableAlbums reloadData];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MMM d, h:mm a";
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [dateFormatter stringFromDate:[NSDate date]]];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }];
}

- (void)configureOutlets{
    self.tableAlbums.delegate = self;
    self.tableAlbums.dataSource = self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupModel];
    [self configureOutlets];
    [self setupRefreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableAlbums reloadData];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SEGUE_TO_DETAIL_ID]){
        //controller.album = self.selectedAlbum;
    }
}

#pragma mark - Actions
- (IBAction)didTouchAddButton:(id)sender {
    if ([self.fieldAlbum.text isEqualToString:@""])
        return;
    
    Album *newAlbum = [[Album alloc] init];
    newAlbum.title = self.fieldAlbum.text;
    [self.fieldAlbum setText:@""];
}


#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albums.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableAlbums dequeueReusableCellWithIdentifier:TODO_CELL_ID];
    
    Album *album = self.albums[indexPath.row];
    cell.textLabel.text = album.title;
    
    return cell;
}


#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //self. = self.albums[indexPath.row];
    [self performSegueWithIdentifier:SEGUE_TO_DETAIL_ID sender:self];
}

@end
