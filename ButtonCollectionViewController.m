//
//  ButtonCollectionViewController.m
//  Make Me Link
//
//  Created by Ray Sun on 7/19/15.
//  Copyright © 2015 Ray Sun. All rights reserved.
//

#import "ButtonCollectionViewController.h"
#import "ButtonCell.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

@interface ButtonCollectionViewController ()
{
    AVAudioPlayer *_audioPlayer;
    NSIndexPath *_previouslySelectedIndex;
    NSArray *_buttonData;
    BOOL _musicAutomaticallyStarted;
}
@property CMMotionActivityManager *motionManager;

@end

@implementation ButtonCollectionViewController

enum buttonindex {BUTTONINDEX_LABEL, BUTTONINDEX_IMAGE, BUTTONINDEX_MUSIC};
static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    // The default code registers the cell class, but you can't do it if you want to use the prototype. I think because the cell type is implicit with the prototype.
    //[self.collectionView registerClass:[ButtonCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    _buttonData = @[
                   @[@"Outside",@"overworld.jpg",@"overworld"],
                   @[@"Inside",@"house.png",@"house"],
                   @[@"Basement",@"basement.jpeg",@"dungeon"],
                   @[@"Game",@"games.jpeg",@"playing"],
                   @[@"Shop",@"shopping.png",@"shop2"],
                   @[@"Get Item",@"triforce.png",@"getTriforce"],
                   @[@"Forest",@"forest.jpeg",@"forest-lost"],
                   @[@"Train",@"train.png",@"train"],
                   @[@"Boat",@"boat.jpg",@"greatsea"],
                   @[@"Sketchy Neighborhood",@"enemies.jpeg",@"danger"],
                   @[@"I died!",@"gameover.png",@"gameover"],
                   ];
    
    self.motionManager = [CMMotionActivityManager new];
    [self.motionManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity *activity) {
        NSLog(@"New Motion event: %@",activity);
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        
        // user has started running and the music is not already running (since didSelect is actually a toggle)
        if ([activity running] && !_musicAutomaticallyStarted) {
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            NSURL *musicURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_buttonData[0][BUTTONINDEX_MUSIC] ofType:@"mp3"]];
            _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
            _audioPlayer.numberOfLoops = -1;
            [_audioPlayer prepareToPlay];
            [_audioPlayer play];
            _musicAutomaticallyStarted = YES;
            _previouslySelectedIndex = indexPath;
            NSLog(@"Started running %ld",(long)activity.confidence);
        } else if ([activity running] && _musicAutomaticallyStarted) {
          // do nothing, this means I am already running and I get a change in running confidence
        } else if (_musicAutomaticallyStarted) {
            [_audioPlayer stop];
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
            _musicAutomaticallyStarted = NO;
            _previouslySelectedIndex = nil;
            NSLog(@"Stopped running %ld",(long)activity.confidence);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _buttonData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ButtonCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSInteger item = [indexPath item];
    
    // Configure the cell
    cell.buttonLabel.text = _buttonData[item][BUTTONINDEX_LABEL];
    cell.buttonLabel.textColor = [UIColor blackColor];
    cell.buttonImage.image = [UIImage imageNamed:_buttonData[item][BUTTONINDEX_IMAGE]];
    
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.layer.cornerRadius = 10;
    cell.selectedBackgroundView.layer.borderWidth = 2;
    cell.selectedBackgroundView.layer.borderColor = [[UIColor blackColor] CGColor];

    return cell;
}

- (void)collectionView:(nonnull UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger item = [indexPath item];
    ButtonCell *cell = (ButtonCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if (indexPath == _previouslySelectedIndex) {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        _previouslySelectedIndex = nil;
        [_audioPlayer stop];
    } else {
        NSURL *musicURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_buttonData[item][BUTTONINDEX_MUSIC] ofType:@"mp3"]];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
        _audioPlayer.numberOfLoops = -1;
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
        
        NSLog(@"Selecting %@ %ld",cell.buttonLabel.text,(long)[indexPath item]);
        _previouslySelectedIndex = indexPath;
    }
}

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


@end
