//
//  AppConfig+CoreDataProperties.swift
//  Screenshot-upload-tool
//
//  Created by Andreas Jensen Jonassen on 21.02.2019.
//  Copyright © 2019 Andreas Jensen Jonassen. All rights reserved.
//
//

import Foundation
import CoreData


extension AppConfig {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppConfig> {
        return NSFetchRequest<AppConfig>(entityName: "AppConfig")
    }

    @NSManaged public var imageType: String?
    @NSManaged public var noise: Bool
    @NSManaged public var saveFolder: String?
    @NSManaged public var defaultServerConfig: ServerConfig?

}