//
//  mapgenTests.m
//  mapgenTests
//
//  Created by Pat Smith on 08/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import "mapgenTests.h"
#import "MGMap.h"
#import "MGCell.h"

@implementation mapgenTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testMarkCellsUnvisited
{
    MGMap* map = [[MGMap alloc] initWithWidth:10 height:10];
    [map markCellsUnvisited];
    
    for (int x=0; x<map.width; x++) {
        for (int y=0; y<map.height; y++) {
            MGCell* cell = [map cellAtX:x Y:y];
            STAssertFalse(cell.visited, @"Cell is not unvisited");
        }
    }
}

- (void)testPickRandomCellAndMarkItVisited
{
    MGMap* map = [[MGMap alloc] initWithWidth:10 height:10];
    [map markCellsUnvisited];
    
    [map pickRandomCellAndMarkItVisited];
    
    int visitedCellCount = 0;
    
    for (int x = 0; x < map.width; x++) {
        for (int y = 0; y < map.height; y++) {
            MGCell* cell = [map cellAtX:x Y:y];
            if (cell.visited) visitedCellCount++;
        }
    }
    STAssertEquals(visitedCellCount, 1, nil);
}
@end
