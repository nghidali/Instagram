//
//  InfiniteScrollActivityView.h
//  Instagram
//
//  Created by Natalie Ghidali on 7/13/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfiniteScrollActivityView : UIActivityIndicatorView

@property (class, nonatomic, readonly) CGFloat defaultHeight;

- (void)startAnimating;
- (void)stopAnimating;

@end
