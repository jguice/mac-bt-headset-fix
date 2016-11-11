//
//  StatusMenuController.swift
//  bubo
//
//  Created by Josh on 11/10/16.
//  Copyright © 2016 Josh Guice. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true
        statusItem.image = icon
        
        statusItem.menu = statusMenu
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
}
