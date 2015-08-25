//
//  ButtonCollectionViewController.h
//  Make Me Link
//
//  Created by Ray Sun on 7/19/15.
//  Copyright © 2015 Ray Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *buttonImages;
@property (strong, nonatomic) NSArray *buttonLabels;
@property (strong, nonatomic) NSArray *buttonSongs;

@end
