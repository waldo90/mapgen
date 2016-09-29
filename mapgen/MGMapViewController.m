//
//  MGMapViewController.m
//  mapgen
//
//  Created by Pat Smith on 10/05/2012.
//  Copyright (c) 2012 Pat Smith. All rights reserved.
//

#import "MGMapViewController.h"
#import "MGMapView.h"
#import "MGGenerator.h"
#import "MGRendererMap.h"


@interface MGMapViewController ()

@end

@implementation MGMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [tapRecognizer setDelegate:self];
        [self.view addGestureRecognizer:tapRecognizer];
        
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [panRecognizer setDelegate:self];
        [panRecognizer setMinimumNumberOfTouches:1];
        [self.view addGestureRecognizer:panRecognizer];
        
        last_point = CGPointMake(0.0f, 0.0f);
        
        [(MGMapView*)self.view setRenderer:[[MGRendererMap alloc] init] ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self generateNewMap];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self generateNewMap];
    [self.view setNeedsDisplay];
}

-(void)handlePan:(UIPanGestureRecognizer*) sender
{
    MGMapView* view = (MGMapView*)self.view;
    if (sender.state == UIGestureRecognizerStateBegan) {
        last_point = view.point;
    }
    CGPoint point = [sender translationInView:self.view];
    CGPoint trans = CGPointMake(last_point.x + point.x, last_point.y + point.y);
    [view setPoint:trans];
    [self.view setNeedsDisplay];
}

-(void)generateNewMap
{
    // using generator
    MGGenerator* generator = [[MGGenerator alloc] initWithSize:CGSizeMake(35,35)];
    
    [generator generate];
    MGMapView* mv = (MGMapView*)[self view];
    mv.map = generator.map;    
}
@end
