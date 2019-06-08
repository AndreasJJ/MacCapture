//
//  preferencesView.swift
//  Screenshot-upload-tool
//
//  Created by Andreas Jensen Jonassen on 21.02.2019.
//  Copyright © 2019 Andreas Jensen Jonassen. All rights reserved.
//

import Cocoa
import AppKit

class PreferencesWindow: NSWindowController, NSWindowDelegate, NSTableViewDelegate, NSTableViewDataSource, NSTextFieldDelegate {
    @IBOutlet weak var tabView: NSTabView!
    
    @IBOutlet weak var keybindingsButton: NSButton!
    
    //Settings items
    @IBOutlet weak var quiteButton: NSButton!
    @IBOutlet weak var imageFormatList: NSPopUpButton!
    @IBOutlet weak var saveImage: NSButton!
    @IBOutlet weak var saveLocationInput: NSTextField!
    @IBOutlet weak var serverList: NSPopUpButton!
    
    //Server Configurations items
    @IBOutlet weak var customUploaderNameInput: NSTextField!
    @IBOutlet weak var customUploaderTable: NSTableView!
    @IBOutlet weak var customUploaderUploadUrlInput: NSTextField!
    @IBOutlet weak var customUploaderFileFormNameInput: NSTextField!
    @IBOutlet weak var customUploaderArgumentNameInput: NSTextField!
    @IBOutlet weak var customUploaderArgumentValueInput: NSTextField!
    @IBOutlet weak var customUploaderArgumentsTable: NSTableView!
    //Other variables
    let config = Config()
    
    var customUploaderTableData = [String]()
    var customUploaderArgumentsTableNameColumnData = [String]()
    var customUploaderArgumentsTableValueColumnData = [String]()
    
    var selectedServer = -1
    
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
            serverList.addItem(withTitle: serverConfig.name!)
        }
        self.customUploaderTable.reloadData()
        
        switch config.getNoiseOption() {
        case true:
            quiteButton.state = .on
            break
        case false:
            quiteButton.state = .off
            break
        }
        
        imageFormatList.selectItem(withTitle: config.getImageType())
        
        switch config.getSaveImage() {
        case true:
            saveImage.state = .on
            saveLocationInput.isEnabled = true
            break
        case false:
            saveImage.state = .off
            saveLocationInput.isEnabled = false
            break
        }
        
        saveLocationInput.stringValue = config.getSaveFolderLocation()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        self.window?.delegate = self
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
        cellView.textField?.isEditable = false
        cellView.textField?.isSelectable = false
        
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
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let table = notification.object as! NSTableView
        if(table.identifier?.rawValue == "customUploaderTable") {
            let serverConfigs = config.getServersConfig()
            
            customUploaderNameInput.stringValue = ""
            customUploaderUploadUrlInput.stringValue = ""
            customUploaderFileFormNameInput.stringValue = ""
            customUploaderArgumentNameInput.stringValue = ""
            customUploaderArgumentValueInput.stringValue = ""
            customUploaderArgumentsTableNameColumnData.removeAll()
            customUploaderArgumentsTableValueColumnData.removeAll()
            self.customUploaderArgumentsTable.reloadData()
            if(table.selectedRow >= serverConfigs.count || table.selectedRow < 0) {
                return
            }
            self.selectedServer = table.selectedRow
            let serverConfig = serverConfigs[table.selectedRow]
            print(serverConfig)
            customUploaderNameInput.stringValue = serverConfig.name ?? ""
            customUploaderUploadUrlInput.stringValue = serverConfig.uploadUrl?.absoluteString ?? ""
            customUploaderFileFormNameInput.stringValue = serverConfig.fileFormName ?? ""
            for argument in serverConfig.arguments ?? [String : String]() {
                customUploaderArgumentsTableNameColumnData.append(argument.key)
                customUploaderArgumentsTableValueColumnData.append(argument.value)
            }
            self.customUploaderArgumentsTable.reloadData()
        }
    }
    
    //Settings functions
    //Function for apply and save button on both settings and server configuration page
    @IBAction func clickedApplyAndSaveButton(_ sender: Any) {
        
    }
    
    //Server Configuration functions
    @IBAction func clickedCustomUploaderAddButton(_ sender: Any) {
        let newServerConfig = ServerConfig(context: PersistenceService.context)
        newServerConfig.name = customUploaderNameInput.stringValue
        PersistenceService.saveAction()
        customUploaderTableData.append(newServerConfig.name!)
        self.customUploaderTable.reloadData()
    }
    
    @IBAction func clickedCustomUploaderRemoveButton(_ sender: Any) {
        let server = customUploaderTable.selectedRow
        if(server < 0 || server >= config.getServersConfig().count) {
            return
        }
        PersistenceService.context.delete(config.getServersConfig()[server])
        customUploaderTableData.remove(at: server)
        PersistenceService.saveAction()
        self.customUploaderTable.reloadData()
    }
    
    @IBAction func clickedCustomUploaderUpdateButton(_ sender: Any) {
    }
    
    @IBAction func clickedCustomUploaderArgumentsAddButton(_ sender: Any) {
        let server = selectedServer
        if(server < 0 || server >= config.getServersConfig().count) {
            return
        }
        //
        let name = customUploaderArgumentNameInput.stringValue
        let value = customUploaderArgumentValueInput.stringValue
        var arguments = config.getServersConfig()[server].arguments ?? [String : String]()
        arguments.updateValue(value, forKey: name)
        config.getServersConfig()[server].arguments = arguments
        customUploaderArgumentsTableNameColumnData.append(name)
        customUploaderArgumentsTableValueColumnData.append(value)
        customUploaderArgumentNameInput.stringValue = ""
        customUploaderArgumentValueInput.stringValue = ""
        PersistenceService.saveAction()
        self.customUploaderArgumentsTable.reloadData()
    }
    
    @IBAction func clickedCustomUploaderArgumentsRemoveButton(_ sender: Any) {
        let server = selectedServer
        if(server < 0 || server >= config.getServersConfig().count) {
            return
        }
        //
        let row = customUploaderArgumentsTable.selectedRow
        if(row < 0) {
            return
        }
        let name = (customUploaderArgumentsTable.view(atColumn: 0, row: row, makeIfNecessary: false)?.subviews[0] as! NSTextField).stringValue
        config.getServersConfig()[server].arguments?.removeValue(forKey: name)
        customUploaderArgumentsTableNameColumnData.remove(at: row)
        customUploaderArgumentsTableValueColumnData.remove(at: row)
        PersistenceService.saveAction()
        self.customUploaderArgumentsTable.reloadData()
    }
    
    @IBAction func clickedCustomUploaderArgumentsUpdateButton(_ sender: Any) {
        
    }
    
    func controlTextDidEndEditing(_ notification: Notification) {
        let server = selectedServer
        if(server < 0 || server >= config.getServersConfig().count) {
            return
        }
        if let textField = notification.object as? NSTextField {
            let value = textField.stringValue
            if(textField.identifier?.rawValue == "requestURLInput") {
                config.getServersConfig()[server].uploadUrl = URL(string: value)
            } else if (textField.identifier?.rawValue == "fileFormNameInput") {
                config.getServersConfig()[server].fileFormName = value
            } else if (textField.identifier?.rawValue == "saveFolderInput") {
                config.setSaveFolderLocation(location: value)
            }
        }
    }
    
    @IBAction func popUpSelectionDidChange(_ sender: NSPopUpButton) {
        if(sender.identifier?.rawValue == "imageFormatList") {
            config.setImageType(type: sender.selectedItem?.title ?? "png")
        } else if(sender.identifier?.rawValue == "serverList") {
            if(config.getServersConfig().count == 0) {
                return
            } else if(config.getServersConfig().count == 1) {
                config.setDefaultServerConfig(ServerConfig: config.getServersConfig()[0])
            }
            for server in config.getServersConfig() {
                if(server.name == sender.selectedItem?.title) {
                    config.setDefaultServerConfig(ServerConfig: server)
                }
            }
        }
    }
    
    @IBAction func quiteButtonDidChange(_ sender: NSButton) {
        switch sender.state {
        case .on:
            config.setNoiseOption(quite: true)
            break
        case .off:
            config.setNoiseOption(quite: false)
        default:
            config.setNoiseOption(quite: false)
        }
    }
    
    @IBAction func saveImageButtonDidChange(_ sender: NSButton) {
        switch sender.state {
        case .on:
            config.setSaveImage(option: true)
            saveLocationInput.isEnabled = true
            break
        case .off:
            config.setSaveImage(option: false)
            saveLocationInput.isEnabled = false
        default:
            config.setSaveImage(option: false)
            saveLocationInput.isEnabled = false
        }
    }
    
    func windowWillClose(_ notification: Notification) {
        let server = selectedServer
        if(server < 0 || server >= config.getServersConfig().count) {
            return
        }
        
        switch quiteButton.state {
        case .on:
            config.setNoiseOption(quite: true)
            break
        case .off:
            config.setNoiseOption(quite: false)
        default:
            config.setNoiseOption(quite: false)
        }
        config.setImageType(type: imageFormatList.titleOfSelectedItem ?? "png")
        config.setSaveFolderLocation(location: saveLocationInput.stringValue)
        if(config.getServersConfig().count == 1) {
            config.setDefaultServerConfig(ServerConfig: config.getServersConfig()[0])
        }
        for server in config.getServersConfig() {
            if(server.name == serverList.selectedItem?.title) {
                config.setDefaultServerConfig(ServerConfig: server)
            }
        }
        //Server Configurations items
        config.getServersConfig()[server].name = customUploaderNameInput.stringValue
        config.getServersConfig()[server].uploadUrl = URL(string: customUploaderUploadUrlInput.stringValue)
        config.getServersConfig()[server].fileFormName = customUploaderFileFormNameInput.stringValue
        
    }
    
}
