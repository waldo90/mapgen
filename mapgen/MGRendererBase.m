//
//  MGRendererBase.m
//  mapgen
//
//  Created by Pat Smith on 24/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import "MGRendererBase.h"


@implementation MGRendererBase

-(void)renderMap:(MGMap *)_map toContext:(CGContextRef)_ctx
{
    map = _map;
    ctx = _ctx;
    cell_size = 20.0f;
    margin = 40.0f;
}

@end
