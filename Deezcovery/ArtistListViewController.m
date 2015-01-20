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
@property (strong, nonatomic) NSArray *relatedArtists;


@end

@implementation ArtistListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
    Click on Search Button
*/
- (IBAction)didTouchSearchButton:(id)sender {
    
    if ([self.searchTxtField.text length ] > 0) {
        
        [self.artistService getRelatedArtists:self.searchTxtField.text completion:^(NSArray *artists) {
            
            self.relatedArtists = artists;
            
            [self.artists insertRowsAtIndexPaths:artists withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.artists reloadData];
            
            
        }];
        
        
    }
    
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
