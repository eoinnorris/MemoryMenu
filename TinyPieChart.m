//
//  TinyPieChart.m
//  MemoryMenu
//
//  Created by Eoin Norris on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TinyPieChart.h"

@implementation TinyPieChart

+(void)load
{
	[super registerPlotItem:self];
}

-(void)renderInLayer:(CPTGraphHostingView *)layerHostingView withTheme:(CPTTheme *)theme{
    
	CGRect bounds = NSRectToCGRect(layerHostingView.bounds);
    
	CPTGraph *graph = [[[CPTXYGraph alloc] initWithFrame:bounds] autorelease];
	[self addGraph:graph toHostingView:layerHostingView];
	[self applyTheme:theme toGraph:graph withDefault:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    
    graph.plotAreaFrame.borderLineStyle = nil;    // don't draw a border
    graph.plotAreaFrame.masksToBorder = YES;

	// Add pie chart
	CPTPieChart *piePlot = [[CPTPieChart alloc] init];
	piePlot.dataSource = self;
	piePlot.pieRadius  = MIN(0.95 * (layerHostingView.frame.size.height - 2 * graph.paddingLeft) / 2.0,
							 0.95 * (layerHostingView.frame.size.width - 2 * graph.paddingTop) / 2.0);
	piePlot.identifier	   = title;
	piePlot.startAngle	   = M_PI_4;
	piePlot.sliceDirection = CPTPieDirectionClockwise;
    
	piePlot.delegate = self;
	[graph addPlot:piePlot];
	[piePlot release];
    
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index{
	
	return nil;
}
@end
