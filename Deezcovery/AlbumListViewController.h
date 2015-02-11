//
//  AlbumListViewController.h
//  Deezcovery
//
//  Created by B'n'J on 20/01/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Artist.h"

@interface AlbumListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Artist *artist;

@end
