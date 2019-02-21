//
//  Config.swift
//  Screenshot-upload-tool
//
//  Created by Andreas Jensen Jonassen on 18.02.2019.
//  Copyright © 2019 Andreas Jensen Jonassen. All rights reserved.
//

import Foundation

class Config: NSObject {
    let defaults = UserDefaults.standard
    
    public func setNoiseOption(quite: Bool) {
        defaults.set(quite, forKey: "quite")
    }
    
    public func setSaveFolderLocation(location: URL) {
        defaults.set(location, forKey: "location")
    }
    
    public func getNoiseOption() -> Bool {
        let value = defaults.bool(forKey: "quite")
        if(value == false) {
            return false
        }
        return value
    }
    
    public func getSaveFolderLocation() -> URL {
        let value = defaults.url(forKey: "location")
        if(value == nil) {
            //return URL(fileURLWithPath: )
            return URL(fileURLWithPath: "~/Library/Application Support")
        } else {
           return value!
        }
    }
    
    public func getDefaultUploadURL() -> URL {
        var url = URLComponents()
        url.scheme = "http"
        url.host = "localhost"
        url.path = "/upload"
        url.port = 5000
        //let url = URL(string: "https://api.imgur.com/3/image")!
        let fallback = URL(string: "https://localhost")!
        guard let URL = url.url else {
            //TODO: ERROR HANDLING HERE
            return fallback
        }
        return URL;
    }
    
    public func getDefaultArguments() -> [String : String] {
        let arguments = ["username": "andreas", "password": "super-secret"]
        //let arguments = [String : String]()
        return arguments
    }
    
    public func getDefaultFileFormName() -> String {
        return "file"
    }
}

