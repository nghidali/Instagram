//
//  OtherProfileViewController.m
//  Instagram
//
//  Created by Natalie Ghidali on 7/13/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import "OtherProfileViewController.h"
#import "Parse.h"
#import "PostCollectionViewCell.h"

@interface OtherProfileViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *profilePic;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray * posts;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postCountLabel;

@end

@implementation OtherProfileViewController

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
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

- (void)makeQuery {
    //[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query includeKey:@"caption"];
    [query includeKey:@"image"];
    [query includeKey:@"createdAt"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"author" equalTo:self.user];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            NSLog(@"posts retrieved!");
            [self.collectionView reloadData];
            // do something with the array of object returned by the call
            self.postCountLabel.text = [NSString stringWithFormat:@"%lu", self.posts.count];
            if (posts.count != 0){
                PFUser * user = self.posts[0][@"author"];
                if (user != nil){
                    self.usernameLabel.text = user.username;
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
