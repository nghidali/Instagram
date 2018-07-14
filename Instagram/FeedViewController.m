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
#import "DetailViewController.h"
#import "OtherProfileViewController.h"
#import "InfiniteScrollActivityView.h"

@interface FeedViewController () <UITableViewDataSource,UITableViewDelegate, PostCellDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray * posts;
@property int queryLimit;

@end

@implementation FeedViewController

bool isMoreDataLoading = false;
InfiniteScrollActivityView* loadingMoreView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            isMoreDataLoading = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            loadingMoreView.frame = frame;
            [loadingMoreView startAnimating];
            
            _queryLimit += 20;
            [self makeQuery];
        }
    }
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self makeQuery];
    [refreshControl endRefreshing];
}

- (void)makeQuery {
    //[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query includeKey:@"caption"];
    [query includeKey:@"image"];
    [query includeKey:@"createdAt"];
    [query includeKey:@"_id"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            isMoreDataLoading = false;
            self.posts = posts;
            NSLog(@"posts retrieved!");
            
            // Stop the loading indicator
            [loadingMoreView stopAnimating];
            
            [self.tableView reloadData];
            // do something with the array of object returned by the call
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (IBAction)onLogout:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil]; //change to trigger a segue to the login controller
    NSLog(@"User is logged out");
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"View did appear");
    _queryLimit = 20;
    [self makeQuery];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _queryLimit = 20;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    [self makeQuery];
    // Do any additional setup after loading the view.
    
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    loadingMoreView.hidden = true;
    [self.tableView addSubview:loadingMoreView];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    [cell setAttributes:self.posts[indexPath.row]];
    cell.delegate = self;
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"DetailSegue"]){
        PostCell * postCell =  sender;
        DetailViewController * detailViewController = [segue destinationViewController];
        detailViewController.postCell = postCell;
    }
    else if([segue.identifier isEqualToString:@"ProfileSegue"]){
        PostCell * postCell =  sender;
        PFUser *postUser = postCell.post[@"author"];
        OtherProfileViewController * other = [segue destinationViewController];
        other.user = postUser;
    }
}

- (void)didTapPost:(PostCell *)postCell {
    [self performSegueWithIdentifier:@"DetailSegue" sender:postCell];
}

- (void)didTapProfile:(PostCell *)postCell {
    [self performSegueWithIdentifier:@"ProfileSegue" sender:postCell];
}

@end
