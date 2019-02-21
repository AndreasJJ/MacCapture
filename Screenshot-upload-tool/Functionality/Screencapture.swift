//
//  Screencapture.swift
//  Screenshot-upload-tool
//
//  Created by Andreas Jensen Jonassen on 19.02.2019.
//  Copyright © 2019 Andreas Jensen Jonassen. All rights reserved.
//

import Foundation

class Screencapture: NSObject {
    public func takeFullscreen(path: String, type: String, quiet: Bool=false) {
        let task = Process()
        let pipe = Pipe()
        
        task.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
        
        var arguments = [String]()
        quiet ? arguments.append("-x") : nil
        arguments.append(path + UUID.init().uuidString + "." + type)
        
        task.arguments = arguments
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
    }
    
    public func takeRegion(path: String, type: String, quiet: Bool=false) {
        let task = Process()
        let pipe = Pipe()
        task.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
        
        var arguments = [String]()
        quiet ? arguments.append("-x") : nil
        arguments.append("-i")
        arguments.append(path + UUID.init().uuidString + "." + type)
        
        task.arguments = arguments
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
    }
    
    public func takeWindow(path: String, type: String, quiet: Bool=false) {
        let task = Process()
        let pipe = Pipe()
        task.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
        
        var arguments = [String]()
        quiet ? arguments.append("-x") : nil
        arguments.append("-w")
        arguments.append(path + UUID.init().uuidString + "." + type)
        
        task.arguments = arguments
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
    }
}
