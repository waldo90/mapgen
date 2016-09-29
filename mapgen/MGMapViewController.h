//
//  MGMapViewController.h
//  mapgen
//
//  Created by Pat Smith on 10/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MGMapViewController : UIViewController <UIGestureRecognizerDelegate>
{
    CGPoint last_point;
}

- (void)handleTap:(UITapGestureRecognizer*)sender;
- (void)handlePan:(UIPanGestureRecognizer*)sender;

@end
