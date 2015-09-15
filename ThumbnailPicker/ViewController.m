//
//  ViewController.m
//  ThumbnailPicker
//
//  Created by Tomas Radvansky on 15/09/2015.
//  Copyright © 2015 Radvansky Solutions. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize data,player;

- (void)viewDidLoad {
    [super viewDidLoad];
    data = [[NSMutableArray alloc]init]; //Empty array
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerLoadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)MPMoviePlayerLoadStateDidChange:(NSNotification *)notification
{
    if ((player.loadState & MPMovieLoadStatePlaythroughOK) == MPMovieLoadStatePlaythroughOK)
    {
        data = [[NSMutableArray alloc]init];
        [[self mainCollectionView]reloadData];
    }
}

- (IBAction)rightButtonClicked:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
    
    [self presentViewController:imagePicker animated:true completion:^{
        //
    }];
}

#pragma mark - UIImagepickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        self.player = [[MPMoviePlayerController alloc]
                                          initWithContentURL:videoUrl];
        [self.player prepareToPlay];
        [self.player setShouldAutoplay:false];
    }
    
    [self dismissViewControllerAnimated:true completion:^{
        //
    }];
}

#pragma mark - UICollectionViewDelegate+Datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.player!=NULL)
    {
        return self.player.duration;
    }
    else
    {
        return 0;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Assign frame to UIImageview
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        UIImage *overlayImage = [self.player thumbnailImageAtTime:indexPath.row
                                                       timeOption:MPMovieTimeOptionExact];
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            [self.mainImageVIew setImage:overlayImage]; // 3
        });
    });
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"FrameCell"
                                    forIndexPath:indexPath];
    
    UIImageView *imgView = [myCell viewWithTag:100];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        UIImage *overlayImage = [self.player thumbnailImageAtTime:indexPath.row
                                                       timeOption:MPMovieTimeOptionExact];
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            [imgView setImage:overlayImage]; // 3
        });
    });
    return myCell;
}
@end
