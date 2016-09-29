//
//  MGRoom.m
//  mapgen
//
//  Created by Pat Smith on 10/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import "MGRoom.h"


@implementation MGRoom
@synthesize interior;
@synthesize perimeter;

-(id)initWithRect:(CGRect)_interior
{
    if ((self = [super init])) {
        self.interior = _interior;
        self.perimeter = CGRectInset(_interior, -1.0, -1.0);
    }
    return self;
}

@end
