//
//  FeedViewController.h
//  Instagram
//
//  Created by Natalie Ghidali on 7/9/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController
@property (class, nonatomic, readonly) CGFloat defaultHeight;

- (void)startAnimating;
- (void)stopAnimating;
@end
