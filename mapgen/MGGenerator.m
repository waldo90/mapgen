//
//  MGGenerator.m
//  mapgen
//
//  Created by Pat Smith on 10/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import "MGGenerator.h"
#import "MGPoint.h"
#import "MGCell.h"
#import "MGRoom.h"
#import "MGMap.h"


@implementation MGGenerator
@synthesize map;

-(id)initWithSize:(CGSize)_size
{
    if ((self = [super init])) {
        mapsize = _size;
        room_max = 12;
        room_avg = 7;
        room_min = 4;
    }
    return self;
}

// Starts generation of the map
-(void)generate
{
    bad_map = NO;
    map = [[MGMap alloc] initWithSize:mapsize];
    entrances = [[NSMutableArray alloc] init];
    rooms = [[NSMutableArray alloc] init];
    large_room_weighting = 20;

    NSLog(@"Generating: packed rooms");
    [self generatePackedRooms];
    NSLog(@"Generating: scattered rooms");
    [self generateScatteredRooms];
    NSLog(@"Generating: entrances");
    [self generateEntrances];
    NSLog(@"Generating: corridors");
    [self generateCorridors];
    if (bad_map) {
        [self generate];
    } else {
        NSLog(@"Generated");
    }
}    

-(void)generateScatteredRooms
{
    int failures = 0;
    while (failures < 25) {
    
        CGRect rect = [self RoomMake];
        bool fits = YES;
        for (MGRoom* r in rooms) {
            if (CGRectIntersectsRect(rect, r.perimeter)) {
                fits = NO;
                break;
            }
        }
        if (fits) {
            MGRoom* room = [[MGRoom alloc] initWithRect:rect];
            [rooms addObject:room];
            failures = 0;
        } else {
            failures++;
        }
    }
    [self addRoomsToMap];
}

-(void)generatePackedRooms
{
    int num_rooms = 10;
    int failures = 0;
    int ox, oy;
    ox = map.width / 2;
    oy = map.height / 2;
    while (failures < 3000 && [rooms count] < num_rooms) {
        
        CGRect rect = [self RoomMake];
        rect.origin.x = ox;
        rect.origin.y = oy;
        int dx = arc4random_uniform(2) ? 1 : -1;
        int dy = arc4random_uniform(2) ? 1 : -1;
        BOOL fitting_room = YES;
        while (fitting_room) {
            BOOL fits = YES;
            if (rect.origin.x < 1) {
                fits = NO;
                dx = -dx;
                rect.origin.y += dy;
            }
            if (CGRectGetMaxX(rect) >= map.width) {
                fits = NO;
                dx = -dx;
                rect.origin.y += dy;
            }
            if (rect.origin.y < 1) {
                fits = NO;
                fitting_room = NO;
                failures++;
            }
            if (CGRectGetMaxY(rect) >= map.height) {
                fits = NO;
                fitting_room = NO;
                failures++;
            }
            for (MGRoom* r in rooms) {
                if (CGRectIntersectsRect(rect, r.perimeter)) {
                    fits = NO;
                    break;
                }
            }
            if (!fits) {
                failures++;
                rect.origin.x += dx;
            } else {
                fitting_room = NO;
                MGRoom* room = [[MGRoom alloc] initWithRect:rect];
                [rooms addObject:room];
            }
        }
        
    }
    [self addRoomsToMap];
}

-(CGRect)RoomMake
{
    int rx, ry, rw, rh;
    if (arc4random_uniform(100) > large_room_weighting) {
        rw = arc4random_uniform(room_max);
        rh = arc4random_uniform(room_max);
        large_room_weighting += 10;
    } else {
        rw = arc4random_uniform(room_avg);
        rh = arc4random_uniform(room_avg);
    }
    if (rw < room_min) rw = room_min;
    if (rh < room_min) rh = room_min;
    
    // Give room a random place in the map by default
    // Inset into the map to allow for perimeter
    rx = 1 + arc4random_uniform(map.width - 1 - rw);
    ry = 1 + arc4random_uniform(map.height - 1 - rh);
    
    return CGRectMake(rx, ry, rw, rh);
}

-(void)addRoomsToMap
{
    // Painter algorithm - a bit lazy :)
    for (MGRoom* room in rooms) {
        CGRect perimeter = room.perimeter;
        // perimeter
        for (int x = perimeter.origin.x; x < CGRectGetMaxX(perimeter); x++) {
            for(int y = perimeter.origin.y; y < CGRectGetMaxY(perimeter); y++) {
                MGCell* cell = [map cellAtX:x Y:y];
                cell.type = MGCellTypePerimeter;
            }            
        }
        // room
        CGRect interior = room.interior;        
        for(int x = interior.origin.x; x < CGRectGetMaxX(interior); x++) {
            for(int y = interior.origin.y; y < CGRectGetMaxY(interior); y++) {
                MGCell* cell = [map cellAtX:x Y:y];
                cell.type = MGCellTypeRoom;
            }
        }
    }
}

-(void)generateEntrances
{

/*

  0 1 2 3 4 5 6 7
0 # # # # # # . .
1 # . . . . # . .
2 # . . . . § . .
3 # . . . . # . .
4 # . . . . # . .
5 # # # # # # . .
6 . . . . . . . .
7 . . . . . . . .
 
*/
    for (MGRoom* room in rooms) {
        int entrance_count = 2;
        CGRect perimeter = room.perimeter;

        while(entrance_count) {
            // 1. pick a random point on the perimeter
            // 2. traverse perimeter looking for cell not on the edge of the map
            //    and that isn't adjacent to an existing door or blocked cell
            // 3. randomly place a door
            // 4. repeat until all entrances are placed
            
            int x, y;
            int start = arc4random_uniform(4);
            switch (start) {
                case 0: // west
                    x = perimeter.origin.x ;
                    y = arc4random_uniform(perimeter.size.height) + perimeter.origin.y;
                    break;
                case 1: // east
                    x = perimeter.origin.x + perimeter.size.width - 1;
                    y = arc4random_uniform(perimeter.size.height) + perimeter.origin.y;
                    break;
                case 2: // north
                    x = arc4random_uniform(perimeter.size.width) + perimeter.origin.x;
                    y = perimeter.origin.y;
                    break;
                case 3: // south
                    x = arc4random_uniform(perimeter.size.width) + perimeter.origin.x;
                    y = perimeter.origin.y + perimeter.size.height - 1;
                    break;                    
            }
            // avoid entrances in corners
            if (x == perimeter.origin.x && y == perimeter.origin.y) {
                continue;
            }
            if (x == perimeter.origin.x && y == perimeter.origin.y + perimeter.size.height - 1) {
                continue;
            }
            if (x == perimeter.origin.x + perimeter.size.width -1 && y == perimeter.origin.y) {
                continue;
            }
            if (x == perimeter.origin.x + perimeter.size.width -1 && y == perimeter.origin.y + perimeter.size.height - 1) {
                continue;
            }

            // no entrances on map bounds
            if (y == 0) continue;  // against limit of map
            if (y == map.height - 1) continue;
            if (x == 0) continue;
            if (x == map.width - 1) continue;
            
            // check surrounding cells
            MGCell* cell;
            switch (start) {
                case 0: // west
                case 1: // east
                    cell = [map cellAtX:x Y:y-1];
                    if (cell.type == MGCellTypeEntrance) continue;
                    if (cell.blocked) continue;
                    cell = [map cellAtX:x Y:y+1];
                    if (cell.type == MGCellTypeEntrance) continue;
                    if (cell.blocked) continue;
                    // make sure not opening into a perimeter wall
                    cell = [map cellAtX:x+1 Y:y];
                    if (cell.type == MGCellTypePerimeter) continue;
                    cell = [map cellAtX:x-1 Y:y];
                    if (cell.type == MGCellTypePerimeter) continue;

                    break;
                case 2: // north
                case 3: // south
                    cell = [map cellAtX:x-1 Y:y];
                    if (cell.type == MGCellTypeEntrance) continue;;
                    if (cell.blocked) continue;
                    cell = [map cellAtX:x+1 Y:y];
                    if (cell.type == MGCellTypeEntrance) continue;
                    if (cell.blocked) continue;
                    cell = [map cellAtX:x Y:y+1];
                    // make sure not opening into a perimeter wall
                    if (cell.type == MGCellTypePerimeter) continue;
                    cell = [map cellAtX:x Y:y-1];
                    if (cell.type == MGCellTypePerimeter) continue;

                    break;
                default:
                    break;
            }
            cell = [map cellAtX:x Y:y];
            cell.type = MGCellTypeEntrance;
            [entrances addObject:[[MGPoint alloc] initWithX:x Y:y W:0]];
            entrance_count--;
        }
    }
}

-(BOOL)isOpenToVoid:(MGPoint*)e
{
    if ([map cellAtX:e.x+1 Y:e.y].type == MGCellTypeNone) return YES;
    if ([map cellAtX:e.x-1 Y:e.y].type == MGCellTypeNone) return YES;
    if ([map cellAtX:e.x Y:e.y+1].type == MGCellTypeNone) return YES;
    if ([map cellAtX:e.x Y:e.y-1].type == MGCellTypeNone) return YES;
    return NO;
}

-(void)generateCorridors
{
    // find the list of entrances that open into 'void' space
    NSMutableArray* unconnected = [[NSMutableArray alloc] init];
    for (MGPoint* e in entrances) {
        if ([self isOpenToVoid:e]) {
            [unconnected addObject:e];
        }
    }

    // Connect random unconnected entrances with corridors
    int failures = 0;
    while ([unconnected count] > 1 && failures < 10) {
    
        NSUInteger i = arc4random_uniform([unconnected count]);
        NSUInteger j = i;
        while (j == i) j = arc4random_uniform([unconnected count]);
        MGPoint* start = [unconnected objectAtIndex:i];
        MGPoint* end   = [unconnected objectAtIndex:j];
        BOOL success = [self generateCorridorBetween:start And:end];
        if (success) {
            // success means a path was found, but that may have been back into
            // the room rather than out the door leaving the entrance still open
            // to 'void'. So we test again to see that it really was 
            // connected outside.
            int current_unconnected = [unconnected count];
            if (![self isOpenToVoid:start]) [unconnected removeObject:start];
            if (![self isOpenToVoid:end])   [unconnected removeObject:end];
            if (current_unconnected == [unconnected count]) failures++;
        } else {
            if (bad_map) {
                NSLog(@"Bad Map - aborting");
                return;
            }
        }
    }
    
    // Check if any remain unconnected
    [unconnected removeAllObjects];
    for (MGPoint* e in entrances) {
        if ([self isOpenToVoid:e]) {
            [unconnected addObject:e];
        }
    }
    NSLog(@"Unconnected after random pass: %d", [unconnected count]);

    // For now, just remove the remaining unconnected entrances

    for (MGPoint* e in unconnected) {
        MGCell* cell = [map cellAtX:e.x Y:e.y];
        cell.type = MGCellTypePerimeter;
    }
    
    
}
-(BOOL)generateCorridorBetween:(MGPoint*)start And:(MGPoint*)end
{
    
    /*
    ** https://en.wikipedia.org/wiki/Pathfinding
    */
    
    MGPoint* tmp;
    MGCell* cell;
    NSMutableArray* adjacents = [[NSMutableArray alloc] init];
    NSMutableArray* queue = [[NSMutableArray alloc] init];
    NSMutableArray* duds = [[NSMutableArray alloc] init];
    
    end.w = 0;
    [queue addObject:end];
    
    int i = 0;
    bool walking = YES;
    
    while (walking) {
        
        tmp = [queue objectAtIndex:i];
        int w = tmp.w + 1;
        
        // add candidate points with increased weight
        [adjacents addObject:[[MGPoint alloc] initWithX:tmp.x+1 Y:tmp.y W:w]];  // east
        [adjacents addObject:[[MGPoint alloc] initWithX:tmp.x-1 Y:tmp.y W:w]];  // west
        [adjacents addObject:[[MGPoint alloc] initWithX:tmp.x Y:tmp.y-1 W:w]];  // north
        [adjacents addObject:[[MGPoint alloc] initWithX:tmp.x Y:tmp.y+1 W:w]];  // south
                
        // make a list of bad candidates: duplicated or outlier adjacents.
        for (MGPoint* a in adjacents) {
            MGCell* cell = [map cellAtX:a.x Y:a.y];
            if (cell == nil) {
                [duds addObject:a];
            } else if (cell.type == MGCellTypePerimeter) {
                [duds addObject:a];
            } 
        }
        for (MGPoint* q in queue) {
            for (MGPoint* a in adjacents) {
                if (a.x == q.x && a.y == q.y && q.w <= a.w) {
                    [duds addObject:a];
                } 
            }
        }
        [adjacents removeObjectsInArray:duds];
        [queue addObjectsFromArray:adjacents];
        [adjacents removeAllObjects];
        [duds removeAllObjects];
        
        // Did we reach our destination?
        for (MGPoint* q in queue) {
            if (q.x == start.x && q.y == start.y) {
                walking = NO;
                break;
            }
        }
        
        if (++i >= [queue count]) {
            // When this happens, parts of our map are unreachable.
            NSLog(@"END OF QUEUE REACHED!");
            walking = NO;
            bad_map = YES;
            return NO;
        }
    } // end while(walking)
    
    // Search for the shortest (lightest weight) starting position added to the queue
    int distance;
    start.w = 9999999;
    for (MGPoint* q in [queue reverseObjectEnumerator]) {
        if (q.x ==start.x && q.y == start.y && q.w < start.w) {
            start.w = distance = q.w;
        }
    }

    // Set cells in the map to corridor
    MGPoint* p = start;
    while (distance) {
        int last_distance = distance;
        for (MGPoint* q in [queue reverseObjectEnumerator]) {

            if (q.w == p.w - 1){
                if ( (q.y == p.y && (q.x == p.x - 1 || q.x == p.x + 1))
                ||   (q.x == p.x && (q.y == p.y - 1 || q.y == p.y + 1)) ) {
                    distance--;
                    p = q;
                    cell = [map cellAtX:q.x Y:q.y];
                    if (cell.type == MGCellTypeNone) {
                        cell.type = MGCellTypeCorridor;
                    }
                }
            }
        }
        if (last_distance == distance) {
            NSLog(@"Failed to Find path through");
            return NO;
        }
    }
    return YES;
     
}
@end
