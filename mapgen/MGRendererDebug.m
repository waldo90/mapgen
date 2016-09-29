//
//  MGRendererDebug.m
//  mapgen
//
//  Created by Pat Smith on 24/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import "MGRendererDebug.h"

@implementation MGRendererDebug

-(void)renderMap:(MGMap *)_map toContext:(CGContextRef)_ctx
{
    map = _map;
    ctx = _ctx;
    
    UIColor* currentColor = [UIColor redColor];
    
    // Set 'pen' width
    CGContextSetLineWidth(ctx, 1.0f);
    // Set 'pen' color
    CGContextSetStrokeColorWithColor(ctx, currentColor.CGColor);
    
    // Draw grid
    for (int i = 0; i <= map.width; i++) {
        CGFloat x = 100 + i * 20;
        CGContextMoveToPoint(ctx, x, 90.0f);
        CGContextAddLineToPoint(ctx, x, 100.0f + map.height * 20.0f);
        NSString* l = [NSString stringWithFormat:@"%d", i];
        [l drawInRect:CGRectMake(x, 80.0f, 20.0f, 20.0f) 
             withFont:[UIFont systemFontOfSize:11.0f]
        lineBreakMode:NSLineBreakByClipping
            alignment:NSTextAlignmentCenter];
        
    }
    for (int i = 0; i <= map.height; i++) {
        CGFloat y = 100 + i * 20;
        CGContextMoveToPoint(ctx, 90.0f, y);
        CGContextAddLineToPoint(ctx, 100.0f + map.width * 20.0f, y);
        NSString* l = [NSString stringWithFormat:@"%d", i];
        [l drawInRect:CGRectMake(80.0f, y, 20.0f, 20.0f) 
             withFont:[UIFont systemFontOfSize:11.0f]
        lineBreakMode:NSLineBreakByClipping
            alignment:NSTextAlignmentCenter];
    }
    
    CGContextStrokePath(ctx);
    
    // Draw cells
    for (int x = 0; x < map.width; x++) {
        for (int y = 0; y < map.height; y++) {
            MGCell* cell = [map cellAtX:x Y:y];
            if (cell.type == MGCellTypeNone) {
                CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 0.7);
                CGContextFillRect(ctx, 
                                  CGRectMake(100 + x*20, 100.0 + y*20, 20.0, 20.0));
            }
            if (cell.type == MGCellTypePerimeter) {
                CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 0.7);
                CGContextFillRect(ctx, 
                                  CGRectMake(100 + x*20, 100.0 + y*20, 20.0, 20.0));
            }
            if (cell.type == MGCellTypeEntrance) {
                CGContextSetRGBFillColor(ctx, 0.0, 0.0, 1.0, 0.3);
                CGContextFillRect(ctx, 
                                  CGRectMake(100 + x*20, 100.0 + y*20, 20.0, 20.0));
            }
            
            if (cell.type == MGCellTypeCorridor) {
                CGContextSetRGBFillColor(ctx, 0.0, 1.0, 0.0, 0.1);
                CGContextFillRect(ctx, 
                                  CGRectMake(100 + x*20, 100.0 + y*20, 20.0, 20.0));
            }
        }
    }    
}
@end
