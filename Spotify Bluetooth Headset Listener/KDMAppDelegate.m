//
//  KDMAppDelegate.m
//  Spotify Bluetooth Headset Listener
//
//  Created by KillerDeMouches on 06/01/2014.
//  Copyright (c) 2014 KDM Software. All rights reserved.
//

#import "KDMAppDelegate.h"
#import "Spotify.h"

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

	[NSTask launchedTaskWithLaunchPath:@"/bin/launchctl" arguments:@[@"unload",@"/System/Library/LaunchAgents/com.apple.rcd.plist"]];
	self.eventMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:(NSKeyDownMask|NSSystemDefinedMask)  handler:^(NSEvent * event) {
		int keyCode = (([event data1] & 0xFFFF0000) >> 16);
		
        int keyFlags = ([event data1] & 0x0000FFFF);
		
        int keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA;
		
		if(keyCode == 10 && keyFlags == 6972) {
			SpotifyApplication * spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
			switch ([event data2]) {
				case 786608: // Play / Pause on OS < 10.10 Yosemite
                case 786637: // Play / Pause on OS >= 10.10 Yosemite
					if([spotify playerState] == SpotifyEPlSPaused)
						[spotify play];
					else
						[spotify pause];
					break;
				case 786613: // Next
					[spotify nextTrack];
					break;
				case 786614: // Previous
					[spotify previousTrack];
					break;
				default:
					NSLog(@"keyCode:%i keyFlags:%i keyState:%i %li",keyCode,keyFlags,keyState,(long)[event data2]);
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