//
//  MGGenerator.h
//  mapgen
//
//  Created by Pat Smith on 10/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGMap.h"
#import "MGRoom.h"
#import "MGCell.h"

@interface MGGenerator : NSObject
{
    CGSize mapsize;
    MGMap*  map;
    NSMutableArray* rooms;
    NSMutableArray* entrances;
    BOOL bad_map;
    int room_max;
    int room_avg;
    int room_min;
    int large_room_weighting;
}
@property (nonatomic, retain) MGMap* map;

-(id)initWithSize:(CGSize)size;
-(void)generate;

@end
