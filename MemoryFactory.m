/* 
 * XRG (X Resource Graph):  A system resource grapher for Mac OS X.
 * Copyright (C) 2002-2009 Gaucho Software, LLC.
 * You can view the complete license in the LICENSE file in the root
 * of the source tree.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 */

//
//  XRGMemoryMiner.m
//

#import "MemoryFactory.h"
#include <sys/sysctl.h>

@implementation MemoryFactory
@synthesize graphView;
@synthesize freeMemory;
@synthesize wiredMemory;
@synthesize activeMemory;
@synthesize pagins;
@synthesize pageOuts;
@synthesize inActiveMemory;
@synthesize mainView;


-(void)reloadData{
    
    [memFactory getLatestMemoryInfo];
    NSInteger freeMem = [self freeBytes];
    NSInteger activeMem = [self activeBytes];
    NSInteger wiredMem = [self wiredBytes];
    NSInteger inActiveMem = [self inactiveBytes];
    
    NSNumber* freeMemN = [NSNumber numberWithInteger:freeMem];
    NSNumber* activeMemN = [NSNumber numberWithInteger:activeMem];
    NSNumber* wiredMemN = [NSNumber numberWithInteger:wiredMem];
    NSNumber* inActiveMemN = [NSNumber numberWithInteger:inActiveMem];
    NSArray* values = [NSArray arrayWithObjects:activeMemN,freeMemN,inActiveMemN,wiredMemN,nil]; 
      NSArray* names = [NSArray arrayWithObjects:@"Active Memory",@"Free Memory",@"InActive Memory",@"Wired Memory",nil];
    
    if (pieChart == nil){
        [SimplePieChart load];
      
        pieChart = [[SimplePieChart alloc] init];
        pieChart.legendNames = names;
    }
    
    if (self.customStatusView == nil){
        self.customStatusView   = [[CustomStatusView alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 20.0)];
        [TinyPieChart load];
        self.customStatusView.tinyPieChart = [[TinyPieChart alloc] init];
        self.customStatusView.tinyPieChart.legendNames = names;

    }
    
    pieChart.plotData = values;
    self.customStatusView.tinyPieChart.plotData = values;
    [ self.customStatusView.tinyPieChart renderInView:self.customStatusView withTheme:[CPTTheme themeNamed:@"Memory Pie"]];
    [pieChart renderInView:self.graphView withTheme:[CPTTheme themeNamed:@"Memory Pie"]];
    
    
    
    [mainView setNeedsDisplay:YES];
    if (timer == nil){
        timer = [[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reloadData) userInfo:nil repeats:YES] retain];
    }
    
    
}
- (id)init {
    host = mach_host_self();

    
	usedSwap = totalSwap = 0.;
	
	int mib[2] = { CTL_HW, HW_PAGESIZE };
	size_t sz = sizeof(pageSize);
	if (-1 == sysctl(mib, 2, &pageSize, &sz, NULL, 0))
		pageSize = PAGE_SIZE;
	
    [self getLatestMemoryInfo];
    
    return self;
}

- (void)getLatestMemoryInfo {
    kern_return_t kr;
    vm_statistics_data_t stats;
    unsigned int numBytes = HOST_VM_INFO_COUNT;
    
    kr = host_statistics(host, HOST_VM_INFO, (host_info_t)&stats, &numBytes);
    if (kr != KERN_SUCCESS) {
        return;
    }
    else {
        currentDiffs.free_count      = (stats.free_count - lastStats.free_count);
        currentDiffs.active_count    = (stats.active_count - lastStats.active_count);
        currentDiffs.inactive_count  = (stats.inactive_count - lastStats.inactive_count);
        currentDiffs.wire_count      = (stats.wire_count - lastStats.wire_count);
        currentDiffs.faults          = (stats.faults - lastStats.faults);
        currentDiffs.pageins         = (stats.pageins - lastStats.pageins);
        currentDiffs.pageouts        = (stats.pageouts - lastStats.pageouts);
            
        lastStats.free_count         = stats.free_count;
        lastStats.active_count       = stats.active_count;
        lastStats.inactive_count     = stats.inactive_count;
        lastStats.wire_count         = stats.wire_count;
        lastStats.faults             = stats.faults;
        lastStats.pageins            = stats.pageins;
        lastStats.pageouts           = stats.pageouts;
        lastStats.lookups            = stats.lookups;
        lastStats.hits               = stats.hits;
    }
	
	// Swap space monitoring.
	int vmmib[2] = { CTL_VM, VM_SWAPUSAGE };
    struct xsw_usage swapInfo;
    size_t swapLength = sizeof(swapInfo);
    if (sysctl(vmmib, 2, &swapInfo, &swapLength, NULL, 0) >= 0) {
		usedSwap = swapInfo.xsu_used;
		totalSwap = swapInfo.xsu_total;
    }		
}

// actually kilobytes, not bytes
- (NSUInteger)freeBytes {
    return (NSUInteger)lastStats.free_count * (pageSize / 1024.);
}

- (NSUInteger)activeBytes {
    return (NSUInteger)lastStats.active_count * (pageSize / 1024.);
}

- (NSUInteger)inactiveBytes {
    return (NSUInteger)lastStats.inactive_count * (pageSize / 1024.);
}

- (NSUInteger)wiredBytes {
    return (NSUInteger)lastStats.wire_count * (pageSize / 1024.);
}

- (u_int32_t)totalFaults {
    return lastStats.faults;
}

- (u_int32_t)recentFaults {
    return currentDiffs.faults;
}

- (u_int32_t)totalPageIns {
    return lastStats.pageins;
}

- (u_int32_t)recentPageIns {
    return currentDiffs.pageins;
}

- (u_int32_t)totalPageOuts {
    return lastStats.pageouts;
}

- (u_int32_t)recentPageOuts {
    return currentDiffs.pageouts;
}

- (u_int32_t)totalCacheLookups {
    return lastStats.lookups;
}

- (u_int32_t)totalCacheHits {
    return lastStats.hits;
}

- (u_int64_t)usedSwap {
	return usedSwap;
}

- (u_int64_t)totalSwap {
	return totalSwap;
}

@end
