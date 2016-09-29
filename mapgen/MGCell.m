//
//  MGCell.m
//  mapgen
//
//  Created by Pat Smith on 09/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import "MGCell.h"

@implementation MGCell
@synthesize visited;
@synthesize blocked;
@synthesize type;

-(id)init
{
    if ((self = [super init])) {
        self.visited = NO;
        self.blocked = NO;
        self.type = MGCellTypeNone;
    }
    return self;
}
@end
