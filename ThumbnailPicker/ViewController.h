//
//  ViewController.h
//  ThumbnailPicker
//
//  Created by Tomas Radvansky on 15/09/2015.
//  Copyright © 2015 Radvansky Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,retain) NSMutableArray* data;
@property (nonatomic,retain) MPMoviePlayerController *player;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageVIew;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;

- (IBAction)rightButtonClicked:(id)sender;

@end

