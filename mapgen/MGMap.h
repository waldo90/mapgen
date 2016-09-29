//
//  MGMap.h
//  mapgen
//
//  Created by Pat Smith on 08/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//


#import <Foundation/Foundation.h>
@class MGCell;

@interface MGMap : NSObject
{
    int width;
    int height;
    
    NSMutableArray* map;
}

@property (readonly) int width;
@property (readonly) int height;

//deprecated :)
-(id)initWithWidth:(int)width height:(int)height;
// in favour of
-(id)initWithSize:(CGSize)size;

-(void)markCellsUnvisited;
-(MGCell*)cellAtX:(int)x Y:(int)y;
-(void)pickRandomCellAndMarkItVisited;

@end
