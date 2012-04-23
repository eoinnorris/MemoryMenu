

#import <Foundation/Foundation.h>
#import <mach/host_info.h>
#import <mach/mach_host.h>
#import "SimplePieChart.h"
#import "CustomStatusView.h"

@interface MemoryFactory : NSObject {
@private
    int				numSamples;
    
    host_name_port_t			host;
    vm_statistics_data_t		currentDiffs;
    vm_statistics_data_t		lastStats;
	
	u_int64_t					usedSwap;
	u_int64_t					totalSwap;
	
	u_int32_t					pageSize;
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
    
    CustomStatusView* customStatusView;
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
@property (assign) CustomStatusView* customStatusView;

- (void)getLatestMemoryInfo;

// actually kilobytes, not bytes - limited to 4TB with 32bit
- (NSUInteger)freeBytes;
- (NSUInteger)activeBytes;
- (NSUInteger)inactiveBytes;
- (NSUInteger)wiredBytes;
- (u_int32_t)totalFaults;
- (u_int32_t)recentFaults;
- (u_int32_t)totalPageIns;
- (u_int32_t)recentPageIns;
- (u_int32_t)totalPageOuts;
- (u_int32_t)recentPageOuts;
- (u_int32_t)totalCacheLookups;
- (u_int32_t)totalCacheHits;
- (u_int64_t)usedSwap;
- (u_int64_t)totalSwap;

@end
