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

@implementation KDMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[NSTask launchedTaskWithLaunchPath:@"/bin/launchctl" arguments:@[@"unload",@"/System/Library/LaunchAgents/com.apple.rcd.plist"]];
	self.eventMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:(NSKeyDownMask|NSSystemDefinedMask)  handler:^(NSEvent * event) {
		int keyCode = (([event data1] & 0xFFFF0000) >> 16);
		
        int keyFlags = ([event data1] & 0x0000FFFF);
		
        int keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA;
		
		if(keyCode == 10 && keyFlags == 6972) {
			SpotifyApplication * spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
			switch ([event data2]) {
				case 786608: // Play / Pause
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

- (void) applicationWillTerminate:(NSNotification *)notification {
	[NSTask launchedTaskWithLaunchPath:@"/bin/launchctl" arguments:@[@"load",@"/System/Library/LaunchAgents/com.apple.rcd.plist"]];
	[NSEvent removeMonitor:self.eventMonitor];
}
@end