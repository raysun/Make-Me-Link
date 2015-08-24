//
//  ButtonCollectionViewController.m
//  Make Me Link
//
//  Created by Karen and Ray Sun on 7/19/15.
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
//    CMMotionActivityManager *_motionManager;
}
@property CMMotionActivityManager *motionManager;

@end


@implementation ButtonCollectionViewController

const int BUTTONINDEX_LABEL = 0;
const int BUTTONINDEX_IMAGE = 1;
const int BUTTONINDEX_MUSIC = 2;
static NSString * const reuseIdentifier = @"cell";

/* Might be needed for the motion detection but actually I don't think so
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}
*/

/* Was going to implement real swordplay but not yet
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
            //__block BOOL isVertical = NO;
        // User was shaking the device. Post a notification named "shake."
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = 1;
        
        if ([self.motionManager isAccelerometerAvailable])
        {
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [self.motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{

 
                    NSLog(@"%f %f %f",accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z);
                    if (accelerometerData.acceleration.y < -0.9) {
                        NSURL *musicURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"shield" ofType:@"wav"]];
                        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
                        [_audioPlayer prepareToPlay];
                        [_audioPlayer play];
                    } else {
                        NSURL *musicURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"swordSpin" ofType:@"wav"]];
                        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
                        [_audioPlayer prepareToPlay];
                        [_audioPlayer play];
                    }
//                    NSLog(@"%i", isVertical);
                    [self.motionManager stopAccelerometerUpdates];
                });
            }];
        } else
            NSLog(@"not active");
    }
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    // ray: apparently the default code registers the cell class, but you can't do it if you want to use the prototype. I guess because the cell type is implicit with the prototype
    //[self.collectionView registerClass:[ButtonCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    _buttonData = @[
                   @[@"Outside",@"overworld.jpg",@"overworld"],
                   @[@"Inside",@"house.png",@"house"],
                   @[@"Basement",@"basement.jpeg",@"dungeon"],
                   @[@"Game",@"games.jpeg",@"playing"],
                   @[@"Shop",@"shopping.png",@"shop"],
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
        // user has started running and the music is not already running (since didSelect is actually a toggle)
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        if ([activity running] && !_musicAutomaticallyStarted) {
//            [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            NSURL *musicURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_buttonData[0][BUTTONINDEX_MUSIC] ofType:@"mp3"]];
            _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
            //        _audioPlayer.volume=1.0;
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
//    [cell.selectedBackgroundView setBackgroundColor:[UIColor whiteColor]];
    cell.selectedBackgroundView.layer.cornerRadius = 10;
    cell.selectedBackgroundView.layer.borderWidth = 2;
    cell.selectedBackgroundView.layer.borderColor = [[UIColor blackColor] CGColor];

//    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_buttonImages[row]]];
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
//        _audioPlayer.volume=1.0;
        _audioPlayer.numberOfLoops = -1;
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
        
        NSLog(@"Selecting %@ %ld",cell.buttonLabel.text,(long)[indexPath item]);
        _previouslySelectedIndex = indexPath;
    }
}

/*
- (void)collectionView:(nonnull UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    ButtonCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//    [_audioPlayer stop];
    
//    [self stopMusicFromCell:cell];
}

- (void)stopMusicFromCell: (ButtonCell *)cell {
    [_audioPlayer stop];
    NSLog(@"Deselecting %@",cell.label.text);
    cell.layer.cornerRadius = 0;
    cell.layer.borderWidth = 0;
}
 */

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
