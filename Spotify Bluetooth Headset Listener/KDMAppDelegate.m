//
//  KDMAppDelegate.m
//  Spotify Bluetooth Headset Listener
//
//  Created by KillerDeMouches on 06/01/2014.
//  Copyright (c) 2014 KDM Software. All rights reserved.
//

// TODO rename this app to MacBluetoothHeadsetListener (or something even *more* catchy ;) )

#import "KDMAppDelegate.h"
#import "MediaKey.h"

@interface KDMAppDelegate()
@property id eventMonitor;
@end

@implementation KDMAppDelegate {
	NSStatusItem * statusItem;
	IBOutlet NSMenu * statusItemMenu;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	if(![[NSUserDefaults standardUserDefaults] boolForKey:@"Hide menu Item"]){
		[self setupMenuItem];
	}

    // TODO determine why there is sometimes a several second delay before this monitor fires (is there another way that might be faster?)
	[NSTask launchedTaskWithLaunchPath:@"/bin/launchctl" arguments:@[@"unload",@"/System/Library/LaunchAgents/com.apple.rcd.plist"]];
	self.eventMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:(NSKeyDownMask|NSSystemDefinedMask)  handler:^(NSEvent * event) {
		int keyCode = (([event data1] & 0xFFFF0000) >> 16);
		
        int keyFlags = ([event data1] & 0x0000FFFF);
		
        int keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA;
		
		if(keyCode == 10 && keyFlags == 6972) {
            
            switch ([event data2]) {
                case 786608: // Play / Pause on OS < 10.10 Yosemite
                case 786637: // Play / Pause on OS >= 10.10 Yosemite
                    NSLog(@"Play/Pause bluetooth keypress detected...sending corresponding media key event");
                    [MediaKey send:NX_KEYTYPE_PLAY];
                    break;
                case 786611: // Fast-Forward
                    NSLog(@"Fast-Forward bluetooth keypress detected...sending corresponding media key event");
                    [MediaKey send:NX_KEYTYPE_FAST];
                    break;
                case 786612: // Rewind
                    NSLog(@"Rewind bluetooth keypress detected...sending corresponding media key event");
                    [MediaKey send:NX_KEYTYPE_REWIND];
                    break;
                case 786613: // Next
                    NSLog(@"Next bluetooth keypress detected...sending corresponding media key event");
                    [MediaKey send:NX_KEYTYPE_NEXT];
                    break;
                case 786614: // Previous
                    NSLog(@"Previous bluetooth keypress detected...sending corresponding media key event");
                    [MediaKey send:NX_KEYTYPE_PREVIOUS];
                    break;
                default:
                    // TODO make this popup a message in the UI (with a link to submit the issue and a "don't show this message again" checkbox)
                    NSLog(@"Unknown bluetooth key received.  Please visit https://github.com/jguice/mac-bt-headset-fix/issues and submit an issue describing what you expect the key to do (include the following data): keyCode:%i keyFlags:%i keyState:%i %li",keyCode,keyFlags,keyState,(long)[event data2]);
                    break;
            }			
		}
	}];
	return;
}

-(BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
    if(statusItem == nil) {
        [self setupMenuItem];
        [statusItem popUpStatusItemMenu:statusItem.menu];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"Hide menu Item"]){
                [statusItem.statusBar removeStatusItem:statusItem];
            }
        });
    }
    return NO;
}

- (void) setupMenuItem {
	if(statusItem == nil) {
		statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
		statusItem.image = [NSImage imageNamed:@"MenuItemTemplate"];
		statusItem.menu = statusItemMenu;
	}
}

- (void) applicationWillTerminate:(NSNotification *)notification {
	[NSTask launchedTaskWithLaunchPath:@"/bin/launchctl" arguments:@[@"load",@"/System/Library/LaunchAgents/com.apple.rcd.plist"]];
	[NSEvent removeMonitor:self.eventMonitor];
}

- (IBAction)hide:(id)sender {
	NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if([standardUserDefaults boolForKey:@"Hide menu Item"]) {
		[standardUserDefaults setBool:NO forKey:@"Hide menu Item"];
		[self setupMenuItem];
	}
	else {
		[standardUserDefaults setBool:YES forKey:@"Hide menu Item"];
		[statusItem.statusBar removeStatusItem:statusItem];
		statusItem = nil;
	}
}
- (BOOL) validateMenuItem:(NSMenuItem *)menuItem {
	if([menuItem action] == @selector(hide:)) {
		[menuItem setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"Hide menu Item"]?NSOnState:NSOffState];
		return YES;
	}
	return NO;
}
@end