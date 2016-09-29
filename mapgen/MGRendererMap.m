//
//  MGRendererMap.m
//  mapgen
//
//  Created by Pat Smith on 30/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import "MGRendererMap.h"

@implementation MGRendererMap

-(void)renderGrid
{
    // Draw grid
    for (int i = 0; i <= map.width; i++) {
        CGFloat x = margin + i * cell_size;
        CGContextMoveToPoint(ctx, x, margin);
        CGContextAddLineToPoint(ctx, x, margin + map.height * cell_size);
    }
    for (int i = 0; i <= map.height; i++) {
        CGFloat y = margin + i * cell_size;
        CGContextMoveToPoint(ctx, margin, y);
        CGContextAddLineToPoint(ctx, margin + map.width * cell_size, y);
    }
    CGContextStrokePath(ctx);

}
-(void)renderDoorInRect:(CGRect)rect inOrientation:(int)o
{
    CGRect door;
    if (o) {
        // horz
        door = CGRectInset(rect, 4.0f, 7.0f);
        CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMidY(rect));
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMidY(rect));

    } else {
        // vert
        door = CGRectInset(rect, 7.0f, 4.0f);
        CGContextMoveToPoint(ctx, CGRectGetMidX(rect), CGRectGetMinY(rect));
        CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), CGRectGetMaxY(rect));
    }
    CGContextStrokePath(ctx);
    CGContextStrokeRect(ctx, door);
    CGContextSetRGBFillColor(ctx, 0.8, 0.5, 0.5, 0.6);
    CGContextFillRect(ctx, door);
}
-(void)renderMap:(MGMap *)_map toContext:(CGContextRef)_ctx
{    
    [super renderMap:_map toContext:_ctx];

    UIColor* currentColor = [UIColor blackColor];
    CGContextSetLineWidth(ctx, cell_size);
    CGContextSetStrokeColorWithColor(ctx, currentColor.CGColor);
    CGContextStrokeRect(ctx, CGRectMake(margin - cell_size / 2, margin - cell_size / 2, cell_size * (map.width + 1), cell_size * (map.height + 1)));
    
    
    currentColor = [UIColor lightGrayColor];
    CGContextSetLineWidth(ctx, 0.2f);
    CGContextSetStrokeColorWithColor(ctx, currentColor.CGColor);
    [self renderGrid];    
    CGContextSetLineWidth(ctx, 1.0f);    
    // Draw cells
    for (int x = 0; x < map.width; x++) {
        for (int y = 0; y < map.height; y++) {
            MGCell* cell = [map cellAtX:x Y:y];
            if (cell.type == MGCellTypeNone) {
                CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 1.0);
                CGContextFillRect(ctx, CGRectMake(margin + x * cell_size, margin + y * cell_size, cell_size, cell_size));
            }
            if (cell.type == MGCellTypePerimeter) {
                CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 1.0);
                CGContextFillRect(ctx, CGRectMake(margin + x * cell_size, margin + y * cell_size, cell_size, cell_size));
            }
            if (cell.type == MGCellTypeEntrance) {
                CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
                MGCell* c = [map cellAtX:x-1 Y:y];
                if (c.type == MGCellTypePerimeter) {
                    [self renderDoorInRect:CGRectMake(margin + x * cell_size, margin + y * cell_size, cell_size, cell_size) inOrientation:1];
                } else {
                    [self renderDoorInRect:CGRectMake(margin + x * cell_size, margin + y * cell_size, cell_size, cell_size) inOrientation:0];
                }
            }
        }
    }    
}

@end
