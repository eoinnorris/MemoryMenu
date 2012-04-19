

#import <Foundation/Foundation.h>
#import <mach/host_info.h>
#import <mach/mach_host.h>

@interface MemoryFactory : NSObject {
@private
    int				numSamples;
    
    host_name_port_t			host;
    vm_statistics_data_t		currentDiffs;
    vm_statistics_data_t		lastStats;
	
	u_int64_t					usedSwap;
	u_int64_t					totalSwap;
	
	u_int32_t					pageSize;
}

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
