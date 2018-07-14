//
//  DetailViewController.m
//  Instagram
//
//  Created by Natalie Ghidali on 7/10/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import "DetailViewController.h"
#import <DateTools.h>

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameLabel.text = self.postCell.usernameLabel.text;
    self.captionLabel.text = self.postCell.postCaption.text;
    self.postImage.image = self.postCell.postImage.image;
    //self.dateLabel.text = self.postCell.timestamp;
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.height / 2;
    self.profilePic.image = self.postCell.profilePic.imageView.image;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    NSDate *date = [formatter dateFromString:self.postCell.timestamp];
    NSString *timeAgoDate = [date timeAgoSinceNow];
    self.dateLabel.text = timeAgoDate;
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

@end
