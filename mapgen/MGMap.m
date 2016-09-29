//
//  MGMap.m
//  mapgen
//
//  Created by Pat Smith on 08/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import "MGMap.h"
#import "MGCell.h"

@implementation MGMap
@synthesize width;
@synthesize height;

-(id)initWithWidth:(int)_width height:(int)_height
{
    NSLog(@"initWithWidth:height is deprecated :)");
    if ((self = [super init])) {
        width = _width;
        height =_height;

        map = [[NSMutableArray alloc] initWithCapacity:width];
        for (int i=0; i < width; i++) {
            NSMutableArray* row = [[NSMutableArray alloc] initWithCapacity:height];
            [map addObject:row];
            for (int j=0; j < height; j++) {
                [row addObject:[[MGCell alloc] init]];
            }
        }
    }
    return self;
}

-(id)initWithSize:(CGSize)size
{
    if ((self = [super init])) {
        width = size.width;
        height = size.height;
        
        map = [[NSMutableArray alloc] initWithCapacity:width];
        for (int i=0; i < width; i++) {
            NSMutableArray* row = [[NSMutableArray alloc] initWithCapacity:height];
            [map addObject:row];
            for (int j=0; j < height; j++) {
                [row addObject:[[MGCell alloc] init]];
            }
        }
    }
    return self;
}

-(void)markCellsUnvisited
{
    for (NSMutableArray* row in map) {
        for (MGCell* cell in row) {
            cell.visited = NO;
        }
    }
}
-(MGCell*)cellAtX:(int)x Y:(int)y
{
    if (x >= self.width || y >= self.height || x < 0 || y < 0) {
        return nil;
    }
    NSMutableArray* row = [map objectAtIndex:x];
    MGCell* cell = [row objectAtIndex:y];
    return cell;
}

-(void)pickRandomCellAndMarkItVisited
{
    //int locationX = arc4random() % (width - 1);
    int locationX = arc4random_uniform(width);
    //int locationY = arc4random() % (height - 1);
    int locationY = arc4random_uniform(height);

    MGCell* cell = [self cellAtX:locationX Y:locationY];
    cell.visited = YES;
}


@end
