//
//  MGMapView.h
//  mapgen
//
//  Created by Pat Smith on 10/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class MGMap;
@class MGRendererBase;

@interface MGMapView : UIView
{
    MGRendererBase* renderer;
    MGMap*  map;
    CGPoint point;
}
@property (nonatomic, retain) MGRendererBase* renderer;
@property (nonatomic, retain) MGMap* map;
@property (readwrite) CGPoint point;

@end
