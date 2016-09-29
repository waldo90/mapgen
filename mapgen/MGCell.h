//
//  MGCell.h
//  mapgen
//
//  Created by Pat Smith on 09/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MGCellTypeNone,
    MGCellTypeRoom,
    MGCellTypeCorridor,
    MGCellTypePerimeter,
    MGCellTypeEntrance,
} MGCellType;

@interface MGCell : NSObject
{
    BOOL visited;
    BOOL blocked;
    MGCellType type;
}
@property (readwrite) BOOL visited;
@property (readwrite) BOOL blocked;
@property (readwrite) MGCellType type;
@end
