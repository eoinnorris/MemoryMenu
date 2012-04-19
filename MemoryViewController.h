//
//  MemoryViewController.h
//  MemoryMenu
//
//  Created by Eoin Norris on 19/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CorePlot/CorePlot.h"
#import "SimplePieChart.h"
@class MemoryFactory;

@interface MemoryViewController : NSViewController {
    NSTextField *freeMemory;
    NSTextField *wiredMemory;
    NSTextField *activeMemory;
    NSTextField *pagins;
    NSTextField *pageOuts;
    NSTextField *inActiveMemory;
    NSView *mainView;
    MemoryFactory* memFactory;
    NSTimer* timer;
    SimplePieChart* pieChart;

    CPTGraphHostingView *graphView;
}
@property (assign) IBOutlet CPTGraphHostingView *graphView;

@property (assign) IBOutlet NSTextField *freeMemory;
@property (assign) IBOutlet NSTextField *wiredMemory;
@property (assign) IBOutlet NSTextField *activeMemory;
@property (assign) IBOutlet NSTextField *pagins;
@property (assign) IBOutlet NSTextField *pageOuts;
@property (assign) IBOutlet NSTextField *inActiveMemory;
@property (assign) IBOutlet NSView *mainView;


@end
