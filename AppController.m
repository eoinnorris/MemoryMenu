

#import "AppController.h"

@implementation AppController
@synthesize mainView;
@synthesize tableView;
@synthesize arrayController;

-(void)quitSelectedApps{
    
}

-(void)closeSelectedApps{
    
}

-(void)quitAndRelaunchSelectedApps{
    
}

-(void)purgeMemory{
    
}

-(void)logout{
    
}

-(NSMenu*)customMenu{
    NSMenu* newMenu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"Custom"];	
	// create the menu items for this menu
	
	// this menu item will have a view with one NSButton
	NSMenuItem* customItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Custom" action:nil keyEquivalent:@""];
    [customItem setEnabled:YES];
    self.mainView.frame = NSMakeRect(0.0, 0.0, 400.0, 400.0);
	[customItem setView: self.mainView];
	[customItem setTarget:self];
    [newMenu addItem:customItem];
    [customItem release];
    
    NSMenuItem* quitItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Quit Selected..." action:@selector(quitSelectedApps) keyEquivalent:@""];
    [quitItem setEnabled:YES];
	[quitItem setTarget:self];
    [newMenu addItem:quitItem];
    [quitItem release];
    
    NSMenuItem* quitRelaunchItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Quit And Relaunch Selected..." action:@selector(quitAndRelaunchSelectedApps) keyEquivalent:@""];
    [quitRelaunchItem setEnabled:YES];
	[quitRelaunchItem setTarget:self];
    [newMenu addItem:quitRelaunchItem];
    [quitRelaunchItem release];
    
    
    NSMenuItem* closeItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Close Windows for Selection" action:@selector(closeSelectedApps) keyEquivalent:@""];
    [closeItem setEnabled:YES];
	[closeItem setTarget:self];
    [newMenu addItem:closeItem];
    [closeItem release];
    
    NSMenuItem* purgeItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Purge Inactive Memory" action:@selector(purgeMemory) keyEquivalent:@""];
    [purgeItem setEnabled:YES];
	[purgeItem setTarget:self];
    [newMenu addItem:purgeItem];
    [purgeItem release];
    
    
    NSMenuItem* logOut = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Logout" action:@selector(logout) keyEquivalent:@""];
    [logOut setEnabled:YES];
	[logOut setTarget:self];
    [newMenu addItem:logOut];
    [logOut release];
    
    
    return [newMenu autorelease];

}

- (void)activateStatusMenu
{
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    
    NSStatusItem* theItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    [theItem retain];
    
    [theItem setTitle: NSLocalizedString(@"TT",@"")];
    [theItem setHighlightMode:YES];
    [theItem setMenu:[self customMenu]];
}

-(void)awakeFromNib{
    [self activateStatusMenu];
}

// this enables us to use bindings to drive the app's UI
- (NSWorkspace *)workspace;
{
	return [NSWorkspace sharedWorkspace];
}

- (NSArray *)sortDescriptors;
{
    return [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"localizedName" ascending:YES]];
}


// user clicked the "Hide" button
- (IBAction)hideAction:(id)sender;
{
	NSRunningApplication *selectedApp = [arrayController.selectedObjects objectAtIndex:0];
	[selectedApp hide];
}

// user clicked the "Unhide" button
- (IBAction)unhideAction:(id)sender;
{
	NSRunningApplication *selectedApp = [arrayController.selectedObjects objectAtIndex:0];
	[selectedApp unhide];
}

// user clicked the "Quit" button
- (IBAction)quitAction:(id)sender;
{
	NSRunningApplication *selectedApp = [arrayController.selectedObjects objectAtIndex:0];
	[selectedApp terminate];
}

@end

#pragma mark -

// this value transformer simply converts "NSBundleExecutableArchitecture" to a readable string
//
@implementation ExecutableArchitectureTransformer

+ (Class)transformedValueClass;
{
	return [NSString class];
}

+ (BOOL)allowsReverseTransformation;
{
	return NO;
}

- (id)transformedValue:(id)value;
{
	NSString *archStr;
	
	switch ([value intValue])
	{
		case NSBundleExecutableArchitectureI386:
			archStr = @"Intel 32-bit";
			break;
            
		case NSBundleExecutableArchitectureX86_64:
			archStr = @"Intel 64-bit";
			break;
            
		case NSBundleExecutableArchitecturePPC:
			// in case of Rosetta, allow for PPC
			archStr = @"PPC Translated";
			break;
			
		default:
			archStr = @"unknown";
			break;
	}
	return archStr;
}

@end

@implementation NSRunningApplication (BooleanPropertiesAsStrings)

- (NSString *)activeString;
{
    return self.active ? NSLocalizedString(@"Yes", @"Yes") : NSLocalizedString(@"No", @"No");
}

- (NSString *)hiddenString;
{
    return self.hidden ? NSLocalizedString(@"Yes", @"Yes") : NSLocalizedString(@"No", @"No");
}

@end
