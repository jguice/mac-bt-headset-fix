//
//  AppDelegate.swift
//  bubo
//
//  Created by Josh on 11/10/16.
//  Copyright © 2016 Josh Guice. All rights reserved.
//

import Cocoa

import MediaPlayer

@available(OSX 10.12.2, *)
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // hidsystem/ev_keymap.h
    let NX_KEYTYPE_SOUND_UP   = 0
    let NX_KEYTYPE_SOUND_DOWN = 1
    let NX_KEYTYPE_PLAY       = 16
    let NX_KEYTYPE_NEXT       = 17
    let NX_KEYTYPE_PREVIOUS   = 18
    let NX_KEYTYPE_FAST       = 19
    let NX_KEYTYPE_REWIND     = 20
    
    fileprivate let remoteCommandCenter = MPRemoteCommandCenter.shared()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        remoteCommandCenter.playCommand.addTarget(self, action: #selector(AppDelegate.handlePlayPauseCommandEvent(_:)))
        remoteCommandCenter.pauseCommand.addTarget(self, action: #selector(AppDelegate.handlePlayPauseCommandEvent(_:)))
        remoteCommandCenter.stopCommand.addTarget(self, action: #selector(AppDelegate.handlePlayPauseCommandEvent(_:)))
        remoteCommandCenter.togglePlayPauseCommand.addTarget(self, action: #selector(AppDelegate.handlePlayPauseCommandEvent(_:)))
        
        remoteCommandCenter.nextTrackCommand.addTarget(self, action: #selector(AppDelegate.handleNextTrackCommandEvent(_:)))

        remoteCommandCenter.previousTrackCommand.addTarget(self, action: #selector(AppDelegate.handlePreviousTrackCommandEvent(event:)))
        
        remoteCommandCenter.seekForwardCommand.addTarget(self, action: #selector(AppDelegate.handleSeekForwardCommandEvent(event:)))

        remoteCommandCenter.seekBackwardCommand.addTarget(self, action: #selector(AppDelegate.handleSeekBackwardCommandEvent(event:)))

    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    func doKey(key: Int, down: Bool) {
        let flags = NSEventModifierFlags(rawValue: down ? 0xa00 : 0xb00)
        let data1 = (key << 16) | ((down ? 0xa : 0xb) << 8)
        
        let ev = NSEvent.otherEvent(
            with: NSEventType.systemDefined,
            location: NSPoint(x:0.0, y:0.0),
            modifierFlags: flags,
            timestamp: TimeInterval(0),
            windowNumber: 0,
            context: nil,
            // context: 0,
            subtype: 8,
            data1: data1,
            data2: -1
        )
        let cev = ev!.cgEvent!
        cev.post(tap: CGEventTapLocation(rawValue: 0)!)
    }


    func handlePlayPauseCommandEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        doKey(key: NX_KEYTYPE_PLAY, down: true)
        doKey(key: NX_KEYTYPE_PLAY, down: false)
        
        return .success
    }
    
    func handleNextTrackCommandEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        doKey(key: NX_KEYTYPE_NEXT, down: true)
        doKey(key: NX_KEYTYPE_NEXT, down: false)
        
        return .success
    }
    
    func handlePreviousTrackCommandEvent(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        doKey(key: NX_KEYTYPE_PREVIOUS, down: true)
        doKey(key: NX_KEYTYPE_PREVIOUS, down: false)
        
        return .success
    }
    
    func handleSeekForwardCommandEvent(event: MPSeekCommandEvent) -> MPRemoteCommandHandlerStatus {
        doKey(key: NX_KEYTYPE_FAST, down: true)
        
        return .success
    }
    
    func handleSeekBackwardCommandEvent(event: MPSeekCommandEvent) -> MPRemoteCommandHandlerStatus {
        doKey(key: NX_KEYTYPE_REWIND, down: true)
        
        return .success
    }

}

