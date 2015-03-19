//
//  MediaKeys.h
//  Spotify Bluetooth Headset Listener
//
//  Created by Josh Guice on 3/15/15.
//
//  Generates media key events.  e.g.
//
//  [MediaKey send:NX_KEYTYPE_PLAY];
//  [MediaKey send:NX_KEYTYPE_NEXT];
//  [MediaKey send:NX_KEYTYPE_PREVIOUS];
//
//  Note that these DEFINEs are coming directly from ev_keymap.h ;)
//

#ifndef Spotify_Bluetooth_Headset_Listener_MediaKey_h
#define Spotify_Bluetooth_Headset_Listener_MediaKey_h

// required to send media "key" events
#import <CoreGraphics/CoreGraphics.h>
#import <IOKit/hidsystem/ev_keymap.h>

@interface MediaKey : NSObject
+ (void)send: (int)key; // send desired key (down) then (up) event
@end

#endif
