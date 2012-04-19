//
//  MemoryViewController.m
//  MemoryMenu
//
//  Created by Eoin Norris on 19/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MemoryViewController.h"
#import "MemoryFactory.h"

@interface MemoryViewController ()@property (nonatomic,retain) MemoryFactory* memFactory;
@end

@implementation MemoryViewController
@synthesize graphView;
@synthesize freeMemory;
@synthesize wiredMemory;
@synthesize activeMemory;
@synthesize pagins;
@synthesize pageOuts;
@synthesize inActiveMemory;
@synthesize mainView;
@synthesize memFactory;


-(void)reloadData{
    
    [memFactory getLatestMemoryInfo];
    NSInteger freeMem = [self.memFactory freeBytes];
    NSInteger activeMem = [self.memFactory activeBytes];
    NSInteger wiredMem = [self.memFactory wiredBytes];
    NSInteger inActiveMem = [self.memFactory inactiveBytes];
    
    NSNumber* freeMemN = [NSNumber numberWithInteger:freeMem];
    NSNumber* activeMemN = [NSNumber numberWithInteger:activeMem];
    NSNumber* wiredMemN = [NSNumber numberWithInteger:wiredMem];
    NSNumber* inActiveMemN = [NSNumber numberWithInteger:inActiveMem];
  
#if 0
    
    u_int32_t recentPageIns  = [self.memFactory recentPageIns];
    u_int32_t recentPageOuts  = [self.memFactory recentPageOuts];
    
    
    NSString* recentPageInStr = [NSString stringWithFormat:@"%u",recentPageIns];
    NSString* recentPageOutStr = [NSString stringWithFormat:@"%u",recentPageOuts];
    
#endif
    
    
    if (pieChart == nil){
        [SimplePieChart load];
        pieChart = [[SimplePieChart alloc] init];
         pieChart.legendNames = [NSArray arrayWithObjects:@"Active Memory",@"Free Memory",@"InActive Memory",@"Wired Memory",nil];
    }
    
    pieChart.plotData = [NSArray arrayWithObjects:activeMemN,freeMemN,inActiveMemN,wiredMemN,nil]; 
    [pieChart renderInView:self.graphView withTheme:[CPTTheme themeNamed:@"Memory Pie"]];

    
    [mainView setNeedsDisplay:YES];
    if (timer == nil){
        timer = [[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reloadData) userInfo:nil repeats:YES] retain];
    }
    
    
}

-(void)awakeFromNib{
    self.memFactory = [[[MemoryFactory alloc] init] autorelease];
    [self reloadData];
}

-(void)dealloc{
    
    [timer invalidate];
    [timer release];
    timer = nil;
    
    self.memFactory = nil;
    
    [super dealloc];
}

@end
