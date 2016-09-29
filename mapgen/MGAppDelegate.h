//
//  MGAppDelegate.h
//  mapgen
//
//  Created by Pat Smith on 08/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGMapViewController;

@interface MGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MGMapViewController *viewController;

@end
