//
//  SimplePieChart.m
//  CorePlotGallery
//
//  Created by Jeff Buck on 8/2/10.
//  Copyright 2010 Jeff Buck. All rights reserved.
//

#import "SimplePieChart.h"

@implementation SimplePieChart

@synthesize plotData;
@synthesize legendNames;

+(void)load
{
	[super registerPlotItem:self];
}

-(id)init
{
	if ( (self = [super init]) ) {
		title = @"System Memory";
	}

	return self;
}

-(void)killGraph
{
	[super killGraph];
}

-(void)dealloc
{
	[plotData release];
    [legendNames release];
	[super dealloc];
}




-(void)renderInLayer:(CPTGraphHostingView *)layerHostingView withTheme:(CPTTheme *)theme
{

	CGRect bounds = NSRectToCGRect(layerHostingView.bounds);

	CPTGraph *graph = [[[CPTXYGraph alloc] initWithFrame:bounds] autorelease];
	[self addGraph:graph toHostingView:layerHostingView];
	[self applyTheme:theme toGraph:graph withDefault:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];

   
    
	graph.title = title;
	CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
	textStyle.color				   = [CPTColor blackColor];
	textStyle.fontName			   = @"Arial";
	textStyle.fontSize			   = bounds.size.height / 20.0f;
	graph.titleTextStyle		   = textStyle;
	graph.titleDisplacement		   = CGPointMake(0.0f, -20.f);
	graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.plotAreaFrame.borderLineStyle = nil;    // don't draw a border


	graph.plotAreaFrame.masksToBorder = NO;

	// Graph padding
	CGFloat boundsPadding = bounds.size.width / 200.0f;
	graph.paddingLeft	= boundsPadding;
	graph.paddingTop	= 10;//graph.titleDisplacement.y;
	graph.paddingRight	= boundsPadding;
	graph.paddingBottom = 70;

	graph.axisSet = nil;

	// Overlay gradient for pie chart
	CPTGradient *overlayGradient = [[[CPTGradient alloc] init] autorelease];
	overlayGradient.gradientType = CPTGradientTypeRadial;
	overlayGradient				 = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.0];
	overlayGradient				 = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.3] atPosition:0.9];
	overlayGradient				 = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.7] atPosition:1.0];

	// Add pie chart
	CPTPieChart *piePlot = [[CPTPieChart alloc] init];
	piePlot.dataSource = self;
	piePlot.pieRadius  = MIN(0.95 * (layerHostingView.frame.size.height - 2 * graph.paddingLeft) / 2.0,
							 0.95 * (layerHostingView.frame.size.width - 2 * graph.paddingTop) / 2.0);
	piePlot.identifier	   = title;
	piePlot.startAngle	   = M_PI_4;
	piePlot.sliceDirection = CPTPieDirectionClockwise;
	//piePlot.overlayFill	   = [CPTFill fillWithGradient:overlayGradient];

	piePlot.delegate = self;
	[graph addPlot:piePlot];
	[piePlot release];

	// Add legend
	CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
	theLegend.numberOfColumns = 1;
	theLegend.fill			  = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.swatchSize = CGSizeMake(8, 8);
    CPTMutableTextStyle *legendTextStyle = [CPTMutableTextStyle textStyle];
	legendTextStyle.color				   = [CPTColor blackColor];
	legendTextStyle.fontSize			   = 10.0;
    theLegend.textStyle = legendTextStyle;
	theLegend.cornerRadius	  = 5.0;

	graph.legend = theLegend;

	graph.legendAnchor		 = CPTRectAnchorCenter;
	graph.legendDisplacement = CGPointMake(0.0, -100.0);
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
	static CPTMutableTextStyle *whiteText = nil;

	if ( !whiteText ) {
		whiteText		= [[CPTMutableTextStyle alloc] init];
		whiteText.color = [CPTColor whiteColor];
	}

	CPTTextLayer *newLayer = [[[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%3.0f", [[plotData objectAtIndex:index] floatValue]]
														   style:whiteText] autorelease];
	return newLayer;
}

-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)index
{
	NSLog(@"Slice was selected at index %d. Value = %f", (int)index, [[plotData objectAtIndex:index] floatValue]);

}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
	return [plotData count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSNumber *num;

	if ( fieldEnum == CPTPieChartFieldSliceWidth ) {
		num = [plotData objectAtIndex:index];
	}
	else {
		return [NSNumber numberWithInt:index];
	}

	return num;
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    NSString* result = [NSString stringWithFormat:@"Pie Slice %u", index];
    if (index < legendNames.count){
        result = [legendNames objectAtIndex:index];
    }
    
    return result;
}

@end
