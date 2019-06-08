//
//  Config.swift
//  Screenshot-upload-tool
//
//  Created by Andreas Jensen Jonassen on 18.02.2019.
//  Copyright © 2019 Andreas Jensen Jonassen. All rights reserved.
//

import Foundation
import CoreData

class Config: NSObject {
    let defaults = UserDefaults.standard
    var appConfig = [AppConfig]()
    var serversConfig = [ServerConfig]()
    
    public override init() {
        let fetchrequest: NSFetchRequest<AppConfig> = AppConfig.fetchRequest()
        let serversFetchRequest: NSFetchRequest<ServerConfig> = ServerConfig.fetchRequest()
        
        do {
            self.serversConfig = try PersistenceService.context.fetch(serversFetchRequest)
        }catch {}
        
        do {
            let appConfig = try PersistenceService.context.fetch(fetchrequest)
            if(appConfig.count == 0) {
                let _appConfig = AppConfig(context: PersistenceService.context)
                _appConfig.imageType = "png"
                _appConfig.saveFolder = NSHomeDirectory() + "/Desktop/"
                /*_appConfig.defaultServerConfig = ServerConfig(context: PersistenceService.context)
                _appConfig.defaultServerConfig?.name = "Test"
                var url = URLComponents()
                url.scheme = "http"
                url.host = "localhost"
                url.path = "/upload"
                url.port = 5000
                //_appConfig.defaultServerConfig!.uploadUrl = URL(fileURLWithPath: "localhost")
                _appConfig.defaultServerConfig!.uploadUrl = url.url!
                //_appConfig.defaultServerConfig!.arguments = [String : String]()
                _appConfig.defaultServerConfig!.arguments = ["username" : "andreas", "password" : "super-secret"]
                _appConfig.defaultServerConfig!.fileFormName = "file"*/
                var _appConfigArr = [AppConfig]()
                _appConfigArr.append(_appConfig)
                self.appConfig = _appConfigArr
            } else {
                self.appConfig = appConfig
            }
        } catch {
            print("Oh no!")
        }
    }
    
    public func getServersConfig() -> [ServerConfig] {
        return self.serversConfig
    }
    
    public func setNoiseOption(quite: Bool) {
        appConfig[0].noise = quite
        PersistenceService.saveAction()
    }
    
    public func setImageType(type: String) {
        appConfig[0].imageType = type
        PersistenceService.saveAction()
    }
    
    public func setSaveImage(option: Bool) {
        appConfig[0].saveImage = option
        PersistenceService.saveAction()
    }
    
    public func setSaveFolderLocation(location: String) {
        appConfig[0].saveFolder = location
        PersistenceService.saveAction()
    }
    
    public func setDefaultServerConfig(ServerConfig: ServerConfig) {
        appConfig[0].defaultServerConfig = ServerConfig
        PersistenceService.saveAction()
    }
    
    public func getNoiseOption() -> Bool {
        return appConfig[0].noise
    }
    
    public func getImageType() -> String {
        return appConfig[0].imageType ?? "png"
    }
    
    public func getSaveImage() -> Bool {
        return appConfig[0].saveImage
    }
    
    public func getSaveFolderLocation() -> String {
        return appConfig[0].saveFolder ?? NSHomeDirectory() + "/Desktop/"
    }
    
    public func getDefaultSaveImage() -> Bool {
        return appConfig[0].saveImage
    }
    
    public func getDefaultUploadURL() -> URL {
        return appConfig[0].defaultServerConfig?.uploadUrl ?? URL(fileURLWithPath: "https://localhost")
    }
    
    public func getDefaultArguments() -> [String : String] {
        return appConfig[0].defaultServerConfig?.arguments ?? [String : String]()
    }
    
    public func getDefaultFileFormName() -> String {
        return appConfig[0].defaultServerConfig?.fileFormName ?? "file"
    }
}

