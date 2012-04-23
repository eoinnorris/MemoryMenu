//
//  CircularProgressView.m
//  QuatzTest
//
//  Created by soroush khodaii (soroush@turnedondigital.com) on 24/01/2011.
//  Copyright 2011 Turned On Digital. You are free todo whatever you want with this code :)
//

#import "CircularProgressView.h"
#import <QuartzCore/QuartzCore.h>

#define StatusItemViewPaddingWidth  6
#define StatusItemViewPaddingHeight 3

@implementation CircularProgressView

@synthesize  statusItem;
@synthesize title;

#pragma mark -
#pragma mark Drawing Code:

 - (void)drawRect:(NSRect)rect {
 // Drawing code.
	 
	 // get the drawing canvas (CGContext):
	 CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

	 // save the context's previous state:
	 CGContextSaveGState(context);
	 
	 // our custom drawing code will go here:
	 
	 // Draw the gray background for our progress view:
	 

	
	 
	 // draw outline so that the edges are smooth:
	
	 // set line width
	 CGContextSetLineWidth(context, 0.5);
	 // set the colour when drawing lines R,G,B,A. (we will set it to the same colour we used as the start and end point of our gradient )
	 CGContextSetRGBStrokeColor(context, 0.4,0.4,0.4,0.9);
	 
	 // draw an ellipse in the provided rectangle
	 CGContextAddEllipseInRect(context, _outerCircleRect);
	 CGContextStrokePath(context);
	 
     
	 CGContextAddEllipseInRect(context, _innerCircleRect);
	 CGContextStrokePath(context);
	 
	 
	 
	 // Draw the progress:
	 
	 // First clip the drawing area:
	 // save the context before clipping
	 CGContextSaveGState(context);
	 CGContextMoveToPoint(context, 
						  _outerCircleRect.origin.x + _outerCircleRect.size.width/2, // move to the top center of the outer circle
						  _outerCircleRect.origin.y +1); // the Y is one more because we want to draw inside the bigger circles.
	 // add an arc relative to _progress
	 CGContextAddArc(context, 
					 _outerCircleRect.origin.x + _outerCircleRect.size.width/2,
					 _outerCircleRect.origin.y + _outerCircleRect.size.width/2,
					 _outerCircleRect.size.width/2 - 1,
					 -M_PI/2,
					 (-M_PI/2 + _progress*2*M_PI), 0);
	 CGContextAddArc(context, 
					 _outerCircleRect.origin.x + _outerCircleRect.size.width/2,
					 _outerCircleRect.origin.y + _outerCircleRect.size.width/2,
					 _outerCircleRect.size.width/2 - 9,
					 (-M_PI/2 + _progress*2*M_PI),
					 -M_PI/2, 1);
	 // use clode path to connect the last point in the path with the first point (to create a closed path)
	 CGContextClosePath(context);
	 // clip to the path stored in context
	 CGContextClip(context);
	 
	 // Progress drawing code comes here:
	 


	 
	 // draw circle on the outline to smooth it out.
	 
	 CGContextSetRGBStrokeColor(context, _r,_g,_b,_a);
	 
	 // draw an ellipse in the provided rectangle
	 CGContextAddEllipseInRect(context, _outerCircleRect);
	 CGContextStrokePath(context);
	 
	 CGContextAddEllipseInRect(context, _innerCircleRect);
	 CGContextStrokePath(context);
	 
	 
	 //restore the context and remove the clipping area.
	 CGContextRestoreGState(context);

	 // restore the context's state when we are done with it:
	 CGContextRestoreGState(context);
 }


#pragma mark -
#pragma mark Setter & Getters:

// set the component's value
-(void) setProgress:(CGFloat) newProgress {
	_progress = newProgress;
	[self setNeedsDisplayInRect:self.bounds];
}

// set component colour, set using RGBA system, each value should be between 0 and 1.
-(void) setColourR:(CGFloat) r G:(CGFloat) g B:(CGFloat) b A:(CGFloat) a {
	_r = r;
	_g = g;
	_b = b;
	_a = a;
	[self setNeedsDisplayInRect:self.bounds];
}

// returns the component's value.
-(CGFloat) progress {
	return _progress;
}

- (void)mouseDown:(NSEvent *)event {
    [[self menu] setDelegate:self];
    [statusItem popUpStatusItemMenu:[self menu]];
    [self setNeedsDisplay:YES];
}

- (void)rightMouseDown:(NSEvent *)event {
    // Treat right-click just like left-click
    [self mouseDown:event];
}

- (void)menuWillOpen:(NSMenu *)menu {
    isMenuVisible = YES;
    [self setNeedsDisplay:YES];
}

- (void)menuDidClose:(NSMenu *)menu {
    isMenuVisible = NO;
    [menu setDelegate:nil];    
    [self setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark Superclass Methods:

#define circumfrenceSize 2.0

- (id)initWithFrame:(NSRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		// set initial UIView state
	//	self.backgroundColor = [NSColor clearColor];
		self.hidden = NO;
		
		// set class variables to default values
		_r = 1.0;
		_g = 0.1;
		_b = 0.1;
		_a = 1.0;
		
		_progress = 0.3;
		

		// find the radius and position for the largest circle that fits in the UIView's frame.
		int radius, x, y;
			// in case the given frame is not square (oblong) we need to check and use the shortest side as our radius.			
		if (frame.size.width > frame.size.height) {
			radius = frame.size.height;
			// we want our circle to be in the center of the frame.
			int delta = frame.size.width - radius;
			x = delta/2;
			y = 0;
		}else {
			radius = frame.size.width;
			int delta = frame.size.height - radius;
			y = delta/2;
			x = 0;
		}
		
		// store the largest circle's position and radius in class variable.
		_outerCircleRect = CGRectMake(x, y, radius, radius);
		// store the inner circles rect, this inner circle will have a radius 10pixels smaller than the outer circle.
		// we want to the inner circle to be in the middle of the outer circle.
		_innerCircleRect = CGRectMake(x+circumfrenceSize, y+circumfrenceSize, radius-2*circumfrenceSize , radius-2*circumfrenceSize );
		
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
