//
//  PostCell.m
//  Instagram
//
//  Created by Natalie Ghidali on 7/9/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import "PostCell.h"
#import "Parse.h"
#import "Post.h"
@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *postTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedPost:)];
    // Initialization code
    [self.postImage addGestureRecognizer:postTapGestureRecognizer];
    [self.postImage setUserInteractionEnabled:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setAttributes:(Post *)post{
    self.favorited = NO;
    self.postCaption.text = post[@"caption"];
    self.post = post;
    self.profilePic.imageView.layer.cornerRadius = self.profilePic.imageView.frame.size.height / 2;
    PFUser *user = post[@"author"];
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
    self.timestamp = post[@"timestamp"];
    
    [self updateLikedByLabel];
    //[self updateLocalLikeList: [PFUser currentUser]];
    if([self currentUserLikedPost]){
        self.favorited = YES;
        self.likeIcon.selected = YES;
    }
    else{
        self.favorited = NO;
        self.likeIcon.selected = NO;
    }
    
    PFFile * imageFile = post[@"image"];
    if(imageFile != nil){
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
            if (!imageData) {
                return NSLog(@"%@", error);
            }
            self.postImage.image = [UIImage imageWithData:imageData];
        }];
    }
    if (user != nil) {
        // User found update username label with username
        self.usernameLabel.text = user.username;
    } else {
        // No user found, set default username
        self.usernameLabel.text = @"🤖";
    }
}

- (IBAction)didLike:(id)sender {
    //[self updateLocalLikeList:[PFUser currentUser]];
    if([self currentUserLikedPost]){
        [self updateLikeList:[PFUser currentUser] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"We updated the like list user was not in the like list so we added them!");
            }
            else{
                NSLog(@"%@",error);
            }
        }];
    }
    else{
        [self updateLikeList:[PFUser currentUser] withCompletion:^(BOOL succeeded, NSError * _Nullable error){
            if(succeeded){
                NSLog(@"We updated the like list user was in the like list so we removed them!");
            }
            else{
                NSLog(@"%@",error);
            }
        }];
        
    }
    [self updateLikedByLabel];
}
-(BOOL) currentUserLikedPost{
    return [self.post.usersWhoLiked containsObject:[PFUser currentUser].username];
}

- (void) updateLikeList: (PFUser * _Nullable) pfUser withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    NSString *user = pfUser.username;
        if([self.post.usersWhoLiked containsObject:user]){
            //remove the user from the list
            [self.post removeObject:user forKey:@"usersWhoLiked"];
            self.favorited = NO;
            self.likeIcon.selected = NO;
        }
        else{
            //add the user to the list
            [self.post addObject:user forKey:@"usersWhoLiked"];
            self.favorited = YES;
            self.likeIcon.selected = YES;
        }
        [self.post saveInBackgroundWithBlock: completion];
}

- (void) updateLocalLikeList: (PFUser * _Nullable) user{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query getObjectInBackgroundWithId:[self.post objectId] block:^(PFObject *post, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        if(post){
            //NSLog(@"%@", post);
            self.post.usersWhoLiked = post[@"usersWhoLiked"];
        }
        else{
            NSLog(@"couldn't update local like list");
            NSLog(@"%@",error);
        }
    }];
}

-(void)updateLikedByLabel{
    long numLikes = self.post.usersWhoLiked.count;
    NSString *numLikesString = [NSString stringWithFormat:@"%lu",numLikes];
    self.likedByLabel.text = [numLikesString stringByAppendingString:@" Likes"];
}
- (void) clickedPost:(UITapGestureRecognizer *)sender{
    [self.delegate didTapPost:self];
}

- (IBAction)clickedProfile:(id)sender {
    [self.delegate didTapProfile:self];
}

@end
