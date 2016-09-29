//
//  MGPoint.m
//  mapgen
//
//  Created by Pat Smith on 14/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import "MGPoint.h"

@implementation MGPoint
@synthesize x;
@synthesize y;
@synthesize w;

-(id)initWithX:(int)_x Y:(int)_y W:(int)_w
{
    if ((self = [super init])) {
        self.x = _x;
        self.y = _y;
        self.w = _w;
    }
    return self;
}
@end
