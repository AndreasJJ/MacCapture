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
    
    var customUploaderTableData = [String]()
    var customUploaderArgumentsTableNameColumnData = [String]()
    var customUploaderArgumentsTableValueColumnData = [String]()
    
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
        for serverConfig in config.getServersConfig() {
            if(serverConfig.name == nil) {
                continue
            }
            customUploaderTableData.append(serverConfig.name!)
        }
        self.customUploaderTable.reloadData()
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
            return customUploaderArgumentsTableNameColumnData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = NSTableCellView()
        let textField = NSTextField()
        cellView.addSubview(textField, positioned: NSWindow.OrderingMode.above, relativeTo: nil)
        cellView.textField = cellView.subviews[0] as? NSTextField
        let newSize = CGSize(width: tableView.frameOfCell(atColumn: 0, row: 0).width, height:  tableView.frameOfCell(atColumn: 0, row: 0).height)
        let newFrame = CGRect(origin: CGPoint.init(x: 0.0, y: 0.0), size: newSize)
        cellView.textField!.frame = newFrame
        
        cellView.textField?.alignment = .center
        cellView.textField?.usesSingleLineMode = true
        cellView.identifier = NSUserInterfaceItemIdentifier(rawValue: String(row))
        
        if (tableView.identifier?.rawValue == "customUploaderTable") {
            cellView.textField?.stringValue = customUploaderTableData[row]
        } else if (tableView.identifier?.rawValue == "customUploaderArgumentsTable") {
            if(tableColumn?.identifier.rawValue == "customUploaderArgumentsTableNameColumn") {
                cellView.textField?.stringValue = customUploaderArgumentsTableNameColumnData[row]
            } else if (tableColumn?.identifier.rawValue == "customUploaderArgumentsTableValueColumn") {
                cellView.textField?.stringValue = customUploaderArgumentsTableValueColumnData[row]
            } else {
                return nil
            }
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
