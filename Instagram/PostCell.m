//
//  PostCell.m
//  Instagram
//
//  Created by Natalie Ghidali on 7/9/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didLike:(id)sender {
    if(!self.favorited){
        self.favorited = YES;
        self.likeIcon.selected = YES;
    }
    else{
        self.favorited = NO;
        self.likeIcon.selected = NO;
    }
}

@end
