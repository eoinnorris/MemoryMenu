
#import <Cocoa/Cocoa.h>

@interface AppController : NSObject
{
	// You can't put NSWorkspace instances in nibs, so we need a way for this
	// app controller to provide it for the bindings in the nib.
	//
	NSWorkspace *workspace;	
	
	// note: this array controller is automatically populated through the use of its
	// content binding, bound to this object, model key path = workspace.runningApplications
	//
	IBOutlet NSArrayController *arrayController;
    NSView *mainView;
    NSTableView *tableView;
}

@property (readonly) NSWorkspace *workspace;
@property (readonly) NSArray *sortDescriptors;
@property (assign) IBOutlet NSView *mainView;
@property (assign) IBOutlet NSTableView *tableView;
@property (assign) IBOutlet NSArrayController *arrayController;

- (IBAction)hideAction:(id)sender;
- (IBAction)unhideAction:(id)sender;
- (IBAction)quitAction:(id)sender;

@end

// used for translating bundle architecture constants to readable strings
@interface ExecutableArchitectureTransformer : NSObject
{ }
@end

// used to bind readable text from bool properties
@interface NSRunningApplication (BooleanPropertiesAsStrings)
@property (readonly) NSString *activeString;
@property (readonly) NSString *hiddenString;
@end

