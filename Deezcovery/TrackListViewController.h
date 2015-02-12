//
//  TrackListViewController.h
//  Deezcovery
//
//  Created by B'n'J on 12/02/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface TrackListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Album *album;
@property (strong, nonatomic) AVPlayer *player;

@end
