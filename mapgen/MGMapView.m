//
//  MGMapView.m
//  mapgen
//
//  Created by Pat Smith on 10/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MGMapView.h"
#import "MGRendererBase.h"


@implementation MGMapView
@synthesize renderer;
@synthesize map;
@synthesize point;

- (void)__init__
{
    point = CGPointMake(0.0f, 0.0f);
}
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self __init__];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self __init__];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, point.x, point.y);
        
    [renderer renderMap:map toContext:context];
}
@end
