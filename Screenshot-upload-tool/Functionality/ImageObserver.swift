//
//  ImageObserver.swift
//  Screenshot-upload-tool
//
//  Created by Andreas Jensen Jonassen on 18.02.2019.
//  Copyright © 2019 Andreas Jensen Jonassen. All rights reserved.
//

import Foundation
import AppKit

class ImageObserver: NSObject {
    
    func postFile(paths: [URL]) {
        let uploader = UploadAPI()
        for path in paths {
            let image: NSImage = NSImage(contentsOf: path)!
            let name = (path.path as NSString).lastPathComponent
            let path = path.pathExtension
            uploader.uploadImage(rawImage: image, type: path, name: name)
        }
    }
    
    init(path: String) {
        super.init()
        
        let allocator: CFAllocator? = kCFAllocatorDefault
        let callback: FSEventStreamCallback = {
            (streamRef, contextInfo, numEvents, eventPaths, eventFlags, eventIds) -> Void in
                let imageExtensions = ["png", "jpg", "jpeg", "gif", "tiff"]
                let observerSelf = Unmanaged<ImageObserver>.fromOpaque(contextInfo!).takeUnretainedValue()
                var _paths = [URL]()
                if let paths = unsafeBitCast(eventPaths, to: NSArray.self) as? [String] {
                    for i in 0...(numEvents-1) {
                        if(eventFlags[i] == 100352) {
                            let filepath = URL(fileURLWithPath: paths[i])
                            if(imageExtensions.contains(filepath.pathExtension)) {
                                _paths.append(filepath)
                            }
                        }
                    }
                }
                if(_paths.count != 0) {
                    observerSelf.postFile(paths: _paths)
                }
            
        }
        var context = FSEventStreamContext(version: 0, info: Unmanaged.passRetained(self).toOpaque(), retain: nil, release: nil, copyDescription: nil)
        let pathsToWatch: CFArray = [path] as CFArray
        print(pathsToWatch)
        let sinceWhen: FSEventStreamEventId = UInt64(kFSEventStreamEventIdSinceNow)
        let latency: CFTimeInterval = 1.0
        let flags: FSEventStreamCreateFlags = UInt32(kFSEventStreamCreateFlagUseCFTypes) | UInt32(kFSEventStreamCreateFlagFileEvents) | UInt32(kFSEventStreamEventFlagItemCreated)
        let eventStream = FSEventStreamCreate(
            allocator,
            callback,
            &context,
            pathsToWatch,
            sinceWhen,
            latency,
            flags
        )
        
        FSEventStreamScheduleWithRunLoop(eventStream!, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        FSEventStreamStart(eventStream!)
        
    }
}
