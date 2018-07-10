//
//  ComposeViewController.m
//  Instagram
//
//  Created by Natalie Ghidali on 7/9/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import "ComposeViewController.h"
#import "Parse.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *captionField;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onChooseImage:(id)sender {
    
}
- (IBAction)onShare:(id)sender {
    PFObject *instagramPost = [PFObject objectWithClassName:@"InstagramPost"];
    instagramPost[@"caption"] = self.captionField.text;
    instagramPost[@"user"] = [PFUser currentUser];
    [instagramPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.captionField.text = nil;
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
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
