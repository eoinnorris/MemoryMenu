//
//  CustomStatusView.m
//  MemoryMenu
//
//  Created by Eoin Norris on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomStatusView.h"

@implementation CustomStatusView

@synthesize tinyPieChart;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [TinyPieChart load];
        self.tinyPieChart = [[[TinyPieChart alloc] init] autorelease];
        
        
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
