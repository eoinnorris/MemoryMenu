//
//  CustomStatusView.h
//  MemoryMenu
//
//  Created by Eoin Norris on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TinyPieChart.h"

@interface CustomStatusView : NSView{
    TinyPieChart* tinyPieChart;
}

@property(nonatomic,retain) TinyPieChart* tinyPieChart;

@end
