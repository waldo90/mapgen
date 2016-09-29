//
//  MGRendererBase.h
//  mapgen
//
//  Created by Pat Smith on 24/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGMap;

@interface MGRendererBase : NSObject
{
    MGMap* map;
    CGContextRef ctx;
    float cell_size;
    float margin;
    
}
-(void)renderMap:(MGMap*)map toContext:(CGContextRef)context;
@end
