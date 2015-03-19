//
//  MediaKey.m
//  Spotify Bluetooth Headset Listener
//
//  Created by Josh Guice on 3/15/15.
//

#import <Foundation/Foundation.h>
#import "MediaKey.h"

@implementation MediaKey

NSEvent* key_event;

// simulate a key press
+ (void) send: (int)key {
    // create and send down key event
    key_event = [NSEvent otherEventWithType:NSSystemDefined location:CGPointZero modifierFlags:0xa00 timestamp:0 windowNumber:0 context:0 subtype:8 data1:((key << 16) | (0xa << 8)) data2:-1];
    CGEventPost(0, key_event.CGEvent);
    NSLog(@"%d keycode (down) sent",key);

    // create and send up key event
    key_event = [NSEvent otherEventWithType:NSSystemDefined location:CGPointZero modifierFlags:0xb00 timestamp:0 windowNumber:0 context:0 subtype:8 data1:((key << 16) | (0xb << 8)) data2:-1];
    CGEventPost(0, key_event.CGEvent);
    NSLog(@"%d keycode (up) sent",key);
}

@end
