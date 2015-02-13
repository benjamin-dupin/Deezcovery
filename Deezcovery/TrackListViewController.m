//
//  TrackListViewController.m
//  Deezcovery
//
//  Created by B'n'J on 12/02/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "TrackListViewController.h"
#import "TrackService.h"
#import "Track.h"

#define CELL_ID @"TRACK_CELL_ID"

@interface TrackListViewController ()
@property (weak, nonatomic) TrackService *trackService;
@property (weak, nonatomic) Track *selectedTrack;
@property (strong, nonatomic) NSMutableArray *tracksByAlbum;
@property (weak, nonatomic) IBOutlet UITableView *tracks;

@end

@implementation TrackListViewController

- (void)setupModel{
    self.trackService = [TrackService sharedInstance];
}

- (void)configureOutlets{
    self.tracks.delegate = self;
    self.tracks.dataSource = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupModel];
    [self configureOutlets];
    
    [self loadTracks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tracks reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tracksByAlbum count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tracks dequeueReusableCellWithIdentifier:CELL_ID];
    
    Track *track = self.tracksByAlbum[indexPath.row];
    cell.textLabel.text = track.title;
    
    return cell;
}

- (void) loadTracks {
    
    @try {
        
        self.tracksByAlbum = [self.trackService getTracksByAlbum:self.album];
        
        [self.tracks reloadData];
        
        if ([self.tracksByAlbum count] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No track"
                                                            message:@"There is no track for this album."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK :-("
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        
    }
    
    @catch(NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Can not find the tracks..."
                                                       delegate:self
                                              cancelButtonTitle:@"OK :-("
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Track *selectedTrack = self.tracksByAlbum[indexPath.row];
    
    NSURL *url = [NSURL URLWithString:[selectedTrack.preview stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    self.player = [[AVPlayer alloc] initWithURL:url];
    
    if (!self.player) {
        NSLog(@"Error");
    }
    
    [self.player play];
}

@end
