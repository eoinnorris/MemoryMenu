//
//  SimplePieChart.h
//  CorePlotGallery
//
//  Created by Jeff Buck on 8/2/10.
//  Copyright 2010 Jeff Buck. All rights reserved.
//

#import "PlotItem.h"

@interface SimplePieChart : PlotItem<CPTPlotSpaceDelegate,
									 CPTPlotDataSource>
{
	NSArray *plotData;
    NSArray *legendNames;
}

@property(nonatomic,retain) NSArray *plotData;
@property(nonatomic,retain) NSArray *legendNames;
@end
