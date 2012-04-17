

#import "AppController.h"

@implementation AppController
@synthesize mainView;
@synthesize tableView;
@synthesize arrayController;

-(NSMenu*)customMenu{
    NSMenuItem* newItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Custom" action:NULL keyEquivalent:@""];
    NSMenu* newMenu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"Custom"];
    [newItem setEnabled:YES];
	[newItem setSubmenu:newMenu];
    [newMenu release];
	[[NSApp mainMenu] insertItem:newItem atIndex:3];
    [newItem release];
	
	// create the menu items for this menu
	
	// this menu item will have a view with one NSButton
	newItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Custom" action:@selector(menuItem1Action:) keyEquivalent:@""];
    [newItem setEnabled:YES];
    self.mainView.frame = NSMakeRect(0.0, 0.0, 400.0, 400.0);
	[newItem setView: self.mainView];
	[newItem setTarget:self];
    [newMenu addItem:newItem];
    [newItem release];
    
    return newMenu;

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
