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
    var preferencesWindow: PreferencesWindow!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    let screencapture = Screencapture()
    let config = Config()
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        preferencesWindow = PreferencesWindow()
        
        _ = ImageObserver(path: config.getSaveFolderLocation(), callback: postFile)
        
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if(!accessEnabled) {
            print("failed")
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
        }
    }
    
    func keyDown(with event: NSEvent) {
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [.shift, .command] where event.keyCode == 20:
            screencapture.takeRegion(path: config.getSaveFolderLocation() + "/" + UUID.init().uuidString, type: config.getImageType(), quiet: config.getNoiseOption())
            break
        case [.shift, .command] where event.keyCode == 21:
            screencapture.takeFullscreen(path: config.getSaveFolderLocation() + "/" + UUID.init().uuidString, type: config.getImageType(), quiet: config.getNoiseOption())
            break
        default:
            break
        }
    }
    
    func postFile(paths: [URL]) {
        print(paths)
        let uploader = UploadAPI()
        for path in paths {
            let image: NSImage = NSImage(contentsOf: path)!
            let name = (path.path as NSString).lastPathComponent
            let extention = path.pathExtension
            uploader.uploadImage(rawImage: image, type: extention, name: name, url: config.getDefaultUploadURL(), arguments: config.getDefaultArguments(), fileFormName: config.getDefaultFileFormName())
            if(!config.getDefaultSaveImage()) {
                do {
                    try FileManager.default.removeItem(at: path)
                } catch {
                    //Add error handler
                    print(error)
                }
            }
        }
    }
    
    @IBAction func fullscreenClicked(sender: NSMenuItem) {
        screencapture.takeFullscreen(path: config.getSaveFolderLocation() + "/" + UUID.init().uuidString, type: config.getImageType(), quiet: config.getNoiseOption())
    }
    
    @IBAction func regionClicked(sender: NSMenuItem) {
        screencapture.takeRegion(path: config.getSaveFolderLocation() + "/" + UUID.init().uuidString, type: config.getImageType(), quiet: config.getNoiseOption())
    }
    
    @IBAction func windowClicked(sender: NSMenuItem) {
        screencapture.takeWindow(path: config.getSaveFolderLocation() + "/" + UUID.init().uuidString, type: config.getImageType(), quiet: config.getNoiseOption())
    }
    
    @IBAction func preferencesClicked(sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
}
