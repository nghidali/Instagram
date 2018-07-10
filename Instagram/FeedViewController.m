//
//  FeedViewController.m
//  Instagram
//
//  Created by Natalie Ghidali on 7/9/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import "FeedViewController.h"
#import "Parse.h"
#import "PostCell.h"
@interface FeedViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray * posts;
@end

@implementation FeedViewController

- (void)onTimer {
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"InstagramPost"];
    [query includeKey:@"user"];
    [query includeKey:@"caption"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            NSLog(@"posts retrieved!");
            // do something with the array of object returned by the call
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.tableView reloadData];
}

- (IBAction)onLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self onTimer];
    // Do any additional setup after loading the view.
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    cell.postCaption.text = self.posts[indexPath.row][@"caption"];
    PFUser *user = self.posts[indexPath.row][@"user"];
    if (user != nil) {
        // User found! update username label with username
        cell.usernameLabel.text = user.username;
    } else {
        // No user found, set default username
        cell.usernameLabel.text = @"🤖";
    }
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
