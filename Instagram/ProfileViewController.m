//
//  ProfileViewController.m
//  Instagram
//
//  Created by Natalie Ghidali on 7/11/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import "ProfileViewController.h"
#import "PostCollectionViewCell.h"
#import "Parse.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *profilePic;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray * posts;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.height /2;
    [self makeQuery];
    
    //resize collection view
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - (layout.minimumInteritemSpacing * (postersPerLine - 1))) / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth,itemHeight);
}
- (IBAction)onProfileClick:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    originalImage = [self resizeImage:originalImage withSize:CGSizeMake(100, 100)];
    PFFile *imageFile = [self getPFFileFromImage:originalImage]; // file too big, need to resize
    
    // Do something with the images (based on your use case)
    
    [self.profilePic setImage:originalImage forState:UIControlStateNormal];
    
    PFUser * user = [PFUser currentUser];
    [user setObject:imageFile forKey:@"profilePicture"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            NSLog(@"We resaved the current user");
        }
        else{
            NSLog(@"%@",error);
        }
    }];
    // Dismiss UIImagePickerController to go back to your original view controller
    //[self makeQuery];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFile fileWithName:@"image.png" data:imageData];
}

- (void)makeQuery {
    //[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query includeKey:@"caption"];
    [query includeKey:@"image"];
    [query includeKey:@"createdAt"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            NSLog(@"posts retrieved!");
            [self.collectionView reloadData];
            // do something with the array of object returned by the call
            if (posts.count != 0){
                PFUser * user = self.posts[0][@"author"];
                if (user != nil){
                    PFFile * imageFile = [user objectForKey:@"profilePicture"];
                    if(imageFile != nil){
                        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
                            if (!imageData) {
                                return NSLog(@"%@", error);
                            }
                            [self.profilePic setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                        }];
                    }
                }
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
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

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    PFFile * imageFile = self.posts[indexPath.row][@"image"];
    if(imageFile != nil){
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
            if (!imageData) {
                return NSLog(@"%@", error);
            }
            cell.imageView.image = [UIImage imageWithData:imageData];
        }];
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
