//
//  StatusMenuController.swift
//  Screenshot-upload-tool
//
//  Created by Andreas Jensen Jonassen on 18.02.2019.
//  Copyright © 2019 Andreas Jensen Jonassen. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var LinksListView: LinksListView!
    var linksListMenuItem: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    let screencapture = Screencapture()
    let config = Config()
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        linksListMenuItem = statusMenu.item(withTitle: "Links")
        linksListMenuItem.view = LinksListView
        
        _ = ImageObserver(path: NSHomeDirectory() + "/Desktop/")
    }
    
    @IBAction func fullscreenClicked(sender: NSMenuItem) {
        screencapture.takeFullscreen(path: "/Users/andreasjj/Desktop/" + UUID.init().uuidString, type: "png", quiet: true)
    }
    
    @IBAction func regionClicked(sender: NSMenuItem) {
        screencapture.takeRegion(path: "/Users/andreasjj/Desktop/" + UUID.init().uuidString, type: "png", quiet: true)
    }
    
    @IBAction func windowClicked(sender: NSMenuItem) {
        screencapture.takeWindow(path: "/Users/andreasjj/Desktop/" + UUID.init().uuidString, type: "png", quiet: true)
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
}
