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
    
    u_int32_t recentPageIns  = [self.memFactory recentPageIns];
    u_int32_t recentPageOuts  = [self.memFactory recentPageOuts];
    
    freeMem /= 1024;
    activeMem /= 1024;
    wiredMem /= 1024;
    inActiveMem /= 1024;
    
    NSString* freeMemStr = [NSString stringWithFormat:@"%dM",freeMem];
    NSString* activeMemStr = [NSString stringWithFormat:@"%dM",activeMem];
    NSString* wiredMemStr = [NSString stringWithFormat:@"%dM",wiredMem];
    NSString* inActiveMemStr = [NSString stringWithFormat:@"%dM",inActiveMem];


    NSString* recentPageInStr = [NSString stringWithFormat:@"%u",recentPageIns];
    NSString* recentPageOutStr = [NSString stringWithFormat:@"%u",recentPageOuts];


    self.freeMemory.stringValue = freeMemStr;
    self.wiredMemory.stringValue = wiredMemStr;
    self.activeMemory.stringValue = activeMemStr;
    self.inActiveMemory.stringValue = inActiveMemStr;
    self.pagins.stringValue = recentPageInStr;
    self.pageOuts.stringValue = recentPageOutStr;
    

    
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
