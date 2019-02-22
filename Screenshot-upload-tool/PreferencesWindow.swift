//
//  preferencesView.swift
//  Screenshot-upload-tool
//
//  Created by Andreas Jensen Jonassen on 21.02.2019.
//  Copyright © 2019 Andreas Jensen Jonassen. All rights reserved.
//

import Cocoa
import AppKit

class PreferencesWindow: NSWindowController, NSTableViewDelegate, NSTableViewDataSource {
    //Settings items
    @IBOutlet weak var quiteButton: NSButton!
    @IBOutlet weak var imageFormatList: NSPopUpButton!
    @IBOutlet weak var saveLocationInput: NSTextField!
    //Server Configurations items
    @IBOutlet weak var customUploaderNameInput: NSTextFieldCell!
    @IBOutlet weak var customUploaderTable: NSTableView!
    @IBOutlet weak var customUploaderUploadUrlInput: NSTextField!
    @IBOutlet weak var customUploaderFileFormNameInput: NSTextField!
    @IBOutlet weak var customUploaderArgumentNameInput: NSTextField!
    @IBOutlet weak var customUploaderArgumentValueInput: NSTextField!
    @IBOutlet weak var CustomUploaderArgumentsTable: NSTableView!
    //Other variables
    let config = Config()
    
    let customUploaderTableData = ["item1", "item2", "item3"]
    let customUploaderArgumentsTableData = ["item1", "item2"]
    
    override var windowNibName : String! {
        return "PreferencesWindow"
    }
    
    override func awakeFromNib() {
        //Setup Settings page
        quiteButton.state = config.getNoiseOption() ? NSControl.StateValue.on : NSControl.StateValue.off
        imageFormatList.selectItem(withTitle: config.getImageType())
        saveLocationInput.stringValue = config.getSaveFolderLocation()
        //Setup Server Configurations page
        customUploaderTable.beginUpdates()
        customUploaderTable.headerView = nil;
        customUploaderTable.endUpdates()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if (tableView.identifier?.rawValue == "customUploaderTable") {
            return customUploaderTableData.count
        } else if (tableView.identifier?.rawValue == "customUploaderArgumentsTable") {
            return customUploaderArgumentsTableData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = NSTableCellView()
        if (tableView.identifier?.rawValue == "customUploaderTable") {
            let cell = NSTextFieldCell()
            cellView.identifier = NSUserInterfaceItemIdentifier(rawValue: String(row))
        } else if (tableView.identifier?.rawValue == "customUploaderArgumentsTable") {
            let cell = NSTextFieldCell()
            cellView.identifier = NSUserInterfaceItemIdentifier(rawValue: String(row))
        } else {
            return nil
        }
        return cellView
    }
    
    //Settings functions
    //Function for apply and save button on both settings and server configuration page
    @IBAction func clickedApplyAndSaveButton(_ sender: Any) {
        
    }
    //Server Configuration functions
    @IBAction func clickedCustomUploaderAddButton(_ sender: Any) {
        print("works")
        //customUploaderTable.beginUpdates()
        //customUploaderTable.insertRows(at: [IndexPath(item: customUploaderTable.numberOfRows-1, section: 0)], withAnimation: .automatic)
        //customUploaderTable.endUpdates()
    }
    
    @IBAction func clickedCustomUploaderRemoveButton(_ sender: Any) {
    }
    
    @IBAction func clickedCustomUploaderUpdateButton(_ sender: Any) {
    }
    
    @IBAction func clickedCustomUploaderArgumentsAddButton(_ sender: Any) {
    }
    
    @IBAction func clickedCustomUploaderArgumentsRemoveButton(_ sender: Any) {
    }
    
    @IBAction func clickedCustomUploaderArgumentsUpdateButton(_ sender: Any) {
    }
    
    func windowWillClose(_ notification: Notification) {

    }
    
}
