//
//  MGPoint.h
//  mapgen
//
//  Created by Pat Smith on 14/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGPoint : NSObject
{
    int x;
    int y;
    int w;
}

@property (readwrite) int x;
@property (readwrite) int y;
@property (readwrite) int w;

-(id)initWithX:(int)x Y:(int)y W:(int)w; 
@end
