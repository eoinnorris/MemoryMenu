//
//  CircularProgressView.h
//  QuatzTest
//
//  Created by soroush khodaii (soroush@turnedondigital.com) on 24/01/2011.
//  Copyright 2011 Turned On Digital. You are free todo whatever you want with this code :)
//

#import <Cocoa/Cocoa.h>


@interface CircularProgressView : NSView<NSMenuDelegate> {

	CGFloat _r;
	CGFloat _g;
	CGFloat _b;
	CGFloat _a;
	
	CGFloat _progress;
	
	CGRect _outerCircleRect;
	CGRect _innerCircleRect;
    
    NSStatusItem *statusItem;
    NSString *title;
    BOOL isMenuVisible;
}

@property (retain, nonatomic) NSStatusItem *statusItem;
@property (retain, nonatomic) NSString *title;

-(void) setProgress:(CGFloat) newProgress;		// set the component's value
-(void) setColourR:(CGFloat) r G:(CGFloat) g B:(CGFloat) b A:(CGFloat) a;	// set component colour, set using RGBA system, each value should be between 0 and 1.
-(CGFloat) progress; // returns the component's value.

@end
