//
//  PostCell.h
//  Instagram
//
//  Created by Natalie Ghidali on 7/9/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@protocol PostCellDelegate;

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postCaption;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property NSString * timestamp;
@property (weak, nonatomic) IBOutlet UIButton *likeIcon;
@property BOOL favorited;
@property (weak, nonatomic) IBOutlet UILabel *likedByLabel;
@property (weak, nonatomic) IBOutlet UIButton *profilePic;

@property (nonatomic, weak) id<PostCellDelegate> delegate;
//@property (nonatomic,strong) NSMutableArray *usersWhoLiked;
@property Post * post;
- (void)setAttributes:(Post *)post;
@end

@protocol PostCellDelegate <NSObject>
-(void) didTapPost: (PostCell *) postCell;
-(void) didTapProfile: (PostCell *) postCell;
@end
