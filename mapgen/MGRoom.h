//
//  MGRoom.h
//  mapgen
//
//  Created by Pat Smith on 10/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGRoom : NSObject
{
    CGRect interior;
    CGRect perimeter;
    
}
@property (readwrite) CGRect interior;
@property (readwrite) CGRect perimeter;

-(id)initWithRect:(CGRect)interior;

@end
